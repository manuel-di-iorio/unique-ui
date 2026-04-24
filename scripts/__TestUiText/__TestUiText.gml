// ============================================================
//  UiText Tests
// ============================================================

ui_test_suite("UiText", function() {
    
    ui_test("text stored from constructor", function() {
        var t = new UiText("Hello", {}, {});
        assert_equal(t.text, "Hello", "text = 'Hello'");
    });
    
    ui_test("text defaults to empty string", function() {
        var t = new UiText("", {}, {});
        assert_equal(t.text, "", "text = ''");
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
    
    ui_test("text can be changed directly", function() {
        var t = new UiText("Initial", {}, {});
        t.text = "Updated";
        assert_equal(t.text, "Updated", "text updated directly");
    });
    
});
