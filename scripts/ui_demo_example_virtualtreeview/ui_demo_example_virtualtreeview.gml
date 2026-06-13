function ui_demo_example_virtualtreeview(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Virtual tree - 3600+ items");

    function buildTree(folderName, depth, maxDepth, breadth) {
        static TYPES = ["js", "ts", "css", "html", "json", "gml", "png", "txt"];
        var node = {
            name: folderName,
            assetType: "Folder",
            collapsed: true,
            icon: -1,
            children: []
        };
        if (depth >= maxDepth) {
            for (var i = 0; i < breadth; i++) {
                var ext = TYPES[(depth * breadth + i) % array_length(TYPES)];
                array_push(node.children, {
                    name: folderName + "_" + string(i + 1) + "." + ext,
                    assetType: "Asset",
                    collapsed: true,
                    icon: -1,
                    children: []
                });
            }
        } else {
            for (var i = 0; i < breadth; i++) {
                var subName = folderName + "/sub" + string(i + 1);
                array_push(node.children, buildTree(subName, depth + 1, maxDepth, max(2, breadth - 1)));
            }
        }
        return node;
    }

    var FOLDERS = ["src", "assets", "scripts", "docs", "config", "tests", "tools"];
    var treeData = [];
    for (var f = 0; f < array_length(FOLDERS); f++) {
        array_push(treeData, buildTree(FOLDERS[f], 1, 5, 6));
    }

    var _renderItem = function(index) {
        static COLORS = [ #4FC3F7, #81C784, #FFB74D, #E57373, #CE93D8 ];
        var row = new UiNode({ width: "100%", height: 32, flexShrink: 0, flexDirection: "row", alignItems: "center" }, { pointerEvents: true, handpoint: true });

        // Arrow
        var arrow = new UiNode({ width: 20, height: 20, flexShrink: 0, justifyContent: "center", alignItems: "center" }, { pointerEvents: true, handpoint: true });
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
        arrow.onClick(method({ row: row }, function() {
            var idx = self.row.__virtualIndex;
            if (idx >= 0 && self.row.__treeview != undefined) {
                self.row.__treeview.__toggleEntry(idx);
            }
        }));
        arrow.onDoubleClick(method({}, function() { return true; }));
        row.add(arrow);

        // Icon
        var icon = new UiNode({ width: 20, height: 20, flexShrink: 0, marginLeft: 4, marginRight: 8 });
        icon.onDraw = method(icon, function() {
            if (self.__entry == undefined) return;
            var mx = (self.x1 + self.x2) / 2;
            var my = (self.y1 + self.y2) / 2;
            if (self.__entry.node.assetType == "Folder") {
                draw_set_color(self.__entry.node.collapsed ? #F59E0B : #FCD34D);
                draw_rectangle(self.x1 + 2, self.y1 + 6, self.x2 - 2, self.y2 - 4, false);
                draw_rectangle(self.x1 + 2, self.y1 + 4, self.x1 + 10, self.y1 + 6, false);
            } else {
                draw_set_color(#6366F1);
                draw_rectangle(self.x1 + 4, self.y1 + 4, self.x2 - 4, self.y2 - 4, false);
            }
        });
        row.add(icon);

        // Label
        var label = new UiNode({ flex: 1, height: "100%", justifyContent: "center" });
        label.onDraw = method(label, function() {
            if (self.__entry == undefined) return;
            draw_set_color(global.UI_COL_TEXT_1);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(self.x1 + 4, ~~mean(self.y1, self.y2), self.__entry.node.name ?? "");
        });
        row.add(label);

        // Right slot for future custom content (e.g. eye icon)
        var rightSlot = new UiNode({ width: 24, height: 20, flexShrink: 0, marginRight: 8 });
        row.add(rightSlot);

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
        row.onDoubleClick(method({ row: row }, function() {
            var idx = self.row.__virtualIndex;
            if (idx >= 0 && self.row.__treeview != undefined) {
                var _tv = self.row.__treeview;
                if (idx < array_length(_tv.__flatData)) {
                    var entry = _tv.__flatData[idx];
                    if (entry.expandable) {
                        _tv.__toggleEntry(idx);
                    }
                }
            }
        }));

        return row;
    };

    var _bindItem = function(index, entry, node, treeview) {
        var pLeft = 4 + entry.depth * 16;
        flexpanel_node_style_set_padding(node.node, flexpanel_edge.left, pLeft);
        node.layout.paddingLeft = pLeft;
        node.__treeview = treeview;
        node.__virtualIndex = index;

        var children = node.children;
        for (var c = 0; c < array_length(children); c++) {
            children[c].__entry = entry;
        }
        node.__entry = entry;
    };

    var grid = new UiVirtualTreeview({ width: "100%", height: 320, marginBottom: 28, paddingLeft: 8, paddingRight: 8 }, {
        value: treeData,
        estimatedRowHeight: 32,
        renderItem: _renderItem,
        onBind: _bindItem
    });
    PreviewCard.add(grid);

    // Controls
    var Controls = new UiNode({ flexDirection: "row", width: "100%", alignItems: "center", gap: 8, marginBottom: 24 });
    PreviewCard.add(Controls);

    var expandAllBtn = new UiButton("Expand All", { height: 32 }, { variant: "outline" });
    expandAllBtn.onClick(method({ grid }, function() { self.grid.expandAll(); }));
    Controls.add(expandAllBtn);

    var collapseAllBtn = new UiButton("Collapse All", { height: 32 }, { variant: "outline" });
    collapseAllBtn.onClick(method({ grid }, function() { self.grid.collapseAll(); }));
    Controls.add(collapseAllBtn);

    // Info
    __ui_demo_preview_section(PreviewCard, "Performance");
    PreviewCard.add(new UiText(
        "Virtual pool: " + string(grid.__poolSize) + " rows in the flexpanel tree, regardless of tree size. " +
        "Expand/collapse rebuilds the flat array and updates the virtual container.",
        { width: "100%", marginTop: 8 },
        { color: global.UI_COL_TEXT_2, font: global.UI_FONTS.small, wrap: true }
    ));

    return [
        "// UiVirtualTreeview - 3600+ items, 7 root folders, 5 levels deep",
        "var tree = new UiVirtualTreeview({ width: \"100%\", height: 320 }, {",
        "    value: treeData,",
        "    estimatedRowHeight: 32,",
        "    renderItem: function(index) {",
        "        return new UiNode({ width: \"100%\", height: 32, flexDirection: \"row\" });",
        "    },",
        "    onBind: function(index, entry, node) {",
        "        node.__entry = entry;",
        "    }",
        "});",
    ];
}
