// ============================================================
//  UiTreeview Tests
// ============================================================

ui_test_suite("UiTreeview", function() {
    
    function __make_treeview() {
        return new UiTreeview({}, {});
    }
    
    function __make_item(tv) {
        return new UiTreeviewItem({}, {
            treeview:  tv,
            assetType: "Folder",
            name:      "Item"
        });
    }
    
    // ── UiTreeview creation ──────────────────────────────────
    
    ui_test("Treeview creates Items container", function() {
        var tv = __make_treeview();
        assert_not_undefined(tv.Items, "Items exists");
        assert_true(tv.Items.isUiNode, "Items is UiNode");
    });
    
    ui_test("selectedItem starts as undefined", function() {
        var tv = __make_treeview();
        assert_is_undefined(tv.selectedItem, "selectedItem = undefined");
    });
    
    ui_test("pointerEvents is true", function() {
        var tv = __make_treeview();
        assert_true(tv.pointerEvents, "pointerEvents = true");
    });
    
    ui_test("onItemSelected starts as undefined", function() {
        var tv = __make_treeview();
        assert_is_undefined(tv.onItemSelected, "onItemSelected = undefined");
    });
    
    ui_test("onContextMenu starts as undefined", function() {
        var tv = __make_treeview();
        assert_is_undefined(tv.onContextMenu, "onContextMenu = undefined");
    });
    
    // ── __onItemSelected ─────────────────────────────────────
    
    ui_test("__onItemSelected sets selectedItem", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        tv.Items.add(item);
        tv.__onItemSelected(item);
        assert_equal(tv.selectedItem, item, "selectedItem = item");
    });
    
    ui_test("__onItemSelected calls onItemSelected callback", function() {
        var tv      = __make_treeview();
        var item    = __make_item(tv);
        var state   = { called: false };
        tv.Items.add(item);
        tv.onItemSelected = method(state, function(i, f) { called = true; });
        tv.__onItemSelected(item);
        assert_true(state.called, "onItemSelected callback called");
    });
    
    ui_test("__onItemSelected passes item to callback", function() {
        var tv      = __make_treeview();
        var item    = __make_item(tv);
        var state   = { received: undefined };
        tv.Items.add(item);
        tv.onItemSelected = method(state, function(i, f) { received = i; });
        tv.__onItemSelected(item);
        assert_equal(state.received, item, "callback receives correct item");
    });
    
    // ── validateDrop ─────────────────────────────────────────
    
    ui_test("validateDrop returns false when dragging onto itself", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        assert_false(tv.validateDrop(item, item), "cannot drop on self");
    });
    
    ui_test("validateDrop false for Texture type", function() {
        var tv = __make_treeview();
        var dragged = new UiTreeviewItem({}, { treeview: tv, assetType: "Texture" });
        var target  = new UiTreeviewItem({}, { treeview: tv, assetType: "Folder"  });
        assert_false(tv.validateDrop(dragged, target), "Texture cannot be moved");
    });
    
    ui_test("validateDrop false for Material type", function() {
        var tv = __make_treeview();
        var dragged = new UiTreeviewItem({}, { treeview: tv, assetType: "Material" });
        var target  = new UiTreeviewItem({}, { treeview: tv, assetType: "Folder"   });
        assert_false(tv.validateDrop(dragged, target), "Material cannot be moved");
    });
    
    ui_test("validateDrop true: Folder dropped on Folder", function() {
        var tv = __make_treeview();
        var dragged = new UiTreeviewItem({}, { treeview: tv, assetType: "Folder" });
        var target  = new UiTreeviewItem({}, { treeview: tv, assetType: "Folder" });
        assert_true(tv.validateDrop(dragged, target), "Folder can drop on Folder");
    });
    
    // ── UiTreeviewItem ───────────────────────────────────────
    
    ui_test("Item has Content sub-node", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        assert_not_undefined(item.Content, "Content exists");
    });
    
    ui_test("Item has Items sub-node (children container)", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        assert_not_undefined(item.Items, "Items exists");
    });
    
    ui_test("Item has Arrow sub-node", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        assert_not_undefined(item.Arrow, "Arrow exists");
    });
    
    ui_test("Item starts collapsed = true", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        assert_true(item.collapsed, "starts collapsed");
    });
    
    ui_test("Item.selected starts false", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        assert_false(item.selected, "selected = false");
    });
    
    ui_test("addChild adds to Items.children", function() {
        var tv     = __make_treeview();
        var parent = __make_item(tv);
        var child  = __make_item(tv);
        parent.Items.add(child);
        parent.__updateArrowVisibility();
        assert_equal(parent.Items.childrenLength, 1, "1 child in Items");
    });
    
    ui_test("expandItem sets collapsed = false and shows Items", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        item.expandItem();
        assert_false(item.collapsed, "collapsed = false after expand");
        assert_true(item.Items.display, "Items display = true after expand");
    });
    
    ui_test("collapseItem sets collapsed = true and hides Items", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        item.expandItem();
        item.collapseItem();
        assert_true(item.collapsed, "collapsed = true after collapse");
        assert_false(item.Items.display, "Items display = false after collapse");
    });
    
    ui_test("Arrow invisible when no children", function() {
        var tv   = __make_treeview();
        var item = __make_item(tv);
        item.__updateArrowVisibility();
        assert_false(item.Arrow.visible, "Arrow hidden with no children");
    });
    
    ui_test("Arrow visible when has children", function() {
        var tv     = __make_treeview();
        var parent = __make_item(tv);
        var child  = __make_item(tv);
        parent.Items.add(child);
        parent.__updateArrowVisibility();
        assert_true(parent.Arrow.visible, "Arrow visible with children");
    });
    
    ui_test("collapseAll collapses all items recursively", function() {
        var tv    = __make_treeview();
        var root  = __make_item(tv);
        var child = __make_item(tv);
        tv.Items.add(root);
        root.Items.add(child);
        root.expandItem();
        child.expandItem();
        tv.collapseAll();
        assert_true(root.collapsed,  "root collapsed");
        assert_true(child.collapsed, "child collapsed");
    });
    
    // ── filter ───────────────────────────────────────────────
    
    ui_test("filter with empty string shows all items", function() {
        var tv = __make_treeview();
        var a  = new UiTreeviewItem({}, { treeview: tv, name: "Alpha" });
        var b  = new UiTreeviewItem({}, { treeview: tv, name: "Beta"  });
        tv.Items.add(a, b);
        // Ensure both have display = false first
        a.hide(); b.hide();
        tv.filter("");
        assert_true(a.display, "Alpha visible with empty filter");
        assert_true(b.display, "Beta visible with empty filter");
    });
    
    ui_test("filter hides non-matching items", function() {
        var tv = __make_treeview();
        var a  = new UiTreeviewItem({}, { treeview: tv, name: "Alpha" });
        var b  = new UiTreeviewItem({}, { treeview: tv, name: "Beta"  });
        tv.Items.add(a, b);
        tv.filter("alpha");
        assert_true(a.display,  "Alpha visible");
        assert_false(b.display, "Beta hidden");
    });
    
});
