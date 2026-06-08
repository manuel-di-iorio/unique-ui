ui_test_suite("UiSwitch", function() {
    
    var __cleanup = [];
    function __sw(props = {}) {
        var sw = new UiSwitch({}, props);
        array_push(__cleanup, sw);
        return sw;
    }
    
    ui_test("Default value is false", function() {
        var sw = __sw();
        assert_false(sw.value, "value should be false by default");
    });
    
    ui_test("Props value is respected", function() {
        var sw = __sw({ value: true });
        assert_true(sw.value, "value should be true if passed in props");
    });
    
    ui_test("Toggles value on click", function() {
        var sw = __sw();
        sw.click();
        assert_true(sw.value, "value should become true");
        sw.click();
        assert_false(sw.value, "value should become false");
    });
    
    ui_test("onChange callback fires", function() {
        var sw = __sw();
        var state = { val: false };
        sw.onChange = method(state, function(v) { val = v; });
        sw.click();
        assert_true(state.val, "callback fired with true");
    });
    
    // Cleanup
    for (var i = 0; i < array_length(__cleanup); i++) {
        __cleanup[i].destroy();
    }
});
