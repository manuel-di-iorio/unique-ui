// ============================================================
//  UiButton Tests
// ============================================================

ui_test_suite("UiButton", function() {
    
    ui_test("Create with text - text property set", function() {
        var btn = new UiButton("Click Me", {}, {});
        assert_equal(btn.text, "Click Me", "text property");
    });
    
    ui_test("Create with text - sprite is undefined", function() {
        var btn = new UiButton("Hello", {}, {});
        assert_is_undefined(btn.sprite, "sprite = undefined for text button");
    });
    
    ui_test("Create with undefined - both text and sprite undefined", function() {
        var btn = new UiButton(undefined, {}, {});
        assert_is_undefined(btn.text,   "text = undefined");
        assert_is_undefined(btn.sprite, "sprite = undefined");
    });
    
    ui_test("pointerEvents is true by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.pointerEvents, "pointerEvents = true");
    });
    
    ui_test("handpoint is true by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.handpoint, "handpoint = true");
    });
    
    ui_test("selected is false by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_false(btn.selected, "selected = false");
    });
    
    ui_test("enableRipple is true by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.enableRipple, "enableRipple = true");
    });
    
    ui_test("enableRipple can be set to false via props", function() {
        var btn = new UiButton("Test", {}, { enableRipple: false });
        assert_false(btn.enableRipple, "enableRipple = false");
    });
    
    ui_test("outline prop passed correctly", function() {
        var btn = new UiButton("Test", {}, { outline: true });
        assert_true(btn.outline, "outline = true");
    });
    
    ui_test("halign defaults to fa_center", function() {
        var btn = new UiButton("Test", {}, {});
        assert_equal(btn.halign, fa_center, "halign = fa_center");
    });
    
    ui_test("halign can be overridden via props", function() {
        var btn = new UiButton("Test", {}, { halign: fa_left });
        assert_equal(btn.halign, fa_left, "halign = fa_left");
    });
    
    ui_test("setText changes text property", function() {
        var btn = new UiButton("Original", {}, {});
        btn.setText("Updated");
        assert_equal(btn.text, "Updated", "text updated");
    });
    
    ui_test("onClick registers click listener", function() {
        var btn = new UiButton("Test", {}, {});
        var state = { hit: false };
        btn.onClick(method(state, function() { hit = true; }));
        btn.click();
        assert_true(state.hit, "onClick callback fired");
    });
    
    ui_test("ripples array starts empty", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(is_array(btn.ripples), "ripples is array");
        assert_equal(array_length(btn.ripples), 0, "ripples empty on create");
    });
    
    ui_test("label prop stored correctly", function() {
        var btn = new UiButton("Test", {}, { label: "My Label" });
        assert_equal(btn.label, "My Label", "label prop");
    });
    
    ui_test("selected can be set to true", function() {
        var btn = new UiButton("Test", {}, {});
        btn.selected = true;
        assert_true(btn.selected, "selected = true");
    });
    
    ui_test("isUiNode is true (inherits UiNode)", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.isUiNode, "isUiNode = true");
    });
    
    ui_test("type is UiNode (no override)", function() {
        var btn = new UiButton("Test", {}, {});
        assert_equal(btn.type, "UiNode", "type = UiNode");
    });
    
    ui_test("enabled is true by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.enabled, "enabled = true");
    });
    
    ui_test("setEnabled(false) sets enabled to false", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setEnabled(false);
        assert_false(btn.enabled, "enabled = false after setEnabled(false)");
    });
    
    ui_test("setEnabled(true) sets enabled to true", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setEnabled(false);
        btn.setEnabled(true);
        assert_true(btn.enabled, "enabled = true after setEnabled(true)");
    });
    
    ui_test("setEnabled(false) disables pointerEvents", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setEnabled(false);
        assert_false(btn.pointerEvents, "pointerEvents = false when disabled");
    });
    
    ui_test("setEnabled(true) enables pointerEvents", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setEnabled(false);
        btn.setEnabled(true);
        assert_true(btn.pointerEvents, "pointerEvents = true when enabled");
    });
    
    ui_test("disabled button does not trigger onClick", function() {
        var btn = new UiButton("Test", {}, {});
        var state = { hit: false };
        btn.onClick(method(state, function() { hit = true; }));
        btn.setEnabled(false);
        btn.click();
        assert_false(state.hit, "onClick not fired when disabled");
    });
    
});
