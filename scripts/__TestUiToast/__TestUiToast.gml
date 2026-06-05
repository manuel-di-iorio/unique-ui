// ============================================================
//  UiToast Tests
// ============================================================

ui_test_suite("UiToast", function() {
    
    ui_test("Create - is UiNode with pointerEvents false", function() {
        var t = new UiToast({}, {});
        assert_true(t.isUiNode, "isUiNode = true");
        assert_false(t.pointerEvents, "pointerEvents = false on container");
        t.destroy();
    });
    
    ui_test("Show - creates alert and inserts at index 0", function() {
        var t = new UiToast({}, {});
        var a1 = t.show("First toast", "info", undefined, 0);
        
        assert_equal(t.childrenLength, 1, "contains 1 alert");
        assert_equal(t.children[0], a1, "alert 1 is at index 0");
        assert_equal(a1.message, "First toast", "message correct");
        assert_equal(a1.alertType, "info", "type correct");
        
        var a2 = t.show("Second toast", "success", "Alert Title", 0);
        assert_equal(t.childrenLength, 2, "contains 2 alerts");
        assert_equal(t.children[0], a2, "alert 2 (newest) is at index 0");
        assert_equal(t.children[1], a1, "alert 1 (older) is pushed to index 1");
        assert_equal(a2.message, "Second toast", "message correct");
        assert_equal(a2.alertType, "success", "type correct");
        assert_equal(a2.alertTitle, "Alert Title", "title correct");
        
        t.destroy();
    });
    
    ui_test("Shorthand functions create correct types", function() {
        var t = new UiToast({}, {});
        
        var s = t.success("Success msg", undefined, 0);
        assert_equal(s.alertType, "success", "type success");
        
        var e = t.error("Error msg", undefined, 0);
        assert_equal(e.alertType, "error", "type error");
        
        var w = t.warning("Warning msg", undefined, 0);
        assert_equal(w.alertType, "warning", "type warning");
        
        var i = t.info("Info msg", undefined, 0);
        assert_equal(i.alertType, "info", "type info");
        
        t.destroy();
    });
    
    ui_test("Global functions lazily initialize global.UiToastInstance", function() {
        // Clear global first
        if (global.UiToastInstance != undefined) {
            global.UiToastInstance.destroy();
            global.UiToastInstance = undefined;
        }
        
        assert_is_undefined(global.UiToastInstance, "initially undefined");
        
        var a = ui_toast_show("Global message", "success", "Global Title", 0);
        assert_not_undefined(global.UiToastInstance, "lazily initialized");
        assert_equal(global.UiToastInstance.childrenLength, 1, "container contains 1 alert");
        assert_equal(global.UiToastInstance.children[0], a, "alert is in global container");
        assert_equal(a.message, "Global message", "message match");
        assert_equal(a.alertType, "success", "type match");
        assert_equal(a.alertTitle, "Global Title", "title match");
        
        // Clean up
        global.UiToastInstance.destroy();
        global.UiToastInstance = undefined;
    });
    
    ui_test("Global shorthand functions trigger successfully", function() {
        if (global.UiToastInstance != undefined) {
            global.UiToastInstance.destroy();
            global.UiToastInstance = undefined;
        }
        
        var s = ui_toast_success("Success test", undefined, 0);
        assert_equal(s.alertType, "success", "success shortcut");
        
        var e = ui_toast_error("Error test", undefined, 0);
        assert_equal(e.alertType, "error", "error shortcut");
        
        var w = ui_toast_warning("Warning test", undefined, 0);
        assert_equal(w.alertType, "warning", "warning shortcut");
        
        var i = ui_toast_info("Info test", undefined, 0);
        assert_equal(i.alertType, "info", "info shortcut");
        
        global.UiToastInstance.destroy();
        global.UiToastInstance = undefined;
    });
});
