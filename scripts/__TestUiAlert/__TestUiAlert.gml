// ============================================================
//  UiAlert Tests
// ============================================================

ui_test_suite("UiAlert", function() {
    
    ui_test("Create — message property set", function() {
        var a = new UiAlert("Something happened.", {}, {});
        assert_equal(a.message, "Something happened.", "message stored");
    });
    
    ui_test("Create — default type is 'info'", function() {
        var a = new UiAlert("msg", {}, {});
        assert_equal(a.alertType, "info", "alertType = info");
    });
    
    ui_test("Type prop stored correctly", function() {
        var a = new UiAlert("msg", {}, { type: "error" });
        assert_equal(a.alertType, "error", "alertType = error");
    });
    
    ui_test("title prop stored correctly", function() {
        var a = new UiAlert("msg", {}, { title: "Oops!" });
        assert_equal(a.alertTitle, "Oops!", "alertTitle = 'Oops!'");
    });
    
    ui_test("title defaults to undefined", function() {
        var a = new UiAlert("msg", {}, {});
        assert_is_undefined(a.alertTitle, "alertTitle = undefined");
    });
    
    ui_test("dismissible defaults to false", function() {
        var a = new UiAlert("msg", {}, {});
        assert_false(a.dismissible, "dismissible = false");
    });
    
    ui_test("dismissible prop can be enabled", function() {
        var a = new UiAlert("msg", {}, { dismissible: true });
        assert_true(a.dismissible, "dismissible = true");
    });
    
    ui_test("setType updates alertType", function() {
        var a = new UiAlert("msg", {}, {});
        a.setType("success");
        assert_equal(a.alertType, "success", "alertType updated to success");
    });
    
    ui_test("all types accepted without error", function() {
        var types = ["info", "success", "warning", "error"];
        for (var i = 0; i < array_length(types); i++) {
            var a = new UiAlert("msg", {}, { type: types[i] });
            assert_equal(a.alertType, types[i], "alertType = " + types[i]);
        }
    });
    
    ui_test("isUiNode is true (inherits UiNode)", function() {
        var a = new UiAlert("msg", {}, {});
        assert_true(a.isUiNode, "isUiNode = true");
    });
    
    ui_test("onDismiss defaults to a function", function() {
        var a = new UiAlert("msg", {}, {});
        assert_true(is_method(a.onDismiss), "onDismiss is a function");
    });
    
    ui_test("custom onDismiss callback stored", function() {
        var state = { called: false };
        var a = new UiAlert("msg", {}, {
            dismissible: true,
            onDismiss: method(state, function() { called = true; })
        });
        a.onDismiss();
        assert_true(state.called, "onDismiss callback fired");
    });
    
});
