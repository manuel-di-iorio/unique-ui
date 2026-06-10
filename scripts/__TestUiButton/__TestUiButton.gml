// ============================================================
//  UiButton Tests
// ============================================================

ui_test_suite("UiButton", function() {
    
    ui_test("Create with text - value property set", function() {
        var btn = new UiButton("Click Me", {}, {});
        assert_equal(btn.value, "Click Me", "value property");
    });
    
    ui_test("Create with text - sprite is undefined", function() {
        var btn = new UiButton("Hello", {}, {});
        assert_is_undefined(btn.sprite, "sprite = undefined for text button");
    });
    
    ui_test("Create with undefined - both value and sprite undefined", function() {
        var btn = new UiButton(undefined, {}, {});
        assert_is_undefined(btn.value,  "value = undefined");
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
    
    ui_test("setText changes value property", function() {
        var btn = new UiButton("Original", {}, {});
        btn.setText("Updated");
        assert_equal(btn.value, "Updated", "value updated");
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
    
    ui_test("disabled is false by default", function() {
        var btn = new UiButton("Test", {}, {});
        assert_false(btn.disabled, "disabled = false by default");
    });
    
    ui_test("setDisabled(true) sets disabled to true", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        assert_true(btn.disabled, "disabled = true after setDisabled(true)");
    });
    
    ui_test("setDisabled(false) sets disabled to false", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        btn.setDisabled(false);
        assert_false(btn.disabled, "disabled = false after setDisabled(false)");
    });
    
    ui_test("setDisabled(true) disables pointerEvents", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        assert_false(btn.pointerEvents, "pointerEvents = false when disabled");
    });
    
    ui_test("setDisabled(false) enables pointerEvents", function() {
        var btn = new UiButton("Test", {}, {});
        btn.setDisabled(true);
        btn.setDisabled(false);
        assert_true(btn.pointerEvents, "pointerEvents = true when not disabled");
    });
    
    ui_test("disabled button does not trigger onClick", function() {
        var btn = new UiButton("Test", {}, {});
        var state = { hit: false };
        btn.onClick(method(state, function() { hit = true; }));
        btn.setDisabled(true);
        btn.click();
        assert_false(state.hit, "onClick not fired when disabled");
    });
    
});
