// ============================================================
//  UiCheckbox Tests
// ============================================================

ui_test_suite("UiCheckbox", function() {
    
    ui_test("value defaults to false", function() {
        var cb = new UiCheckbox({}, {});
        assert_false(cb.value, "value = false by default");
    });
    
    ui_test("value can be set to true via props", function() {
        var cb = new UiCheckbox({}, { value: true });
        assert_true(cb.value, "value = true from props");
    });
    
    ui_test("Input sub-node exists", function() {
        var cb = new UiCheckbox({}, {});
        assert_not_undefined(cb.Input, "Input exists");
        assert_true(cb.Input.isUiNode, "Input is UiNode");
    });
    
    ui_test("Input.pointerEvents is true", function() {
        var cb = new UiCheckbox({}, {});
        assert_true(cb.Input.pointerEvents, "Input.pointerEvents = true");
    });
    
    ui_test("Input.handpoint is true", function() {
        var cb = new UiCheckbox({}, {});
        assert_true(cb.Input.handpoint, "Input.handpoint = true");
    });
    
    ui_test("onClick toggles value from false to true", function() {
        var cb = new UiCheckbox({}, {});
        cb.dispatchEvent(UI_EVENT.click, cb);
        assert_true(cb.value, "value toggled to true");
    });
    
    ui_test("onClick toggles value from true to false", function() {
        var cb = new UiCheckbox({}, { value: true });
        cb.dispatchEvent(UI_EVENT.click, cb);
        assert_false(cb.value, "value toggled back to false");
    });
    
    ui_test("onChange callback called with new value on click", function() {
        var state = { received: undefined };
        var cb = new UiCheckbox({}, {
            onChange: method(state, function(value, input) { received = value; })
        });
        cb.dispatchEvent(UI_EVENT.click, cb);
        assert_true(state.received, "onChange received true");
    });
    
    ui_test("onChange not called if not provided (no crash)", function() {
        var cb = new UiCheckbox({}, {});
        // No onChange prop — should not crash
        cb.dispatchEvent(UI_EVENT.click, cb);
        assert_true(cb.value, "toggled without crash");
    });
    
    ui_test("label stored from props", function() {
        var cb = new UiCheckbox({}, { label: "Enable Feature" });
        assert_equal(cb.label, "Enable Feature", "label stored");
    });
    
    ui_test("label is undefined when not provided", function() {
        var cb = new UiCheckbox({}, {});
        assert_is_undefined(cb.label, "label = undefined by default");
    });
    
    ui_test("isUiNode is true (inherits UiNode)", function() {
        var cb = new UiCheckbox({}, {});
        assert_true(cb.isUiNode, "isUiNode = true");
    });
    
    ui_test("Input width is 20, height is 20", function() {
        var cb  = new UiCheckbox({}, {});
        var inp = cb.Input;
        assert_equal(inp.getWidth(),  20, "Input width = 20");
        assert_equal(inp.getHeight(), 20, "Input height = 20");
    });
    
    ui_test("double toggle returns to original value", function() {
        var cb = new UiCheckbox({}, {});
        cb.dispatchEvent(UI_EVENT.click, cb);
        cb.dispatchEvent(UI_EVENT.click, cb);
        assert_false(cb.value, "back to false after double toggle");
    });
    
    ui_test("valueGetter prop stored", function() {
        var getter = function() { return true; };
        var cb = new UiCheckbox({}, { valueGetter: getter });
        assert_equal(cb.valueGetter, getter, "valueGetter stored");
    });
    
});
