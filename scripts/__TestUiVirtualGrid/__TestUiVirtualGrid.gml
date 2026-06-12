ui_test_suite("UiVirtualGrid", function() {

    ui_test("constructor creates a UiNode with expected pool size", function() {
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: [],
            estimatedRowHeight: 40,
            numColumns: 4
        });
        assert_true(grid.isUiNode, "inherits UiNode");
        assert_greater(grid.__poolSize, 0, "pool is non-empty");
        assert_greater(array_length(grid.__pool), 0, "pool array populated");
        grid.destroy();
    });

    ui_test("constructor with no data creates empty grid", function() {
        var grid = new UiVirtualGrid({ width: "100%", height: 200 }, {});
        assert_equal(array_length(grid.value), 0, "empty data");
        grid.destroy();
    });

    ui_test("constructor with data populates data array", function() {
        var data = [[1, 2], [3, 4]];
        var grid = new UiVirtualGrid({ width: "100%", height: 200 }, { value: data });
        assert_equal(array_length(grid.value), 2, "2 rows");
        assert_equal(grid.__numColumns, 2, "2 columns from data");
        grid.destroy();
    });

    ui_test("numColumns prop overrides auto-detect", function() {
        var data = [[1, 2], [3, 4]];
        var grid = new UiVirtualGrid({ width: "100%", height: 200 }, {
            value: data,
            numColumns: 5
        });
        assert_equal(grid.__numColumns, 5, "explicit numColumns");
        grid.destroy();
    });

    ui_test("getContentSize with items returns estimated total", function() {
        var data = [];
        for (var r = 0; r < 50; r++) {
            var row = [];
            for (var c = 0; c < 3; c++) array_push(row, c);
            array_push(data, row);
        }
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: data,
            estimatedRowHeight: 40,
            numColumns: 3
        });
        assert_equal(grid.getContentSize(), 50 * 40, "50 * 40 estimate");
        grid.destroy();
    });

    ui_test("getContentSize with empty data", function() {
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: [],
            estimatedRowHeight: 40
        });
        assert_equal(grid.getContentSize(), 0, "empty = 0");
        grid.destroy();
    });

    ui_test("scrollToIndex clamps to valid range", function() {
        var data = [[{ label: "a" }], [{ label: "b" }], [{ label: "c" }]];
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: data,
            estimatedRowHeight: 40,
            numColumns: 1
        });
        grid.scrollToIndex(-5);
        assert_equal(grid.scrollTop, 0, "negative => 0");
        grid.scrollToIndex(100);
        assert_equal(grid.scrollTop, 80, "too-large => last offset (2*40)");
        grid.destroy();
    });

    ui_test("scrollToIndex on empty grid does nothing", function() {
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: [],
            estimatedRowHeight: 40
        });
        grid.scrollToIndex(0);
        assert_equal(grid.scrollTop, 0, "no crash");
        grid.destroy();
    });

    ui_test("setValue replaces dataset and resets scroll", function() {
        var data1 = [[{ label: "a" }]];
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: data1,
            estimatedRowHeight: 40,
            numColumns: 1
        });
        var newData = [[{ label: "x" }], [{ label: "y" }]];
        grid.setValue(newData);
        assert_equal(array_length(grid.value), 2, "replaced");
        assert_equal(grid.__virtualContainer.getTotalContentSize(), 2 * 40, "recalculated");
        grid.destroy();
    });

    ui_test("renderCell is called during construction for each pool slot", function() {
        var state = { callCount: 0 };
        var grid = new UiVirtualGrid({ width: "100%", height: 200 }, {
            value: [[1, 2, 3], [4, 5, 6]],
            estimatedRowHeight: 40,
            numColumns: 3,
            renderCell: method(state, function(rowIndex, colIndex) {
                self.callCount++;
                return new UiNode({ width: 120, height: "100%" });
            })
        });
        assert_greater(state.callCount, 0, "renderCell was called");
        assert_equal(state.callCount, grid.__poolSize * 3, "called once per pool slot per column");
        grid.destroy();
    });

    ui_test("grid with 1 row works", function() {
        var data = [[{ label: "only" }]];
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: data,
            estimatedRowHeight: 40,
            numColumns: 1
        });
        assert_equal(grid.getContentSize(), 40, "1 * 40");
        grid.destroy();
    });

    ui_test("grid handles pool size clamp", function() {
        var data = [];
        for (var r = 0; r < 10000; r++) {
            var row = [];
            for (var c = 0; c < 5; c++) array_push(row, { label: "item" });
            array_push(data, row);
        }
        var grid = new UiVirtualGrid({ width: "100%", height: 10000 }, {
            value: data,
            estimatedRowHeight: 20,
            buffer: 50,
            numColumns: 5
        });
        assert_true(grid.__poolSize <= 200, "clamped to 200 max");
        grid.destroy();
    });

    ui_test("pool rows contain correct number of cells", function() {
        var data = [[1, 2, 3, 4]];
        var grid = new UiVirtualGrid({ width: "100%", height: 320 }, {
            value: data,
            estimatedRowHeight: 40,
            numColumns: 4
        });
        assert_equal(array_length(grid.__pool[0].children), 4, "4 cells per row");
        grid.destroy();
    });

});
