/// UiVirtualContainer — lazy offset cache + binary search for virtual scrolling.
/// NOT a UiNode. Pure logic helper struct.
function UiVirtualContainer(_dataLength, _estimatedItemHeight) constructor {
    self.__dataLength = _dataLength;
    self.__estimatedItemHeight = _estimatedItemHeight;
    self.__itemHeights = [];
    self.__itemOffsets = [];
    self.__lastMeasuredIndex = -1;

    /// Get cached / computed pixel offset for a given data index.
    /// O(1) for already-measured indices, O(n) amortised for new regions.
    static getItemOffset = function(index) {
        if (index < 0) return 0;
        if (index <= self.__lastMeasuredIndex) return self.__itemOffsets[index];

        var offset = 0;
        if (self.__lastMeasuredIndex >= 0) {
            offset = self.__itemOffsets[self.__lastMeasuredIndex] + self.__itemHeights[self.__lastMeasuredIndex];
        }

        for (var i = max(0, self.__lastMeasuredIndex + 1); i <= index; i++) {
            self.__itemOffsets[i] = offset;
            var h = (i < array_length(self.__itemHeights) && self.__itemHeights[i] > 0) 
                ? self.__itemHeights[i] : self.__estimatedItemHeight;
            self.__itemHeights[i] = h;
            offset += h;
        }

        self.__lastMeasuredIndex = index;
        return self.__itemOffsets[index];
    };

    /// Total content height (measured + estimated for remaining).
    static getTotalContentSize = function() {
        if (self.__lastMeasuredIndex < 0 || self.__dataLength == 0) {
            return self.__dataLength * self.__estimatedItemHeight;
        }

        var total = self.__itemOffsets[self.__lastMeasuredIndex] + self.__itemHeights[self.__lastMeasuredIndex];
        var remaining = self.__dataLength - self.__lastMeasuredIndex - 1;
        return total + max(0, remaining) * self.__estimatedItemHeight;
    };

    /// Item height at index (measured or estimate).
    static getItemHeight = function(index) {
        if (index < 0) return 0;
        return (index < array_length(self.__itemHeights)) ? self.__itemHeights[index] : self.__estimatedItemHeight;
    };

    /// Binary search: find the last item whose offset ≤ target offset.
    /// O(log N) after lazy offset calculation for visited nodes.
    static findNearestItem = function(offset) {
        if (self.__dataLength == 0) return 0;
        if (offset <= 0) return 0;

        var totalSize = self.getTotalContentSize();
        if (offset >= totalSize) return self.__dataLength - 1;

        var low = 0;
        var high = self.__dataLength - 1;

        while (low <= high) {
            var mid = (low + high) >> 1;
            var midOffset = self.getItemOffset(mid);

            if (midOffset <= offset)
                low = mid + 1;
            else
                high = mid - 1;
        }

        return max(0, low - 1);
    };

    /// Store a real measured height and invalidate the offset cache from this index forward.
    static setItemHeight = function(index, height) {
        if (index < 0) return;
        self.__itemHeights[index] = height;
        if (index <= self.__lastMeasuredIndex) {
            self.__lastMeasuredIndex = index - 1;
        }
    };

    /// Reset for a new dataset.
    static reset = function(newDataLength, newEstimatedHeight = undefined) {
        self.__dataLength = newDataLength;
        self.__itemHeights = [];
        self.__itemOffsets = [];
        self.__lastMeasuredIndex = -1;
        if (newEstimatedHeight != undefined) self.__estimatedItemHeight = newEstimatedHeight;
    };

    /// Update the fallback estimated height.
    static setEstimatedHeight = function(h) {
        self.__estimatedItemHeight = h;
    };
}
