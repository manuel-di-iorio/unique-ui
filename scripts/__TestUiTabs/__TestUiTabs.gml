// ============================================================
//  UiTabs Tests
// ============================================================

ui_test_suite("UiTabs", function() {
    
    ui_test("Create - selectedIndex defaults to 0", function() {
        var tabs = new UiTabs([{ label: "A" }, { label: "B" }], {}, {});
        assert_equal(tabs.selectedIndex, 0, "selectedIndex = 0");
    });
    
    ui_test("selectedIndex prop respected", function() {
        var tabs = new UiTabs([{ label: "A" }, { label: "B" }], {}, { selectedIndex: 1 });
        assert_equal(tabs.selectedIndex, 1, "selectedIndex = 1");
    });
    
    ui_test("items array stored correctly", function() {
        var items = [{ label: "X" }, { label: "Y" }];
        var tabs = new UiTabs(items, {}, {});
        assert_equal(array_length(tabs.items), 2, "items length = 2");
    });
    
    ui_test("variant defaults to 'underline'", function() {
        var tabs = new UiTabs([{ label: "A" }], {}, {});
        assert_equal(tabs.variant, "underline", "variant = underline");
    });
    
    ui_test("variant 'pills' stored correctly", function() {
        var tabs = new UiTabs([{ label: "A" }], {}, { variant: "pills" });
        assert_equal(tabs.variant, "pills", "variant = pills");
    });
    
    ui_test("selectTab changes selectedIndex", function() {
        var tabs = new UiTabs([{ label: "A" }, { label: "B" }, { label: "C" }], {}, {});
        tabs.selectTab(2);
        assert_equal(tabs.selectedIndex, 2, "selectedIndex = 2 after selectTab");
    });
    
    ui_test("selectTab clamps to valid range", function() {
        var tabs = new UiTabs([{ label: "A" }, { label: "B" }], {}, {});
        tabs.selectTab(99);
        assert_equal(tabs.selectedIndex, 1, "selectedIndex clamped to 1");
    });
    
    ui_test("onChange callback fires on selectTab", function() {
        var state = { lastIndex: -1 };
        var tabs = new UiTabs(
            [{ label: "A" }, { label: "B" }],
            {},
            { onChange: method(state, function(idx, lbl) { lastIndex = idx; }) }
        );
        tabs.selectTab(1);
        assert_equal(state.lastIndex, 1, "onChange fired with index 1");
    });
    
    ui_test("onChange defaults to a function", function() {
        var tabs = new UiTabs([{ label: "A" }], {}, {});
        assert_true(is_method(tabs.onChange), "onChange is a function");
    });
    
    ui_test("Strip child node exists", function() {
        var tabs = new UiTabs([{ label: "A" }, { label: "B" }], {}, {});
        assert_true(tabs.Strip != undefined, "Strip node created");
        assert_true(tabs.Strip.isUiNode, "Strip is a UiNode");
    });
    
    ui_test("ContentArea child node exists", function() {
        var tabs = new UiTabs([{ label: "A" }], {}, {});
        assert_true(tabs.ContentArea != undefined, "ContentArea node created");
        assert_true(tabs.ContentArea.isUiNode, "ContentArea is a UiNode");
    });
    
    ui_test("isUiNode is true (inherits UiNode)", function() {
        var tabs = new UiTabs([{ label: "A" }], {}, {});
        assert_true(tabs.isUiNode, "isUiNode = true");
    });
    
});
