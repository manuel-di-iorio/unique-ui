/// UiVirtualList — virtual scrolling list with pooling, lazy offsets, and binary search.
///
/// Props:
///   value               — array of raw data items
///   estimatedItemHeight — fallback height for unmeasured items (default 40)
///   buffer              — extra items rendered above / below the visible window (default 5)
///   renderItem          — function(index) returns a new UiNode (called once per pool slot)
///   onBind              — function(index, node) updates an existing node to show value[index]
///   onChange            — function(newValue, node) fired when the dataset is replaced via setValue()
///   scrollbarColor      — passed through to enableScrollbar()
///
/// Style: standard UiNode flexbox. `flexDirection: "column"` is assumed for V1.
///
function UiVirtualList(style = {}, props = {}) : UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "UiVirtualList");

    // ── Props ────────────────────────────────────────────────────────────────
    self.value               = props[$ "value"] ?? [];
    self.__estimatedItemHeight = props[$ "estimatedItemHeight"] ?? 40;
    self.__buffer            = props[$ "buffer"] ?? 5;
    self.__renderItem        = props[$ "renderItem"];
    self.onBind              = props[$ "onBind"];
    if (props[$ "onChange"] != undefined) self.onChange(props[$ "onChange"]);

    // ── Internal state ───────────────────────────────────────────────────────
    self.__poolSize       = 0;
    self.__pool           = [];
    self.__spacerTop      = undefined;
    self.__spacerBottom   = undefined;
    self.__visibleStart   = -1;
    self.__visibleEnd     = -1;
    self.__prevScrollTop  = 0;
    self.__recyclePending = true;

    // Virtual container: lazy offset cache + binary search
    self.__virtualContainer = new UiVirtualContainer(
        array_length(self.value),
        self.__estimatedItemHeight
    );

    // ── Calculate pool size ──────────────────────────────────────────────────
    var _rawH = style[$ "height"];
    var _containerH = 400;
    if (is_real(_rawH)) {
        _containerH = _rawH;
    } else if (is_string(_rawH) && string_pos("%", _rawH) == 0) {
        _containerH = real(_rawH);
    }
    var _minItemH = max(20, self.__estimatedItemHeight * 0.5);
    var _maxVisible = ceil(_containerH / _minItemH);
    self.__poolSize = clamp(_maxVisible + self.__buffer * 2, 4, 200);

    // ── Build children: spacerTop + pool nodes + spacerBottom ────────────────

    // Spacer top — pushes the visible window down to the correct scroll offset
    self.__spacerTop = new UiNode({ width: "100%", height: 0, flexShrink: 0 }, { pointerEvents: false });
    self.add(self.__spacerTop);

    // Pool nodes — always present, never added / removed after construction
    for (var i = 0; i < self.__poolSize; i++) {
        var node = (self.__renderItem != undefined)
            ? self.__renderItem(i)
            : new UiNode({ width: "100%", height: self.__estimatedItemHeight, flexShrink: 0 });
        node.__virtualIndex = -1;
        node.hide();
        self.__pool[i] = node;
        self.add(node);
    }

    // Spacer bottom — fills the remaining content height
    self.__spacerBottom = new UiNode({ width: "100%", height: 0, flexShrink: 0 }, { pointerEvents: false });
    self.add(self.__spacerBottom);

    // ── Scrollbar ────────────────────────────────────────────────────────────
    self.enableScrollbar(props[$ "scrollbarColor"]);

    // ── Step handler ─────────────────────────────────────────────────────────
    self.onStep(function(layoutUpdated) {
        // 1. Measure actual heights after layout settles
        if (layoutUpdated) {
            self.__measureHeights();
        }

        // 2. Recycle when scroll position changes or after measurement
        if (self.__recyclePending || layoutUpdated || self.__prevScrollTop != self.scrollTop) {
            self.__prevScrollTop = self.scrollTop;
            self.__recycle();
            self.__recyclePending = false;
        }
    });

    // Initial recycle will happen on the first step after mount.
    self.__recyclePending = true;

    // ═════════════════════════════════════════════════════════════════════════
    //  Internal methods
    // ═════════════════════════════════════════════════════════════════════════

    /// Measure layout heights of currently visible pool nodes and update the
    /// offset cache.
    static __measureHeights = function() {
        for (var i = 0; i < self.__poolSize; i++) {
            var node = self.__pool[i];
            if (node.__virtualIndex >= 0 && node.display) {
                self.__virtualContainer.setItemHeight(node.__virtualIndex, node.layout.height);
            }
        }
    };

    /// Recycle: update which data indices the pool nodes display and reposition
    /// the spacers so flexpanel produces the correct scroll state.
    static __recycle = function() {
        var dataLen = array_length(self.value);
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

        var scrollTop = self.scrollTop;

        // Find the visible window via binary search
        var firstVisible = self.__virtualContainer.findNearestItem(scrollTop);
        var lastVisible  = self.__virtualContainer.findNearestItem(scrollTop + containerHeight);

        // Apply buffer
        var startIndex = max(0, firstVisible - self.__buffer);
        var endIndex   = min(dataLen - 1, lastVisible + self.__buffer);

        // Clamp to pool capacity
        var needed = endIndex - startIndex + 1;
        if (needed > self.__poolSize) {
            endIndex = startIndex + self.__poolSize - 1;
        }

        // ── (A) Bind pool slots to data indices ──────────────────────────────
        var poolIdx = 0;
        for (var i = startIndex; i <= endIndex; i++) {
            var node = self.__pool[poolIdx];

            // Sync height from cache first, then allow onBind to override.
            // This avoids the initial-cycle bug where getItemHeight returns the
            // estimate (e.g. 40) and overwrites the actual height set by onBind.
            node.setHeight(self.__virtualContainer.getItemHeight(i));

            if (node.__virtualIndex != i) {
                node.__virtualIndex = i;
                if (self.onBind != undefined) self.onBind(i, node);
            }

            node.show();
            poolIdx++;
        }

        // Hide surplus pool slots
        for (; poolIdx < self.__poolSize; poolIdx++) {
            self.__pool[poolIdx].hide();
            self.__pool[poolIdx].__virtualIndex = -1;
        }

        // ── (B) Reposition spacers ───────────────────────────────────────────
        var topOffset    = startIndex > 0 ? self.__virtualContainer.getItemOffset(startIndex) : 0;
        var endOffset    = self.__virtualContainer.getItemOffset(endIndex) + self.__virtualContainer.getItemHeight(endIndex);
        var totalSize    = self.__virtualContainer.getTotalContentSize();

        self.__spacerTop.setHeight(topOffset);
        self.__spacerBottom.setHeight(max(0, totalSize - endOffset));

        self.__visibleStart = startIndex;
        self.__visibleEnd   = endIndex;
    };

    // ═════════════════════════════════════════════════════════════════════════
    //  Public API
    // ═════════════════════════════════════════════════════════════════════════

    /// Total virtual content size   (used by UiScrollbar via getContentSize).
    static getContentSize = function() {
        return self.__virtualContainer.getTotalContentSize();
    };

    /// Scroll so that `value[index]` is at the top of the viewport.
    static scrollToIndex = function(index) {
        var dataLen = array_length(self.value);
        if (dataLen == 0) return;
        index = clamp(index, 0, dataLen - 1);
        self.scrollTop = self.__virtualContainer.getItemOffset(index);
        self.__prevScrollTop = self.scrollTop;
        global.UI.requestUpdate();
        global.UI.requestRedraw();
    };

    /// Replace the dataset and reset scroll + cache.
    static setValue = function(newValue) {
        if (self.value == newValue) return self;
        self.value = newValue;
        self.__virtualContainer.reset(array_length(newValue));
        self.scrollTop = 0;
        self.__prevScrollTop = 0;
        self.__recyclePending = true;
        self.requestRedraw();
        global.UI.requestUpdate();
        var _listeners = self.__valueChangeListeners;
        for (var i = 0; i < array_length(_listeners); i++) {
            _listeners[i](newValue, self);
        }
        return self;
    };

    /// @deprecated Use setValue() instead.
    static setData = function(newData) {
        return self.setValue(newData);
    };
}
