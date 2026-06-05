// ============================================================
//  UiColorPicker Tests
// ============================================================

ui_test_suite("UiColorPicker", function() {
    
    ui_test("value stored from props", function() {
        var _cp = new UiColorPicker({}, { value: #FF0000 });
        assert_equal(_cp.value, #FF0000, "value = red");
    });
    
    ui_test("default value is blue", function() {
        var _cp = new UiColorPicker({}, {});
        assert_equal(_cp.value, #3B82F6, "default value");
    });
    
    ui_test("label stored from props", function() {
        var _cp = new UiColorPicker({}, { label: "Color" });
        assert_equal(_cp.label, "Color", "label stored");
    });
    
    ui_test("HexField sub-node exists", function() {
        var _cp = new UiColorPicker({}, {});
        assert_not_undefined(_cp.HexField, "HexField exists");
        assert_true(_cp.HexField.isUiNode, "HexField is UiNode");
    });
    
    ui_test("Panel undefined before opening", function() {
        var _cp = new UiColorPicker({}, {});
        assert_is_undefined(_cp.Panel, "Panel closed by default");
    });
    
    ui_test("__uui_color_to_hex formats correctly", function() {
        assert_equal(__uui_color_to_hex(#FF8040), "#FF8040", "hex string");
    });
    
    ui_test("__uui_hex_to_color parses hex", function() {
        assert_equal(__uui_hex_to_color("#FF8040"), #FF8040, "parse #RRGGBB");
        assert_equal(__uui_hex_to_color("FF8040"), #FF8040, "parse without hash");
        assert_equal(__uui_hex_to_color("#F80"), #FF8800, "parse shorthand");
    });
    
    ui_test("__uui_hex_to_color returns undefined for invalid", function() {
        assert_is_undefined(__uui_hex_to_color("not-a-color"), "invalid hex");
    });
    
    ui_test("setColor updates HSV and fires onChange", function() {
        var _state = { called: false, col: 0 };
        var _cp = new UiColorPicker({}, {
            value: #000000,
            onChange: method(_state, function(_c) { called = true; col = _c; })
        });
        _cp.setColor(#00FF00);
        assert_equal(_cp.value, #00FF00, "value updated");
        assert_true(_state.called, "onChange fired");
        assert_equal(_state.col, #00FF00, "onChange color");
    });
    
    ui_test("closePanel destroys Panel", function() {
        var _overlay_backup = global.UI[$ "Overlay"] ?? undefined;
        global.UI.Overlay = new UiNode({}, {});
        global.UI.add(global.UI.Overlay);
        
        var _cp = new UiColorPicker({ height: 36 }, {});
        global.UI.add(_cp);
        
        _cp.openPanel();
        assert_not_undefined(_cp.Panel, "Panel created");
        
        _cp.closePanel();
        assert_is_undefined(_cp.Panel, "Panel destroyed");
        
        global.UI.remove(_cp);
        global.UI.remove(global.UI.Overlay);
        global.UI.Overlay = _overlay_backup;
    });
    
    ui_test("rgb/hsv roundtrip", function() {
        var _hsv = __uui_rgb_to_hsv(#8040FF);
        var _rgb = __uui_hsv_to_rgb(_hsv.h, _hsv.s, _hsv.v);
        assert_equal(color_get_red(_rgb), color_get_red(#8040FF), "red channel");
        assert_equal(color_get_green(_rgb), color_get_green(#8040FF), "green channel");
        assert_equal(color_get_blue(_rgb), color_get_blue(#8040FF), "blue channel");
    });
    
});
