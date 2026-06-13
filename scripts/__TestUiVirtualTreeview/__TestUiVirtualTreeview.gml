ui_test_suite("UiVirtualTreeview", function() {

    // ── Construction ──

    ui_test("constructor creates a UiNode with expected pool size", function() {
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, {
            value: [],
            estimatedRowHeight: 32
        });
        assert_true(tv.isUiNode, "inherits UiNode");
        assert_greater(tv.__poolSize, 0, "pool is non-empty");
        assert_greater(array_length(tv.__pool), 0, "pool array populated");
        tv.destroy();
    });

    ui_test("constructor with no data creates empty tree", function() {
        var tv = new UiVirtualTreeview({ width: "100%", height: 200 }, {});
        assert_equal(array_length(tv.value), 0, "empty data");
        assert_equal(array_length(tv.__flatData), 0, "empty flat data");
        tv.destroy();
    });

    ui_test("constructor with data populates flat data", function() {
        var data = [
            { name: "Root", children: [], collapsed: true }
        ];
        var tv = new UiVirtualTreeview({ width: "100%", height: 200 }, { value: data });
        assert_equal(array_length(tv.__flatData), 1, "1 flat entry");
        assert_equal(tv.__flatData[0].depth, 0, "depth 0");
        tv.destroy();
    });

    // ── Flattening ──

    ui_test("flatten produces depth-first order with correct depth", function() {
        var data = [
            {
                name: "A", collapsed: false, children: [
                    { name: "A1", collapsed: false, children: [
                        { name: "A1a", children: [] }
                    ] },
                    { name: "A2", children: [] }
                ]
            },
            { name: "B", children: [] }
        ];
        var tv = new UiVirtualTreeview({ width: "100%", height: 200 }, { value: data });
        var flat = tv.__flatData;
        assert_equal(array_length(flat), 5, "5 flat entries");
        assert_equal(flat[0].node.name, "A",   "[0] = A");
        assert_equal(flat[1].node.name, "A1",  "[1] = A1");
        assert_equal(flat[2].node.name, "A1a", "[2] = A1a");
        assert_equal(flat[3].node.name, "A2",  "[3] = A2");
        assert_equal(flat[4].node.name, "B",   "[4] = B");
        assert_equal(flat[0].depth, 0, "depth 0");
        assert_equal(flat[1].depth, 1, "depth 1");
        assert_equal(flat[2].depth, 2, "depth 2");
        assert_equal(flat[3].depth, 1, "depth 1");
        assert_equal(flat[4].depth, 0, "depth 0");
        tv.destroy();
    });

    ui_test("collapsed children excluded from flat data", function() {
        var data = [
            {
                name: "A", collapsed: true, children: [
                    { name: "A1", children: [] }
                ]
            },
            { name: "B", children: [] }
        ];
        var tv = new UiVirtualTreeview({ width: "100%", height: 200 }, { value: data });
        var flat = tv.__flatData;
        assert_equal(array_length(flat), 2, "2 flat entries (A1 hidden)");
        assert_equal(flat[0].node.name, "A", "[0] = A");
        assert_equal(flat[1].node.name, "B", "[1] = B");
        tv.destroy();
    });

    ui_test("expandable is true for nodes with children", function() {
        var data = [
            { name: "Folder", children: [{ name: "Child", children: [] }] },
            { name: "Leaf", children: [] }
        ];
        var tv = new UiVirtualTreeview({ width: "100%", height: 200 }, { value: data });
        assert_true(tv.__flatData[0].expandable, "Folder expandable");
        assert_false(tv.__flatData[1].expandable, "Leaf not expandable");
        tv.destroy();
    });

    // ── getContentSize ──

    ui_test("getContentSize with items returns estimated total", function() {
        var data = [];
        for (var i = 0; i < 50; i++) {
            array_push(data, { name: "Item " + string(i), children: [] });
        }
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, {
            value: data,
            estimatedRowHeight: 32
        });
        assert_equal(tv.getContentSize(), 50 * 32, "50 * 32 estimate");
        tv.destroy();
    });

    ui_test("getContentSize with empty data", function() {
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, {
            value: [],
            estimatedRowHeight: 32
        });
        assert_equal(tv.getContentSize(), 0, "empty = 0");
        tv.destroy();
    });

    // ── scrollToIndex ──

    ui_test("scrollToIndex clamps to valid range", function() {
        var data = [{ name: "a" }, { name: "b" }, { name: "c" }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, {
            value: data,
            estimatedRowHeight: 32
        });
        tv.scrollToIndex(-5);
        assert_equal(tv.scrollTop, 0, "negative => 0");
        tv.scrollToIndex(100);
        assert_equal(tv.scrollTop, 64, "too-large => last offset (2*32)");
        tv.destroy();
    });

    ui_test("scrollToIndex on empty tree does nothing", function() {
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, {
            value: [],
            estimatedRowHeight: 32
        });
        tv.scrollToIndex(0);
        assert_equal(tv.scrollTop, 0, "no crash");
        tv.destroy();
    });

    // ── setValue ──

    ui_test("setValue replaces dataset and rebuilds flat data", function() {
        var data1 = [{ name: "a" }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, {
            value: data1,
            estimatedRowHeight: 32
        });
        var newData = [{ name: "x" }, { name: "y" }];
        tv.setValue(newData);
        assert_equal(array_length(tv.value), 2, "replaced");
        assert_equal(array_length(tv.__flatData), 2, "rebuilt flat data");
        assert_equal(tv.__flatData[1].node.name, "y", "second entry");
        tv.destroy();
    });

    // ── Toggle ──

    ui_test("__toggleEntry expands collapsed node", function() {
        var data = [{
            name: "A", collapsed: true, children: [
                { name: "A1", children: [] }
            ]
        }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, { value: data });
        assert_equal(array_length(tv.__flatData), 1, "collapsed: 1 entry");
        tv.__toggleEntry(0);
        assert_equal(array_length(tv.__flatData), 2, "expanded: 2 entries");
        assert_false(tv.__flatData[0].node.collapsed, "no longer collapsed");
        tv.destroy();
    });

    ui_test("__toggleEntry collapses expanded node", function() {
        var data = [{
            name: "A", collapsed: false, children: [
                { name: "A1", children: [] }
            ]
        }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, { value: data });
        assert_equal(array_length(tv.__flatData), 2, "expanded: 2 entries");
        tv.__toggleEntry(0);
        assert_equal(array_length(tv.__flatData), 1, "collapsed: 1 entry");
        assert_true(tv.__flatData[0].node.collapsed, "now collapsed");
        tv.destroy();
    });

    ui_test("__toggleEntry does nothing on non-expandable entry", function() {
        var data = [{ name: "Leaf", children: [] }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, { value: data });
        assert_equal(array_length(tv.__flatData), 1, "before");
        tv.__toggleEntry(0);
        assert_equal(array_length(tv.__flatData), 1, "still 1 after toggle");
        tv.destroy();
    });

    // ── expandAll / collapseAll ──

    ui_test("expandAll expands all collapsed entries", function() {
        var data = [{
            name: "A", collapsed: true, children: [
                { name: "A1", collapsed: true, children: [
                    { name: "A1a", children: [] }
                ] }
            ]
        }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, { value: data });
        assert_equal(array_length(tv.__flatData), 1, "all collapsed");
        tv.expandAll();
        assert_equal(array_length(tv.__flatData), 3, "all expanded");
        tv.destroy();
    });

    ui_test("collapseAll collapses all expandable entries", function() {
        var data = [{
            name: "A", collapsed: false, children: [
                { name: "A1", children: [] }
            ]
        }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, { value: data });
        assert_equal(array_length(tv.__flatData), 2, "before collapseAll");
        tv.collapseAll();
        assert_equal(array_length(tv.__flatData), 1, "after collapseAll");
        tv.destroy();
    });

    // ── Edge cases ──

    ui_test("tree with 1 row works", function() {
        var data = [{ name: "only" }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 320 }, {
            value: data,
            estimatedRowHeight: 32
        });
        assert_equal(tv.getContentSize(), 32, "1 * 32");
        tv.destroy();
    });

    ui_test("tree handles pool size clamp", function() {
        var data = [];
        for (var i = 0; i < 10000; i++) {
            array_push(data, { name: "item", children: [] });
        }
        var tv = new UiVirtualTreeview({ width: "100%", height: 10000 }, {
            value: data,
            estimatedRowHeight: 20,
            buffer: 50
        });
        assert_true(tv.__poolSize <= 200, "clamped to 200 max");
        tv.destroy();
    });

    // ── __flatData ──

    ui_test("__flatData is populated on construction", function() {
        var data = [{ name: "a" }, { name: "b" }];
        var tv = new UiVirtualTreeview({ width: "100%", height: 200 }, { value: data });
        var flat = tv.__flatData;
        assert_equal(array_length(flat), 2, "2 entries");
        assert_equal(flat[0].node.name, "a", "first");
        tv.destroy();
    });

    // ── renderItem + onBind ──

    ui_test("renderItem is called during construction", function() {
        var state = { callCount: 0 };
        var tv = new UiVirtualTreeview({ width: "100%", height: 200 }, {
            value: [{ name: "x" }],
            estimatedRowHeight: 32,
            renderItem: method(state, function(index) {
                self.callCount++;
                return new UiNode({ width: "100%", height: 32 });
            })
        });
        assert_greater(state.callCount, 0, "renderItem was called");
        assert_equal(state.callCount, tv.__poolSize, "called once per pool slot");
        tv.destroy();
    });
});
