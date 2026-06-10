ui_test_suite("UiSwitch", function() {
    
    ui_test("Default value is false", function() {
        var sw = new UiSwitch({}, {});
        assert_false(sw.value, "value should be false by default");
        sw.destroy();
    });
    
    ui_test("Props value is respected", function() {
        var sw = new UiSwitch({}, { value: true });
        assert_true(sw.value, "value should be true if passed in props");
        sw.destroy();
    });
    
    ui_test("Toggles value on click", function() {
        var sw = new UiSwitch({}, {});
        sw.click();
        assert_true(sw.value, "value should become true");
        sw.click();
        assert_false(sw.value, "value should become false");
        sw.destroy();
    });
    
    ui_test("onChange callback fires", function() {
        var sw = new UiSwitch({}, {});
        var state = { val: false };
        sw.onChange = method(state, function(v) { val = v; });
        sw.click();
        assert_true(state.val, "callback fired with true");
        sw.destroy();
    });
    
});
