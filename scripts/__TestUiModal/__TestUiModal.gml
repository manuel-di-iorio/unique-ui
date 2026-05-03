// ============================================================
//  UiModal Tests
// ============================================================

ui_test_suite("UiModal", function() {

    ui_test("UiModal overrides add method", function() {
        var modal = new UiModal({}, { title: "Test Modal" });
        var child = new UiNode({});
        modal.add(child);
        
        assert_equal(modal.Body.childrenLength, 1, "Child should be added to the Body node");
    });
    
    ui_test("UiModal can be opened and closed", function() {
        var modal = new UiModal({}, {});
        
        modal.open();
        assert_not_undefined(modal.parent, "Modal should have a parent when opened");
        
        modal.close();
        assert_true(modal.destroyed, "Modal should be destroyed upon closing");
    });

});
