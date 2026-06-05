// ============================================================
//  UiMenuBar Tests
// ============================================================

ui_test_suite("UiMenuBar", function() {

    // ── Construction ──────────────────────────────────────────

    ui_test("isUiNode - inherits UiNode", function() {
        var bar = new UiMenuBar([], {}, {});
        assert_true(bar.isUiNode, "isUiNode = true");
    });

    ui_test("menus array stored from constructor arg", function() {
        var menus = [
            { label: "File", items: [] },
            { label: "Edit", items: [] }
        ];
        var bar = new UiMenuBar(menus, {}, {});
        assert_equal(array_length(bar.menus), 2, "menus length = 2");
    });

    ui_test("menus defaults to empty array", function() {
        var bar = new UiMenuBar([], {}, {});
        assert_true(is_array(bar.menus), "menus is array");
        assert_equal(array_length(bar.menus), 0, "menus empty by default");
    });

    ui_test("activeMenu is undefined on creation", function() {
        var bar = new UiMenuBar([], {}, {});
        assert_is_undefined(bar.activeMenu, "activeMenu = undefined");
    });

    ui_test("activeTrigger is undefined on creation", function() {
        var bar = new UiMenuBar([], {}, {});
        assert_is_undefined(bar.activeTrigger, "activeTrigger = undefined");
    });

    ui_test("__triggerNodes length matches menus", function() {
        var menus = [
            { label: "File", items: [] },
            { label: "Edit", items: [] },
            { label: "View", items: [] }
        ];
        var bar = new UiMenuBar(menus, {}, {});
        assert_equal(array_length(bar.__triggerNodes), 3, "triggerNodes = 3");
    });

    ui_test("children count matches menus count", function() {
        var menus = [
            { label: "File", items: [] },
            { label: "Edit", items: [] }
        ];
        var bar = new UiMenuBar(menus, {}, {});
        assert_equal(bar.count(), 2, "2 children for 2 menus");
    });

    ui_test("each trigger has __label matching menu label", function() {
        var menus = [
            { label: "File", items: [] },
            { label: "Edit", items: [] }
        ];
        var bar = new UiMenuBar(menus, {}, {});
        assert_equal(bar.__triggerNodes[0].__label, "File", "trigger 0 label = File");
        assert_equal(bar.__triggerNodes[1].__label, "Edit", "trigger 1 label = Edit");
    });

    ui_test("each trigger has __menuData reference", function() {
        var menus = [{ label: "File", items: [] }];
        var bar = new UiMenuBar(menus, {}, {});
        assert_not_undefined(bar.__triggerNodes[0].__menuData, "menuData exists");
        assert_equal(bar.__triggerNodes[0].__menuData.label, "File", "menuData.label = File");
    });

    ui_test("each trigger has __bar reference to the bar", function() {
        var bar = new UiMenuBar([{ label: "File", items: [] }], {}, {});
        assert_equal(bar.__triggerNodes[0].__bar, bar, "trigger.__bar = bar");
    });

    // ── closeAll ──────────────────────────────────────────────

    ui_test("closeAll with no open menu does not error", function() {
        var bar = new UiMenuBar([], {}, {});
        bar.closeAll(); // should not throw
        assert_is_undefined(bar.activeMenu,    "activeMenu still undefined");
        assert_is_undefined(bar.activeTrigger, "activeTrigger still undefined");
    });

    // ── Menu items structure ──────────────────────────────────

    ui_test("separator item has separator = true", function() {
        var items = [{ separator: true }];
        // Just verify the data structure is accepted without error
        var bar = new UiMenuBar([{ label: "File", items: items }], {}, {});
        assert_equal(bar.menus[0].items[0].separator, true, "separator = true");
    });

    ui_test("disabled item stored correctly", function() {
        var items = [{ label: "Save", onClick: function(){}, disabled: true }];
        var bar = new UiMenuBar([{ label: "File", items: items }], {}, {});
        assert_true(bar.menus[0].items[0].disabled, "disabled = true");
    });

    ui_test("shortcut stored in item", function() {
        var items = [{ label: "New", onClick: function(){}, shortcut: "Ctrl+N" }];
        var bar = new UiMenuBar([{ label: "File", items: items }], {}, {});
        assert_equal(bar.menus[0].items[0].shortcut, "Ctrl+N", "shortcut = Ctrl+N");
    });

    ui_test("onClick callback stored in item", function() {
        var cb = function() {};
        var items = [{ label: "New", onClick: cb }];
        var bar = new UiMenuBar([{ label: "File", items: items }], {}, {});
        assert_equal(bar.menus[0].items[0].onClick, cb, "onClick = cb");
    });

    // ── __openMenu / closeAll lifecycle ──────────────────────

    ui_test("__openMenu sets activeMenu and activeTrigger", function() {
        // Requires UI overlay - back up and mock
        var _overlayBackup = global.UI[$ "Overlay"] ?? undefined;
        global.UI.Overlay = new UiNode({}, {});
        global.UI.add(global.UI.Overlay);

        var bar = new UiMenuBar([{ label: "File", items: [] }], {}, {});
        global.UI.add(bar);

        bar.__openMenu(bar.__triggerNodes[0]);
        assert_not_undefined(bar.activeMenu,    "activeMenu set after open");
        assert_not_undefined(bar.activeTrigger, "activeTrigger set after open");
        assert_equal(bar.activeTrigger, bar.__triggerNodes[0], "activeTrigger = trigger[0]");

        // Cleanup
        bar.closeAll();
        global.UI.remove(bar);
        global.UI.remove(global.UI.Overlay);
        global.UI.Overlay = _overlayBackup;
    });

    ui_test("closeAll after open resets activeMenu and activeTrigger", function() {
        var _overlayBackup = global.UI[$ "Overlay"] ?? undefined;
        global.UI.Overlay = new UiNode({}, {});
        global.UI.add(global.UI.Overlay);

        var bar = new UiMenuBar([{ label: "File", items: [] }], {}, {});
        global.UI.add(bar);

        bar.__openMenu(bar.__triggerNodes[0]);
        bar.closeAll();

        assert_is_undefined(bar.activeMenu,    "activeMenu = undefined after close");
        assert_is_undefined(bar.activeTrigger, "activeTrigger = undefined after close");

        // Cleanup
        global.UI.remove(bar);
        global.UI.remove(global.UI.Overlay);
        global.UI.Overlay = _overlayBackup;
    });

    ui_test("opening a second menu closes the first", function() {
        var _overlayBackup = global.UI[$ "Overlay"] ?? undefined;
        global.UI.Overlay = new UiNode({}, {});
        global.UI.add(global.UI.Overlay);

        var bar = new UiMenuBar([
            { label: "File", items: [] },
            { label: "Edit", items: [] }
        ], {}, {});
        global.UI.add(bar);

        bar.__openMenu(bar.__triggerNodes[0]);
        var _firstMenu = bar.activeMenu;

        bar.__openMenu(bar.__triggerNodes[1]);
        // First menu should be destroyed, activeTrigger should be trigger[1]
        assert_equal(bar.activeTrigger, bar.__triggerNodes[1], "activeTrigger switched to trigger[1]");
        assert_not_equal(bar.activeMenu, _firstMenu, "new dropdown is different from first");

        // Cleanup
        bar.closeAll();
        global.UI.remove(bar);
        global.UI.remove(global.UI.Overlay);
        global.UI.Overlay = _overlayBackup;
    });

});
