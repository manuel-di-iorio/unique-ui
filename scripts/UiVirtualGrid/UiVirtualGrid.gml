function UiVirtualGrid(style = {}, props = {}) : UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "UiVirtualGrid");

    self.value                   = props[$ "value"] ?? [];
    self.__estimatedRowHeight    = props[$ "estimatedRowHeight"] ?? 40;
    self.__estimatedColumnWidth  = props[$ "estimatedColumnWidth"] ?? 120;
    self.__buffer                = props[$ "buffer"] ?? 3;
    self.__renderCell            = props[$ "renderCell"];
    self.onBind                  = props[$ "onBind"];
    if (props[$ "onChange"] != undefined) self.onChange(props[$ "onChange"]);

    var _dataLen = array_length(self.value);
    self.__numColumns = props[$ "numColumns"] ?? (_dataLen > 0 ? array_length(self.value[0]) : 1);

    self.__poolSize          = 0;
    self.__pool              = [];
    self.__spacerTop         = undefined;
    self.__spacerBottom      = undefined;
    self.__visibleStart      = -1;
    self.__visibleEnd        = -1;
    self.__prevScrollTop     = 0;
    self.__recyclePending    = true;
    self.__recycleCounter    = 0;
    self.__measureScheduled  = false;
    self.__bindingsChanged   = false;

    self.__virtualContainer = new UiVirtualContainer(
        _dataLen,
        self.__estimatedRowHeight
    );

    var _rawH = style[$ "height"];
    var _containerH = 400;
    if (is_real(_rawH)) {
        _containerH = _rawH;
    } else if (is_string(_rawH) && string_pos("%", _rawH) == 0) {
        _containerH = real(_rawH);
    }
    var _minRowH = max(20, self.__estimatedRowHeight * 0.5);
    var _maxVisible = ceil(_containerH / _minRowH);
    self.__poolSize = clamp(_maxVisible + self.__buffer * 2, 4, 200);

    var _gridWidth = self.__numColumns * self.__estimatedColumnWidth;

    self.__spacerTop = new UiNode({ width: _gridWidth, height: 0, flexShrink: 0 }, { pointerEvents: false });
    self.add(self.__spacerTop);

    for (var r = 0; r < self.__poolSize; r++) {
        var row = new UiNode({ width: _gridWidth, height: self.__estimatedRowHeight, flexShrink: 0, flexDirection: "row" });
        row.__virtualRowIndex = -1;
        row.__bindCycle = -1;

        for (var c = 0; c < self.__numColumns; c++) {
            var cell;
            if (self.__renderCell != undefined) {
                cell = self.__renderCell(r, c);
            } else {
                cell = new UiNode({ width: self.__estimatedColumnWidth, height: "100%", flexShrink: 0 });
            }
            cell.__virtualRowIndex = -1;
            cell.__virtualColIndex = c;
            cell.__bindCycle = -1;
            row.add(cell);
        }

        row.hide();
        self.__pool[r] = row;
        self.add(row);
    }

    self.__spacerBottom = new UiNode({ width: _gridWidth, height: 0, flexShrink: 0 }, { pointerEvents: false });
    self.add(self.__spacerBottom);

    self.enableScrollbar(props[$ "scrollbarColor"]);
    if (props[$ "scrollbarColorH"] != undefined) {
        self.enableHorizontalScrollbar(props[$ "scrollbarColorH"]);
    }

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

    self.__recyclePending = true;

    static __measureHeights = function() {
        for (var i = 0; i < self.__poolSize; i++) {
            var row = self.__pool[i];
            if (row.__virtualRowIndex >= 0 && row.display &&
                row.__bindCycle == self.__recycleCounter && !row.__measuredThisCycle) {
                self.__virtualContainer.setItemHeight(row.__virtualRowIndex, row.layout.height);
                row.__measuredThisCycle = true;
            }
        }
    };

    static __recycle = function() {
        var dataLen = array_length(self.value);
        var containerHeight = self.layout.height;

        if (dataLen == 0 || containerHeight <= 0) {
            for (var i = 0; i < self.__poolSize; i++) {
                self.__pool[i].hide();
                self.__pool[i].__virtualRowIndex = -1;
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

        var poolIdx = 0;
        for (var i = startIndex; i <= endIndex; i++) {
            var row = self.__pool[poolIdx];

            var rowCells = row.children;
            for (var c = 0; c < self.__numColumns && c < array_length(rowCells); c++) {
                var cell = rowCells[c];
                if (cell.__virtualRowIndex != i) {
                    cell.__virtualRowIndex = i;
                    cell.__bindCycle = self.__recycleCounter;
                    if (self.onBind != undefined) {
                        self.onBind(i, c, cell);
                        self.__bindingsChanged = true;
                    }
                }
            }

            if (row.__virtualRowIndex != i) {
                row.__virtualRowIndex = i;
                row.__bindCycle = self.__recycleCounter;
                row.__measuredThisCycle = false;
            }

            row.show();
            poolIdx++;
        }

        for (; poolIdx < self.__poolSize; poolIdx++) {
            self.__pool[poolIdx].hide();
            self.__pool[poolIdx].__virtualRowIndex = -1;
        }

        var topOffset    = startIndex > 0 ? self.__virtualContainer.getItemOffset(startIndex) : 0;
        var endOffset    = self.__virtualContainer.getItemOffset(endIndex) + self.__virtualContainer.getItemHeight(endIndex);
        var totalSize    = self.__virtualContainer.getTotalContentSize();

        self.__spacerTop.setHeight(topOffset);
        self.__spacerBottom.setHeight(max(0, totalSize - endOffset));

        self.__visibleStart = startIndex;
        self.__visibleEnd   = endIndex;
    };

    static getContentSize = function() {
        return self.__virtualContainer.getTotalContentSize();
    };

    static scrollToIndex = function(index) {
        var dataLen = array_length(self.value);
        if (dataLen == 0) return;
        index = clamp(index, 0, dataLen - 1);
        self.scrollTop = self.__virtualContainer.getItemOffset(index);
        self.__prevScrollTop = self.scrollTop;
        global.UI.requestUpdate();
        global.UI.requestRedraw();
    };

    self.setValue = function(newValue) {
        if (self.value == newValue) return self;
        self.value = newValue;
        var _dataLen = array_length(newValue);
        self.__virtualContainer = new UiVirtualContainer(_dataLen, self.__estimatedRowHeight);
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
}
