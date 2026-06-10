ui_test_suite("UiSlider", function() {
    
    ui_test("Default value is 0", function() {
        var sl = new UiSlider({}, {});
        assert_equal(sl.value, 0, "default value");
        assert_equal(sl.minValue, 0, "default min");
        assert_equal(sl.maxValue, 100, "default max");
        sl.destroy();
    });
    
    ui_test("Props value is respected", function() {
        var sl = new UiSlider({}, { value: 50, min: 10, max: 200 });
        assert_equal(sl.value, 50, "value");
        assert_equal(sl.minValue, 10, "min");
        assert_equal(sl.maxValue, 200, "max");
        sl.destroy();
    });
    
    ui_test("onChange callback fires on value change", function() {
        var sl = new UiSlider({}, {});
        var state = { val: 0 };
        sl.onChange(method(state, function(v) { val = v; }));
        
        sl.setValue(20);
        assert_equal(state.val, 20, "callback fired");
        sl.destroy();
    });
    
    ui_test("onChange prop fires on setValue", function() {
        var state = { val: 0 };
        var sl = new UiSlider({}, {
            onChange: method(state, function(v) { val = v; })
        });
        sl.setValue(42);
        assert_equal(state.val, 42, "prop callback fired");
        sl.destroy();
    });
    
});
