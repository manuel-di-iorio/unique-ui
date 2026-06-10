// ============================================================
//  UiText Tests
// ============================================================

ui_test_suite("UiText", function() {
    
    ui_test("value stored from constructor", function() {
        var t = new UiText("Hello", {}, {});
        assert_equal(t.value, "Hello", "value = 'Hello'");
    });
    
    ui_test("value defaults to empty string", function() {
        var t = new UiText("", {}, {});
        assert_equal(t.value, "", "value = ''");
    });
    
    ui_test("color defaults to c_white", function() {
        var t = new UiText("Test", {}, {});
        assert_equal(t.color, c_white, "color = c_white");
    });
    
    ui_test("color can be overridden via props", function() {
        var t = new UiText("Test", {}, { color: c_red });
        assert_equal(t.color, c_red, "color = c_red");
    });
    
    ui_test("halign defaults to fa_left", function() {
        var t = new UiText("Test", {}, {});
        assert_equal(t.halign, fa_left, "halign = fa_left");
    });
    
    ui_test("valign defaults to fa_top", function() {
        var t = new UiText("Test", {}, {});
        assert_equal(t.valign, fa_top, "valign = fa_top");
    });
    
    ui_test("icon is undefined by default", function() {
        var t = new UiText("Test", {}, {});
        assert_is_undefined(t.icon, "icon = undefined");
    });
    
    ui_test("valueGetter stored from props", function() {
        var getter = function() { return "Dynamic"; };
        var t = new UiText("Initial", {}, { valueGetter: getter });
        assert_equal(t.valueGetter, getter, "valueGetter stored");
    });
    
    ui_test("isUiNode true (inherits UiNode)", function() {
        var t = new UiText("Test", {}, {});
        assert_true(t.isUiNode, "isUiNode = true");
    });
    
    ui_test("autoResize true when no explicit width/height", function() {
        var t = new UiText("Test", {}, {});
        assert_true(t.autoResize, "autoResize = true without explicit size");
    });
    
    ui_test("autoResize false when width provided", function() {
        var t = new UiText("Test", { width: 100 }, {});
        assert_false(t.autoResize, "autoResize = false with explicit width");
    });
    
    ui_test("value can be changed via setValue", function() {
        var t = new UiText("Initial", {}, {});
        t.setValue("Updated");
        assert_equal(t.value, "Updated", "value updated via setValue");
    });
    
    ui_test("onChange fires when setValue is called", function() {
        var t = new UiText("Initial", {}, {});
        var state = { received: "" };
        t.onChange(method(state, function(val) { received = val; }));
        t.setValue("New Value");
        assert_equal(state.received, "New Value", "onChange received new value");
    });
    
});
