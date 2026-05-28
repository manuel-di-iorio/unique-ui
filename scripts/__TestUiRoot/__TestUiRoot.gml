// ============================================================
//  UiRoot Tests
// ============================================================

ui_test_suite("UiRoot", function() {
    
    ui_test("global.UI is a UiRoot instance", function() {
        assert_not_undefined(global.UI, "global.UI exists");
        assert_true(global.UI.root, "root flag = true");
    });
    
    ui_test("UiRoot has spatialTree", function() {
        assert_not_undefined(global.UI.spatialTree, "spatialTree exists");
    });
    
    ui_test("requestUpdate sets needsUpdate to true", function() {
        global.UI.needsUpdate = false;
        global.UI.requestUpdate();
        assert_true(global.UI.needsUpdate, "needsUpdate = true after requestUpdate");
    });
    
    ui_test("requestRedraw sets needsRedraw to true", function() {
        global.UI.needsRedraw = false;
        global.UI.requestRedraw();
        assert_true(global.UI.needsRedraw, "needsRedraw = true after requestRedraw");
    });
    
    ui_test("add child to root triggers needsUpdate", function() {
        global.UI.needsUpdate = false;
        var child = new UiNode({}, {});
        global.UI.add(child);
        assert_true(global.UI.needsUpdate, "needsUpdate = true after adding child");
        // Cleanup
        global.UI.remove(child);
    });
    
    ui_test("hasAnyFocus returns false with no focused element", function() {
        var _prev = global.UI.focusedElement;
        global.UI.focusedElement = undefined;
        assert_false(global.UI.hasAnyFocus(), "no focus");
        global.UI.focusedElement = _prev;
    });
    
    ui_test("hasAnyFocus returns true with a focused element", function() {
        var _prev = global.UI.focusedElement;
        global.UI.focusedElement = new UiNode({}, {});
        assert_true(global.UI.hasAnyFocus(), "has focus");
        global.UI.focusedElement = _prev;
    });
    
    ui_test("focusableElements starts as array", function() {
        assert_true(is_array(global.UI.focusableElements), "focusableElements is array");
    });
    
    ui_test("stepHandlers starts as array", function() {
        assert_true(is_array(global.UI.stepHandlers), "stepHandlers is array");
    });

    ui_test("update handles stepHandlers removal during iteration", function() {
        var _prevStepHandlers = global.UI.stepHandlers;
        var _state = { calledRemover: false, calledOther: false };

        var _handlerA = method(_state, function(_layoutUpdated) {
            self.calledOther = true;
        });

        var _handlerB = method(_state, function(_layoutUpdated) {
            self.calledOther = true;
        });

        var _handlerC = method(_state, function(_layoutUpdated) {
            self.calledRemover = true;
            // Simulate a destroy path that unregisters multiple handlers while iterating.
            array_delete(global.UI.stepHandlers, 1, 1);
            array_delete(global.UI.stepHandlers, 0, 1);
        });

        global.UI.stepHandlers = [
            [_handlerA, undefined],
            [_handlerB, undefined],
            [_handlerC, undefined]
        ];

        global.UI.update();

        assert_true(_state.calledRemover, "removal handler executed without crash");
        assert_true(_state.calledOther, "other handlers can still execute from snapshot");

        // Restore original handlers to avoid leaking test state.
        global.UI.stepHandlers = _prevStepHandlers;
    });
    
    ui_test("dirtyElements and redrawElements are arrays", function() {
        assert_true(is_array(global.UI.dirtyElements),    "dirtyElements is array");
        assert_true(is_array(global.UI.redrawElements),   "redrawElements is array");
    });
    
    ui_test("doubleClickThreshold is 500", function() {
        assert_equal(global.UI.doubleClickThreshold, 500, "doubleClickThreshold");
    });
    
    ui_test("UiRoot flag properties initialized correctly", function() {
        assert_true(is_bool(global.UI.isScrolling) || global.UI.isScrolling == false);
        // draggedElement may start undefined, so we check for undefined or a struct
        if (!is_undefined(global.UI.draggedElement)) {
             assert_true(is_struct(global.UI.draggedElement));
        } else {
             assert_is_undefined(global.UI.draggedElement);
        }
    });
    
});
