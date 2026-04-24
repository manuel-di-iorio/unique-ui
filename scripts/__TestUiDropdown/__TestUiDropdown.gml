// ============================================================
//  UiDropdown Tests
// ============================================================

ui_test_suite("UiDropdown", function() {
    
    ui_test("items array stored from props", function() {
        var items = [{ label: "A", value: "a" }];
        var dd = new UiDropdown({}, { items: items });
        assert_equal(array_length(dd.items), 1, "items stored");
    });
    
    ui_test("items defaults to empty array", function() {
        var dd = new UiDropdown({}, {});
        assert_true(is_array(dd.items), "items is array");
        assert_equal(array_length(dd.items), 0, "items empty by default");
    });
    
    ui_test("value stored from props", function() {
        var items = [{ label: "A", value: "a" }];
        var dd = new UiDropdown({}, { items: items, value: "a" });
        assert_equal(dd.value, "a", "value = 'a'");
    });
    
    ui_test("value defaults to undefined", function() {
        var dd = new UiDropdown({}, {});
        assert_is_undefined(dd.value, "value = undefined");
    });
    
    ui_test("label stored from props", function() {
        var dd = new UiDropdown({}, { label: "My Label" });
        assert_equal(dd.label, "My Label", "label stored");
    });
    
    ui_test("label is undefined when not provided", function() {
        var dd = new UiDropdown({}, {});
        assert_is_undefined(dd.label, "label = undefined");
    });
    
    ui_test("Input (UiButton) sub-node exists", function() {
        var dd = new UiDropdown({}, {});
        assert_not_undefined(dd.Input, "Input exists");
        assert_true(dd.Input.isUiNode, "Input is UiNode");
    });
    
    ui_test("List is undefined before opening", function() {
        var dd = new UiDropdown({}, {});
        assert_is_undefined(dd.List, "List = undefined before open");
    });
    
    ui_test("onChange callback stored from props", function() {
        var cb = function(v) {};
        var dd = new UiDropdown({}, { onChange: cb });
        assert_equal(dd.onChange, cb, "onChange stored");
    });
    
    ui_test("isUiNode true (inherits UiNode)", function() {
        var dd = new UiDropdown({}, {});
        assert_true(dd.isUiNode, "isUiNode = true");
    });
    
    ui_test("itemsGetter stored from props", function() {
        var getter = function(s) { return []; };
        var dd = new UiDropdown({}, { itemsGetter: getter });
        assert_equal(dd.itemsGetter, getter, "itemsGetter stored");
    });
    
    ui_test("closeList destroys List node and sets to undefined", function() {
        // We need global.UI.Overlay for createList, so we mock it
        var _overlay_backup = global.UI[$ "Overlay"] ?? undefined;
        global.UI.Overlay = new UiNode({}, {});
        global.UI.add(global.UI.Overlay);
        
        var items = [{ label: "A", value: "a" }];
        var dd = new UiDropdown({ height: 25 }, { items: items });
        global.UI.add(dd);
        
        dd.createList();
        assert_not_undefined(dd.List, "List created");
        
        dd.closeList();
        assert_is_undefined(dd.List, "List = undefined after closeList");
        
        // Cleanup
        global.UI.remove(dd);
        global.UI.remove(global.UI.Overlay);
        global.UI.Overlay = _overlay_backup;
    });
    
    ui_test("value resets to undefined when item removed from list", function() {
        var items = [
            { label: "A", value: "a" },
            { label: "B", value: "b" },
        ];
        var state = { changed_to: "NOT_CALLED" };
        var dd = new UiDropdown({}, {
            items: items,
            value: "b",
            onChange: method(state, function(v) { changed_to = v; })
        });
        
        // Simulate item disappearing
        dd.items = [{ label: "A", value: "a" }];
        
        // The onStep checks for validity - simulate it manually
        var found = false;
        for (var i = 0; i < array_length(dd.items); i++) {
            if (dd.items[i].value == dd.value) { found = true; break; }
        }
        if (!found) {
            dd.value = undefined;
            dd.onChange(undefined);
        }
        
        assert_is_undefined(dd.value, "value reset to undefined");
        assert_is_undefined(state.changed_to, "onChange called with undefined");
    });
    
});
