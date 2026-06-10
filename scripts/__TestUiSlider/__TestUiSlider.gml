ui_test_suite("UiSlider", function() {
    
    ui_test("Default value is 0", function() {
        var sl = new UiSlider({}, {});
        assert_equal(sl.value, 0, "default value");
        assert_equal(sl.minValue, 0, "default min");
        assert_equal(sl.maxValue, 100, "default max");
    });
    
    ui_test("Props value is respected", function() {
        var sl = new UiSlider({}, { value: 50, min: 10, max: 200 });
        assert_equal(sl.value, 50, "value");
        assert_equal(sl.minValue, 10, "min");
        assert_equal(sl.maxValue, 200, "max");
    });
    
    ui_test("onChange callback fires on value change", function() {
        var sl = new UiSlider({}, {});
        var state = { val: 0 };
        sl.onChange = method(state, function(v) { val = v; });
        
        sl.value = 20;
        sl.onChange(sl.value, sl);
        assert_equal(state.val, 20, "callback fired");
    });
    
});
