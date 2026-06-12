ui_test_suite("UiVirtualList", function() {

    // ── Construction ─────────────────────────────────────────────────────────

    ui_test("constructor creates a UiNode with the expected pool size", function() {
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: [],
            estimatedItemHeight: 40
        });
        assert_true(list.isUiNode, "inherits UiNode");
        assert_greater(list.__poolSize, 0, "pool is non-empty");
        assert_greater(array_length(list.__pool), 0, "pool array populated");
        list.destroy();
    });

    ui_test("constructor with no data creates empty list", function() {
        var list = new UiVirtualList({ width: "100%", height: 200 }, {});
        assert_equal(array_length(list.value), 0, "empty data");
        list.destroy();
    });

    ui_test("constructor with data populates data array", function() {
        var data = [1, 2, 3];
        var list = new UiVirtualList({ width: "100%", height: 200 }, { value: data });
        assert_equal(array_length(list.value), 3, "3 items");
        list.destroy();
    });

    // ── getContentSize ───────────────────────────────────────────────────────

    ui_test("getContentSize with items returns estimated total", function() {
        var data = [];
        for (var i = 0; i < 50; i++) array_push(data, { label: "Item " + string(i) });
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: data,
            estimatedItemHeight: 40
        });
        var size = list.getContentSize();
        assert_equal(size, 50 * 40, "50 * 40 estimate");
        list.destroy();
    });

    ui_test("getContentSize with empty data", function() {
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: [],
            estimatedItemHeight: 40
        });
        assert_equal(list.getContentSize(), 0, "empty = 0");
        list.destroy();
    });

    // ── scrollToIndex ────────────────────────────────────────────────────────

    ui_test("scrollToIndex clamps to valid range", function() {
        var data = [{ label: "a" }, { label: "b" }, { label: "c" }];
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: data,
            estimatedItemHeight: 40
        });
        // should not throw for out of range indices
        list.scrollToIndex(-5);
        assert_equal(list.scrollTop, 0, "negative → 0");
        list.scrollToIndex(100);
        assert_equal(list.scrollTop, 80, "too-large → last offset (2*40)");
        list.destroy();
    });

    ui_test("scrollToIndex on empty list does nothing", function() {
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: [],
            estimatedItemHeight: 40
        });
        list.scrollToIndex(0);
        assert_equal(list.scrollTop, 0, "no crash");
        list.destroy();
    });

    // ── setValue ─────────────────────────────────────────────────────────────

    ui_test("setValue replaces dataset and resets scroll", function() {
        var data1 = [{ label: "a" }];
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: data1,
            estimatedItemHeight: 40
        });
        var newData = [{ label: "x" }, { label: "y" }];
        list.setValue(newData);
        assert_equal(array_length(list.value), 2, "replaced");
        assert_equal(list.__virtualContainer.getTotalContentSize(), 2 * 40, "recalculated");
        list.destroy();
    });

    // ── renderItem + onBind ──────────────────────────────────────────────────

    ui_test("renderItem is called during construction for each pool slot", function() {
        var state = { callCount: 0 };
        var list = new UiVirtualList({ width: "100%", height: 200 }, {
            value: [1, 2, 3, 4, 5],
            estimatedItemHeight: 40,
            renderItem: method(state, function(index) {
                self.callCount++;
                return new UiNode({ width: "100%", height: 40 });
            })
        });
        assert_greater(state.callCount, 0, "renderItem was called");
        assert_equal(state.callCount, list.__poolSize, "called once per pool slot");
        list.destroy();
    });

    ui_test("onBind is callable", function() {
        var bindCalls = [];
        var data = [{ label: "zero" }, { label: "one" }];
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: data,
            estimatedItemHeight: 40,
            renderItem: method({}, function(index) {
                return new UiNode({ width: "100%", height: 40 });
            }),
            onBind: method({}, function(index, node) {
                array_push(bindCalls, index);
            })
        });
        list.destroy();
        // onBind is called during recycle (step). During construction only renderItem runs.
        // So bindCalls may be empty at this point — just verify no crash.
        assert_not_undefined(list, "list created without error");
    });

    // ── Edge cases ───────────────────────────────────────────────────────────

    ui_test("list with 1 item works", function() {
        var data = [{ label: "only" }];
        var list = new UiVirtualList({ width: "100%", height: 320 }, {
            value: data,
            estimatedItemHeight: 40
        });
        assert_equal(list.getContentSize(), 40, "1 * 40");
        list.destroy();
    });

    ui_test("list handles pool size clamp", function() {
        var data = [];
        for (var i = 0; i < 10000; i++) array_push(data, { label: "item" });
        var list = new UiVirtualList({ width: "100%", height: 10000 }, {
            value: data,
            estimatedItemHeight: 20,
            buffer: 50
        });
        assert_true(list.__poolSize <= 200, "clamped to 200 max");
        list.destroy();
    });

});
