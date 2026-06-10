// ============================================================
//  UiAccordion Tests
// ============================================================

ui_test_suite("UiAccordion", function() {
    
    ui_test("value stored from constructor", function() {
        var acc = new UiAccordion("My Section", {}, {});
        assert_equal(acc.value, "My Section", "value = 'My Section'");
    });
    
    ui_test("collapsed defaults to false", function() {
        var acc = new UiAccordion("Section", {}, {});
        assert_false(acc.collapsed, "collapsed = false by default");
    });
    
    ui_test("collapsed can be set to true via props", function() {
        var acc = new UiAccordion("Section", {}, { collapsed: true });
        assert_true(acc.collapsed, "collapsed = true from props");
    });
    
    ui_test("Header sub-node exists", function() {
        var acc = new UiAccordion("Section", {}, {});
        assert_not_undefined(acc.Header, "Header exists");
        assert_true(acc.Header.isUiNode, "Header is UiNode");
    });
    
    ui_test("Content sub-node exists", function() {
        var acc = new UiAccordion("Section", {}, {});
        assert_not_undefined(acc.Content, "Content exists");
        assert_true(acc.Content.isUiNode, "Content is UiNode");
    });
    
    ui_test("Arrow sub-node exists", function() {
        var acc = new UiAccordion("Section", {}, {});
        assert_not_undefined(acc.Arrow, "Arrow exists");
    });
    
    ui_test("Label sub-node exists and has correct value", function() {
        var acc = new UiAccordion("My Title", {}, {});
        assert_not_undefined(acc.Label, "Label exists");
        assert_equal(acc.Label.value, "My Title", "Label value = 'My Title'");
    });
    
    ui_test("Content is visible when not collapsed", function() {
        var acc = new UiAccordion("Section", {}, { collapsed: false });
        assert_true(acc.Content.display, "Content display = true");
    });
    
    ui_test("Content is hidden when collapsed", function() {
        var acc = new UiAccordion("Section", {}, { collapsed: true });
        assert_false(acc.Content.display, "Content display = false when collapsed");
    });
    
    ui_test("collapse() hides Content and sets collapsed = true", function() {
        var acc = new UiAccordion("Section", {}, {});
        acc.collapse();
        assert_true(acc.collapsed, "collapsed = true after collapse()");
        assert_false(acc.Content.display, "Content hidden after collapse()");
    });
    
    ui_test("expand() shows Content and sets collapsed = false", function() {
        var acc = new UiAccordion("Section", {}, { collapsed: true });
        acc.expand();
        assert_false(acc.collapsed, "collapsed = false after expand()");
        assert_true(acc.Content.display, "Content visible after expand()");
    });
    
    ui_test("collapse() then expand() restores state", function() {
        var acc = new UiAccordion("Section", {}, {});
        acc.collapse();
        acc.expand();
        assert_false(acc.collapsed, "collapsed = false after expand");
        assert_true(acc.Content.display, "Content visible after round-trip");
    });
    
    ui_test("add() override puts children into Content", function() {
        var acc   = new UiAccordion("Section", {}, {});
        var child = new UiNode({}, {});
        acc.add(child);
        assert_equal(acc.Content.childrenLength, 1, "Content has 1 child");
        assert_equal(acc.Content.children[0], child, "child in Content");
    });
    
    ui_test("Header onClick toggles collapsed state", function() {
        var acc = new UiAccordion("Section", {}, {});
        assert_false(acc.collapsed, "initially expanded");
        acc.Header.dispatchEvent(UI_EVENT.click, acc.Header);
        assert_true(acc.collapsed, "collapsed after header click");
        acc.Header.dispatchEvent(UI_EVENT.click, acc.Header);
        assert_false(acc.collapsed, "expanded again after second click");
    });
    
    ui_test("isUiNode true (inherits UiNode)", function() {
        var acc = new UiAccordion("Section", {}, {});
        assert_true(acc.isUiNode, "isUiNode = true");
    });
    
});
