/// UiVirtualTreeview - virtual-scrolling tree view with pooling, lazy offsets, and binary search.
///
/// Props:
///   value               - array of tree-node structs (each: { children, collapsed, name, ... })
///   estimatedRowHeight  - fallback height for unmeasured rows (default 32)
///   buffer              - extra rows above / below the visible window (default 5)
///   renderItem          - function(index) returns a UiNode (called once per pool slot)
///   onBind              - function(index, flatEntry, node) updates an existing node
///   onToggle            - function(index, flatEntry, node) called when the arrow is clicked
///   scrollbarColor      - passed through to enableScrollbar()
///
/// Style: standard UiNode flexbox. `flexDirection: "column"` is assumed.
///
function UiVirtualTreeview(style = {}, props = {}) : UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "UiVirtualTreeview");

    // ── Props ──
    self.value                  = props[$ "value"] ?? [];
    self.__estimatedRowHeight   = props[$ "estimatedRowHeight"] ?? 32;
    self.__buffer               = props[$ "buffer"] ?? 5;
    self.__renderItem           = props[$ "renderItem"];
    self.onBind                 = props[$ "onBind"];
    self.__onToggle             = props[$ "onToggle"];

    // ── Internal state ──
    self.__flatData             = [];
    self.__poolSize             = 0;
    self.__pool                 = [];
    self.__spacerTop            = undefined;
    self.__spacerBottom         = undefined;
    self.__visibleStart         = -1;
    self.__visibleEnd           = -1;
    self.__prevScrollTop        = 0;
    self.__recyclePending       = true;
    self.__recycleCounter       = 0;
    self.__measureScheduled     = false;
    self.__bindingsChanged      = false;

    // Virtual container: lazy offset cache + binary search
    self.__virtualContainer = new UiVirtualContainer(
        array_length(self.__flatData),
        self.__estimatedRowHeight
    );

    // ── Calculate pool size ──
    var _rawH = style[$ "height"];
    var _containerH = 400;
    if (is_real(_rawH)) {
        _containerH = _rawH;
    } else if (is_string(_rawH) && string_pos("%", _rawH) == 0) {
        _containerH = real(_rawH);
    }
    var _minItemH = max(20, self.__estimatedRowHeight * 0.5);
    var _maxVisible = ceil(_containerH / _minItemH);
    self.__poolSize = clamp(_maxVisible + self.__buffer * 2, 4, 200);

    // ── Build children: spacerTop + pool nodes + spacerBottom ──
    self.__spacerTop = new UiNode({ width: "100%", height: 0, flexShrink: 0 }, { pointerEvents: false });
    self.add(self.__spacerTop);

    for (var i = 0; i < self.__poolSize; i++) {
        var node;
        if (self.__renderItem != undefined) {
            var wrapper = new UiNode({ width: "100%", flexShrink: 0 });
            var content = self.__renderItem(i);
            wrapper.__virtualContent = content;
            wrapper.add(content);
            node = wrapper;
        } else {
            node = self.__createDefaultRow(i);
        }
        node.__virtualIndex = -1;
        node.__bindCycle = -1;
        node.hide();
        self.__pool[i] = node;
        self.add(node);
    }

    self.__spacerBottom = new UiNode({ width: "100%", height: 0, flexShrink: 0 }, { pointerEvents: false });
    self.add(self.__spacerBottom);

    // ── Scrollbar ──
    self.enableScrollbar(props[$ "scrollbarColor"]);

    // ── Flat data + initial render ──
    self.__rebuild();

    // ── Step handler ──
    self.onStep(function(layoutUpdated) {
        if (self.__recyclePending) {
            self.__virtualContainer.__lastMeasuredIndex = -1;
        }

        if (self.__measureScheduled && layoutUpdated) {
            self.__measureHeights();
            self.__measureScheduled = false;
        }

        if (self.__recyclePending || layoutUpdated || self.__prevScrollTop != self.scrollTop) {
            self.__prevScrollTop = self.scrollTop;
            self.__recycle();
            self.__recyclePending = false;
            if (self.__bindingsChanged) {
                self.__measureScheduled = true;
            }
        }
    });

    // ═════════════════════════════════════════════════════════════════════════
    //  Default row template (used when renderItem is not provided)
    // ═════════════════════════════════════════════════════════════════════════

    static __createDefaultRow = function(slotIndex) {
        var row = new UiNode({ width: "100%", height: self.__estimatedRowHeight, flexShrink: 0, flexDirection: "row", alignItems: "center" });
        row.__slotIndex = slotIndex;

        // Arrow toggle
        var arrow = new UiNode({ width: 20, height: 20, flexShrink: 0, justifyContent: "center", alignItems: "center" }, { pointerEvents: true, handpoint: true });
        arrow.__treeview = self;
        arrow.onDraw = method(arrow, function() {
            if (self.__entry == undefined || !self.__entry.expandable) return;
            var mx = (self.x1 + self.x2) / 2;
            var my = (self.y1 + self.y2) / 2;
            draw_set_color(self.__entry.node.collapsed ? global.UI_COL_TEXT_2 : global.UI_COL_TEXT_1);
            if (self.__entry.node.collapsed) {
                draw_triangle(mx - 3, my - 4, mx - 3, my + 4, mx + 3, my, false);
            } else {
                draw_triangle(mx - 4, my - 3, mx + 4, my - 3, mx, my + 3, false);
            }
        });
        arrow.onClick(method({ treeview: self, row: row }, function() {
            var idx = self.row.__virtualIndex;
            if (idx >= 0 && idx < array_length(self.treeview.__flatData)) {
                self.treeview.__toggleEntry(idx);
            }
        }));
        arrow.onDoubleClick(method({}, function() { return true; }));
        row.add(arrow);
        row.__arrow = arrow;

        // Icon
        var icon = new UiNode({ width: 20, height: 20, flexShrink: 0, marginLeft: 4, marginRight: 8 });
        icon.__treeview = self;
        icon.onDraw = method(icon, function() {
            if (self.__entry == undefined) return;
            var mx = (self.x1 + self.x2) / 2;
            var my = (self.y1 + self.y2) / 2;
            if (self.__entry.node.icon != undefined && self.__entry.node.icon != -1) {
                var _sw = sprite_get_width(self.__entry.node.icon);
                var _sh = sprite_get_height(self.__entry.node.icon);
                var _scale = min(16 / _sw, 16 / _sh);
                draw_sprite_ext(self.__entry.node.icon, 0, mx, my, _scale, _scale, 0, global.UI_COL_TEXT_1, 1);
            } else {
                if (self.__entry.node.assetType == "Folder") {
                    draw_set_color(self.__entry.node.collapsed ? #F59E0B : #FCD34D);
                    draw_rectangle(self.x1 + 2, self.y1 + 6, self.x2 - 2, self.y2 - 4, false);
                    draw_rectangle(self.x1 + 2, self.y1 + 4, self.x1 + 10, self.y1 + 6, false);
                } else {
                    draw_set_color(#6366F1);
                    draw_rectangle(self.x1 + 4, self.y1 + 4, self.x2 - 4, self.y2 - 4, false);
                }
            }
        });
        row.add(icon);
        row.__icon = icon;

        // Label
        var label = new UiNode({ flex: 1, height: "100%", justifyContent: "center" });
        label.__treeview = self;
        label.onDraw = method(label, function() {
            if (self.__entry == undefined) return;
            draw_set_color(global.UI_COL_TEXT_1);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(self.x1 + 4, ~~mean(self.y1, self.y2), self.__entry.node.name ?? "");
        });
        row.add(label);
        row.__label = label;

        // Selection + hover highlight
        row.onDraw = method(row, function() {
            if (self.__entry == undefined) return;
            if (self.__entry[$ "selected"]) {
                draw_set_color(global.UI_COL_PRIMARY);
                draw_set_alpha(0.3);
                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
                draw_set_alpha(1);
            } else if (self.hovered) {
                draw_set_color(global.UI_COL_HOVER);
                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
            }
        });
        row.onMouseEnter(function() { global.UI.requestRedraw(); });
        row.onMouseLeave(function() { global.UI.requestRedraw(); });
        row.onMouseDown(method({ treeview: self, row: row }, function() {
            var idx = self.row.__virtualIndex;
            if (idx >= 0 && idx < array_length(self.treeview.__flatData)) {
                self.treeview.__selectEntry(idx);
            }
        }));
        row.onDoubleClick(method({ treeview: self, row: row }, function() {
            var idx = self.row.__virtualIndex;
            if (idx >= 0 && idx < array_length(self.treeview.__flatData)) {
                var entry = self.treeview.__flatData[idx];
                if (entry.expandable) {
                    self.treeview.__toggleEntry(idx);
                }
            }
        }));

        return row;
    };

    // ═════════════════════════════════════════════════════════════════════════
    //  Internal methods
    // ═════════════════════════════════════════════════════════════════════════

    /// Flatten the tree into a depth-first array using an explicit stack.
    static __flatten = function(nodes, depth, out) {
        var stack = [{ nodes: nodes, depth: depth, idx: 0 }];
        while (array_length(stack) > 0) {
            var frame = stack[array_length(stack) - 1];
            if (frame.idx >= array_length(frame.nodes)) {
                array_pop(stack);
                continue;
            }
            var node = frame.nodes[frame.idx];
            frame.idx++;
            array_push(out, { node: node, depth: frame.depth, expandable: array_length(node[$ "children"]) > 0 });
            if (!node[$ "collapsed"] && array_length(node[$ "children"]) > 0) {
                array_push(stack, { nodes: node.children, depth: frame.depth + 1, idx: 0 });
            }
        }
    };

    /// Rebuild flat data from `self.value`.
    static __rebuild = function() {
        var newFlat = [];
        self.__flatten(self.value, 0, newFlat);
        self.__flatData = newFlat;
        // Preserve existing height measurements; only resize the cache
        self.__virtualContainer.resize(array_length(newFlat));
        self.__recyclePending = true;
        // Invalidate pool bindings so __recycle rebinds every visible node
        // (after rebuild, the same pool index may map to a different entry)
        for (var i = 0; i < array_length(self.__pool); i++) {
            self.__pool[i].__virtualIndex = -1;
        }
        global.UI.requestUpdate();
        global.UI.requestRedraw();
    };

    /// Toggle expand / collapse for a flat entry.
    static __toggleEntry = function(flatIndex) {
        if (flatIndex < 0 || flatIndex >= array_length(self.__flatData)) return;
        var entry = self.__flatData[flatIndex];
        if (!entry.expandable) return;
        entry.node[$ "collapsed"] = !entry.node[$ "collapsed"];
        if (self.__onToggle != undefined) self.__onToggle(flatIndex, entry);
        self.__rebuild();
    };

    /// Select an entry.
    static __selectEntry = function(flatIndex) {
        for (var i = 0; i < array_length(self.__flatData); i++) {
            self.__flatData[i][$ "selected"] = (i == flatIndex);
        }
        if (flatIndex >= 0 && flatIndex < array_length(self.__flatData) && self.__onItemSelected != undefined) {
            self.__onItemSelected(self.__flatData[flatIndex].node);
        }
        global.UI.requestRedraw();
    };

    self.__onItemSelected = undefined;

    /// Measure layout heights of visible pool nodes.
    static __measureHeights = function() {
        for (var i = 0; i < self.__poolSize; i++) {
            var node = self.__pool[i];
            if (node.__virtualIndex >= 0 && node.display &&
                node.__bindCycle == self.__recycleCounter && !node.__measuredThisCycle) {
                var measured = node.__virtualContent ?? node;
                self.__virtualContainer.setItemHeight(node.__virtualIndex, measured.layout.height);
                node.__measuredThisCycle = true;
            }
        }
    };

    /// Recycle: bind pool nodes to the correct flat indices.
    static __recycle = function() {
        var dataLen = array_length(self.__flatData);
        var containerHeight = self.layout.height;

        if (dataLen == 0 || containerHeight <= 0) {
            for (var i = 0; i < self.__poolSize; i++) {
                self.__pool[i].hide();
                self.__pool[i].__virtualIndex = -1;
            }
            self.__spacerTop.setHeight(0);
            self.__spacerBottom.setHeight(0);
            self.__visibleStart = -1;
            self.__visibleEnd = -1;
            return;
        }

        self.__recycleCounter++;
        self.__bindingsChanged = false;

        var scrollTop = self.scrollTop;

        var firstVisible = self.__virtualContainer.findNearestItem(scrollTop);
        var lastVisible  = self.__virtualContainer.findNearestItem(scrollTop + containerHeight);

        var startIndex = max(0, firstVisible - self.__buffer);
        var endIndex   = min(dataLen - 1, lastVisible + self.__buffer);

        var needed = endIndex - startIndex + 1;
        if (needed > self.__poolSize) {
            endIndex = startIndex + self.__poolSize - 1;
        }

        // ── (A) Bind pool slots to data indices ──
        var poolIdx = 0;
        for (var i = startIndex; i <= endIndex; i++) {
            var node = self.__pool[poolIdx];
            var bindNode = node.__virtualContent ?? node;

            if (node.__virtualContent == undefined) {
                node.setHeight(self.__virtualContainer.getItemHeight(i));
            }

            if (node.__virtualIndex != i) {
                node.__virtualIndex    = i;
                node.__bindCycle       = self.__recycleCounter;
                node.__measuredThisCycle = false;

                // Update depth padding and assign entry data to sub-nodes
                var entry = self.__flatData[i];
                if (node.__virtualContent != undefined) {
                    // Custom renderItem; pass entry via onBind
                    if (self.onBind != undefined) {
                        self.onBind(i, entry, bindNode, self);
                        self.__bindingsChanged = true;
                    }
                } else {
                    var pLeft = 4 + entry.depth * 16;
                    flexpanel_node_style_set_padding(node.node, flexpanel_edge.left, pLeft);
                    node.layout.paddingLeft = pLeft;
                    self.__bindEntryToDefaultRow(node, entry, i);
                }
            }

            node.show();
            poolIdx++;
        }

        // Hide surplus pool slots
        for (; poolIdx < self.__poolSize; poolIdx++) {
            self.__pool[poolIdx].hide();
            self.__pool[poolIdx].__virtualIndex = -1;
        }

        // ── (B) Reposition spacers ──
        var topOffset    = startIndex > 0 ? self.__virtualContainer.getItemOffset(startIndex) : 0;
        var endOffset    = self.__virtualContainer.getItemOffset(endIndex) + self.__virtualContainer.getItemHeight(endIndex);
        var totalSize    = self.__virtualContainer.getTotalContentSize();

        self.__spacerTop.setHeight(topOffset);
        self.__spacerBottom.setHeight(max(0, totalSize - endOffset));

        self.__visibleStart = startIndex;
        self.__visibleEnd   = endIndex;
    };

    /// Bind entry data to the sub-nodes of a default row.
    static __bindEntryToDefaultRow = function(row, entry, flatIndex) {
        // Arrow visibility + entry data
        if (row.__arrow != undefined) {
            row.__arrow.visible = entry.expandable;
            row.__arrow.__entry = entry;
        }
        if (row.__icon != undefined) row.__icon.__entry = entry;
        if (row.__label != undefined) row.__label.__entry = entry;
        row.__entry = entry;
        row.__entryIndex = flatIndex;
    };

    // ═════════════════════════════════════════════════════════════════════════
    //  Public API – tree-node level (not flat-index level)
    // ═════════════════════════════════════════════════════════════════════════

    /// Total virtual content height (used by UiScrollbar internally).
    static getContentSize = function() {
        return self.__virtualContainer.getTotalContentSize();
    };

    /// Scroll so that the flat entry at `index` is at the top (low-level).
    static scrollToIndex = function(index) {
        var dataLen = array_length(self.__flatData);
        if (dataLen == 0) return;
        index = clamp(index, 0, dataLen - 1);
        self.scrollTop = self.__virtualContainer.getItemOffset(index);
        self.__prevScrollTop = self.scrollTop;
        global.UI.requestUpdate();
        global.UI.requestRedraw();
    };

    /// Replace the tree dataset and rebuild flat data.
    self.setValue = function(newValue) {
        if (self.value == newValue) return self;
        self.value = newValue;
        self.__rebuild();
        var _listeners = self.__valueChangeListeners;
        for (var i = 0; i < array_length(_listeners); i++) {
            _listeners[i](newValue, self);
        }
        return self;
    };

    /// Expand all nodes deeply.
    function expandAll() {
        for (var i = 0; i < array_length(self.value); i++) {
            self.__expandDeep(self.value[i]);
        }
        self.__rebuild();
    }

    /// Collapse all nodes deeply.
    function collapseAll() {
        for (var i = 0; i < array_length(self.value); i++) {
            self.__collapseDeep(self.value[i]);
        }
        self.__rebuild();
    }

    // ── Node-level operations ──

    /// Select a tree node. Expands ancestors to make it visible if needed.
    function select(node) {
        self.__ensureVisible(node);
        for (var i = 0; i < array_length(self.__flatData); i++) {
            if (self.__flatData[i].node == node) {
                self.__selectEntry(i);
                return;
            }
        }
    }

    /// Returns the currently selected tree node, or undefined.
    function getSelected() {
        for (var i = 0; i < array_length(self.__flatData); i++) {
            if (self.__flatData[i][$ "selected"]) {
                return self.__flatData[i].node;
            }
        }
        return undefined;
    }

    /// Expand a single tree node (does NOT expand its children).
    function expand(node) {
        if (array_length(node[$ "children"]) > 0) {
            node[$ "collapsed"] = false;
            self.__rebuild();
        }
    }

    /// Collapse a single tree node (does NOT collapse its children).
    function collapse(node) {
        if (array_length(node[$ "children"]) > 0) {
            node[$ "collapsed"] = true;
            self.__rebuild();
        }
    }

    /// Scroll to make a node visible. Expands ancestors if needed.
    function scrollToNode(node) {
        self.__ensureVisible(node);
        for (var i = 0; i < array_length(self.__flatData); i++) {
            if (self.__flatData[i].node == node) {
                self.scrollToIndex(i);
                return;
            }
        }
    }

    // ── Internal helpers ──

    /// Find the flat index of a tree node, or -1 if not visible.
    static __findFlatIndex = function(node) {
        for (var i = 0; i < array_length(self.__flatData); i++) {
            if (self.__flatData[i].node == node) return i;
        }
        return -1;
    };

    /// Expand ancestors so `node` becomes visible in flat data.
    static __ensureVisible = function(node) {
        if (self.__findFlatIndex(node) >= 0) return;
        var stack = [{ nodes: self.value, idx: 0, ancestors: [] }];
        while (array_length(stack) > 0) {
            var frame = stack[array_length(stack) - 1];
            if (frame.idx >= array_length(frame.nodes)) {
                array_pop(stack);
                continue;
            }
            var n = frame.nodes[frame.idx];
            frame.idx++;
            if (n == node) {
                var ancestors = frame.ancestors;
                if (array_length(ancestors) > 0) {
                    var changed = false;
                    for (var i = 0; i < array_length(ancestors); i++) {
                        if (ancestors[i][$ "collapsed"]) {
                            ancestors[i][$ "collapsed"] = false;
                            changed = true;
                        }
                    }
                    if (changed) self.__rebuild();
                }
                return;
            }
            if (array_length(n[$ "children"]) > 0) {
                var ancestorCopy = [];
                for (var i = 0; i < array_length(frame.ancestors); i++) {
                    array_push(ancestorCopy, frame.ancestors[i]);
                }
                array_push(ancestorCopy, n);
                array_push(stack, { nodes: n.children, idx: 0, ancestors: ancestorCopy });
            }
        }
    };

    /// Deep expand helper (iterative stack).
    static __expandDeep = function(node) {
        var stack = [node];
        while (array_length(stack) > 0) {
            var n = array_pop(stack);
            if (array_length(n[$ "children"]) > 0) {
                n[$ "collapsed"] = false;
                for (var i = 0; i < array_length(n.children); i++) {
                    array_push(stack, n.children[i]);
                }
            }
        }
    };

    /// Deep collapse helper (iterative stack).
    static __collapseDeep = function(node) {
        var stack = [node];
        while (array_length(stack) > 0) {
            var n = array_pop(stack);
            if (array_length(n[$ "children"]) > 0) {
                n[$ "collapsed"] = true;
                for (var i = 0; i < array_length(n.children); i++) {
                    array_push(stack, n.children[i]);
                }
            }
        }
    };
}
