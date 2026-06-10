// ============================================================
//  UiButton Tests
// ============================================================

ui_test_suite("UiButton", function() {
    
    ui_test("Create with text - value property set", function() {
        var btn = new UiButton("Click Me", {}, {});
        assert_equal(btn.value, "Click Me", "value property");
        btn.destroy();
    });
    
    ui_test("Create with text - sprite is undefined", function() {
        var btn = new UiButton("Hello", {}, {});
        assert_is_undefined(btn.sprite, "sprite = undefined for text button");
        btn.destroy();
    });
    
    ui_test("Create with undefined - both value and sprite undefined", function() {
        var btn = new UiButton(undefined, {}, {});
        assert_is_undefined(btn.value,  "value = undefined");
        assert_is_undefined(btn.sprite, "sprite = undefined");
        btn.destroy();
    });
    
    ui_test("pointerEvents is true by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.pointerEvents, "pointerEvents = true");
        btn.destroy();
    });
    
    ui_test("handpoint is true by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.handpoint, "handpoint = true");
        btn.destroy();
    });
    
    ui_test("selected is false by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_false(btn.selected, "selected = false");
        btn.destroy();
    });
    
    ui_test("enableRipple is true by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.enableRipple, "enableRipple = true");
        btn.destroy();
    });
    
    ui_test("enableRipple can be set to false via props", function() {
        var btn = new UiButton("Test", {}, { enableRipple: false });
        assert_false(btn.enableRipple, "enableRipple = false");
        btn.destroy();
    });
    
    ui_test("outline prop passed correctly", function() {
        var btn = new UiButton("Test", {}, { outline: true });
        assert_true(btn.outline, "outline = true");
        btn.destroy();
    });
    
    ui_test("halign defaults to fa_center", function() {
        var btn = new UiButton("Test", {}, {});
        assert_equal(btn.halign, fa_center, "halign = fa_center");
        btn.destroy();
    });
    
    ui_test("halign can be overridden via props", function() {
        var btn = new UiButton("Test", {}, { halign: fa_left });
        assert_equal(btn.halign, fa_left, "halign = fa_left");
        btn.destroy();
    });
    
    ui_test("setText changes value property", function() {
        var btn = new UiButton("Original", {}, {});
        btn.setText("Updated");
        assert_equal(btn.value, "Updated", "value updated");
        btn.destroy();
    });
    
    ui_test("onClick registers click listener", function() {
        var btn = new UiButton("Test", {}, {});
        var state = { hit: false };
        btn.onClick(method(state, function() { hit = true; }));
        btn.click();
        assert_true(state.hit, "onClick callback fired");
        btn.destroy();
    });
    
    ui_test("ripples array starts empty", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(is_array(btn.ripples), "ripples is array");
        assert_equal(array_length(btn.ripples), 0, "ripples empty on create");
        btn.destroy();
    });
    
    ui_test("label prop stored correctly", function() {
        var btn = new UiButton("Test", {}, { label: "My Label" });
        assert_equal(btn.label, "My Label", "label prop");
        btn.destroy();
    });
    
    ui_test("selected can be set to true", function() {
        var btn = new UiButton("Test", {}, {});
        btn.selected = true;
        assert_true(btn.selected, "selected = true");
        btn.destroy();
    });
    
    ui_test("isUiNode is true (inherits UiNode)", function() {
        var btn = new UiButton("Test", {}, {});
        assert_true(btn.isUiNode, "isUiNode = true");
        btn.destroy();
    });
    
    ui_test("type is UiNode (no override)", function() {
        var btn = new UiButton("Test", {}, {});
        assert_equal(btn.type, "UiNode", "type = UiNode");
        btn.destroy();
    });
    
    ui_test("disabled is false by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_false(btn.disabled, "disabled = false by default");
        btn.destroy();
    });
    
    ui_test("setDisabled(true) sets disabled to true", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        assert_true(btn.disabled, "disabled = true after setDisabled(true)");
        btn.destroy();
    });
    
    ui_test("setDisabled(false) sets disabled to false", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        btn.setDisabled(false);
        assert_false(btn.disabled, "disabled = false after setDisabled(false)");
        btn.destroy();
    });
    
    ui_test("setDisabled(true) disables pointerEvents", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        assert_false(btn.pointerEvents, "pointerEvents = false when disabled");
        btn.destroy();
    });
    
    ui_test("setDisabled(false) enables pointerEvents", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        btn.setDisabled(false);
        assert_true(btn.pointerEvents, "pointerEvents = true when not disabled");
        btn.destroy();
    });
    
    ui_test("disabled button does not trigger onClick", function() {
        var btn = new UiButton("Test", {}, {});
        var state = { hit: false };
        btn.onClick(method(state, function() { hit = true; }));
        btn.setDisabled(true);
        btn.click();
        assert_false(state.hit, "onClick not fired when disabled");
        btn.destroy();
    });
    
});
