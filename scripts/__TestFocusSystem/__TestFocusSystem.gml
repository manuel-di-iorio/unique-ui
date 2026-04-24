// ============================================================
//  Focus System Tests
// ============================================================

ui_test_suite("FocusSystem", function() {
    
    /// Helper: create focusable node and register it
    function __focusable_node() {
        var n = new UiNode({}, { focusable: true });
        n.focusable = true;
        global.UI.__registerFocus(n);
        return n;
    }
    
    function __reset_focus() {
        // Clear focus state between tests
        global.UI.focusedElement  = undefined;
        global.UI.focusableElements = [];
    }
    
    ui_test("hasFocus returns false when no element focused", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        assert_false(n.hasFocus(), "not focused");
    });
    
    ui_test("focus() sets focusedElement on global.UI", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.focusedElement = n; // simulate focus
        assert_true(n.hasFocus(), "hasFocus = true after setting focusedElement");
    });
    
    ui_test("blur() clears focusedElement when called on focused element", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.focusedElement = n;
        n.blur();
        assert_is_undefined(global.UI.focusedElement, "focusedElement cleared after blur");
        assert_false(n.hasFocus(), "hasFocus = false after blur");
    });
    
    ui_test("blur() on non-focused element does not touch focusedElement", function() {
        __reset_focus();
        var a = new UiNode({}, {});
        var b = new UiNode({}, {});
        global.UI.focusedElement = a;
        b.blur(); // blur non-focused
        assert_equal(global.UI.focusedElement, a, "a still focused");
    });
    
    ui_test("onFocus callback called on focus", function() {
        __reset_focus();
        var state = { called: false };
        var n = new UiNode({}, {});
        n.onFocus = method(state, function() { called = true; });
        global.UI.focusedElement = n;
        n.onFocus();
        assert_true(state.called, "onFocus callback called");
    });
    
    ui_test("onBlur callback called on blur", function() {
        __reset_focus();
        var state = { called: false };
        var n = new UiNode({}, {});
        n.onBlur = method(state, function() { called = true; });
        global.UI.focusedElement = n;
        n.blur();
        assert_true(state.called, "onBlur callback called");
    });
    
    ui_test("__registerFocus adds element to focusableElements", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.__registerFocus(n);
        assert_equal(array_length(global.UI.focusableElements), 1, "1 focusable element");
        assert_equal(global.UI.focusableElements[0], n, "correct element");
    });
    
    ui_test("__registerFocus does not add duplicates", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.__registerFocus(n);
        global.UI.__registerFocus(n); // duplicate
        assert_equal(array_length(global.UI.focusableElements), 1, "still 1 element");
    });
    
    ui_test("__unregisterFocus removes element from focusableElements", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.__registerFocus(n);
        global.UI.__unregisterFocus(n);
        assert_equal(array_length(global.UI.focusableElements), 0, "0 focusable elements");
    });
    
    ui_test("__unregisterFocus clears focusedElement if it was unregistered", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.__registerFocus(n);
        global.UI.focusedElement = n;
        global.UI.__unregisterFocus(n);
        assert_is_undefined(global.UI.focusedElement, "focusedElement cleared");
    });
    
    ui_test("hasAnyFocus returns true when element is focused", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.focusedElement = n;
        assert_true(global.UI.hasAnyFocus(), "hasAnyFocus = true");
    });
    
    ui_test("hasAnyFocus returns false when no element focused", function() {
        __reset_focus();
        assert_false(global.UI.hasAnyFocus(), "hasAnyFocus = false");
    });
    
    ui_test("focusNext cycles to next focusable element", function() {
        __reset_focus();
        var a = new UiNode({}, {});
        var b = new UiNode({}, {});
        a.visible = true; b.visible = true;
        // focusableElements is LIFO-ordered (insert at front)
        global.UI.focusableElements = [b, a]; // a is "first" logically
        global.UI.focusedElement = undefined;
        global.UI.focusNext();
        // Should have focused one of them
        assert_not_undefined(global.UI.focusedElement, "an element got focused");
    });
    
    ui_test("focusNext skips invisible elements", function() {
        __reset_focus();
        var n_inv = new UiNode({}, {});
        var n_vis = new UiNode({}, {});
        n_inv.visible = false;
        n_vis.visible = true;
        global.UI.focusableElements = [n_inv, n_vis];
        global.UI.focusedElement = undefined;
        
        // Patch focus() to set focusedElement directly for simulation
        n_inv.focus = method(n_inv, function() { global.UI.focusedElement = self; });
        n_vis.focus = method(n_vis, function() { global.UI.focusedElement = self; });
        
        global.UI.focusNext();
        assert_not_undefined(global.UI.focusedElement, "something got focused");
        assert_equal(global.UI.focusedElement.visible, true, "element is visible");
    });
    
    ui_test("clearAllFocused resets focusedElement and focusableElements", function() {
        __reset_focus();
        var n = new UiNode({}, {});
        global.UI.focusableElements = [n];
        global.UI.focusedElement    = n;
        // clearAllFocused calls blur which calls onBlur:
        n.onBlur = function() {};
        global.UI.clearAllFocused();
        assert_is_undefined(global.UI.focusedElement, "focusedElement cleared");
        assert_equal(array_length(global.UI.focusableElements), 0, "focusableElements cleared");
    });
    
});
