// ============================================================
//  DynamicAABBTree2D Tests
// ============================================================

ui_test_suite("DynamicAABBTree2D", function() {
    
    ui_test("Empty tree has root = -1 and nodeCount = 0", function() {
        var tree = new DynamicAABBTree2D(16);
        assert_equal(tree.root, -1, "root");
        assert_equal(tree.nodeCount, 0, "nodeCount");
    });
    
    ui_test("insert single element increases nodeCount", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 0 };
        var _id = tree.insert(dummy, 0, 0, 100, 100);
        assert_equal(tree.nodeCount, 1, "nodeCount after insert");
        assert_greater_equal(tree.root, 0, "root valid");
    });
    
    ui_test("insert multiple elements increases nodeCount correctly", function() {
        var tree = new DynamicAABBTree2D(16);
        var d = { __drawIndex: 0 };
        tree.insert(d, 0,   0,  50,  50);
        tree.insert(d, 60,  0, 110,  50);
        tree.insert(d, 0,  60,  50, 110);
        assert_equal(tree.nodeCount, 5, "3 leaves + 2 internal nodes");
    });
    
    ui_test("queryPoint finds element at its center", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 0, hit: false };
        tree.insert(dummy, 0, 0, 100, 100);
        tree.queryPoint(50, 50, function(userData, nodeId) {
            userData.hit = true;
        });
        assert_true(dummy.hit, "element found at center");
    });
    
    ui_test("queryPoint misses point outside element", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 0, hit: false };
        tree.insert(dummy, 0, 0, 100, 100);
        tree.queryPoint(200, 200, function(userData, nodeId) {
            userData.hit = true;
        });
        assert_false(dummy.hit, "element not found outside bounds");
    });
    
    ui_test("getTopmostAtPoint returns element at point", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 5 };
        tree.insert(dummy, 0, 0, 100, 100);
        var result = tree.getTopmostAtPoint(50, 50);
        assert_equal(result, dummy, "correct element returned");
    });
    
    ui_test("getTopmostAtPoint returns element with highest drawIndex when overlapping", function() {
        var tree = new DynamicAABBTree2D(16);
        var low  = { __drawIndex: 1 };
        var high = { __drawIndex: 10 };
        tree.insert(low,  0, 0, 100, 100);
        tree.insert(high, 0, 0, 100, 100);
        var result = tree.getTopmostAtPoint(50, 50);
        assert_equal(result, high, "topmost element (highest drawIndex) returned");
    });
    
    ui_test("getTopmostAtPoint returns undefined for empty point", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 0 };
        tree.insert(dummy, 0, 0, 50, 50);
        var result = tree.getTopmostAtPoint(200, 200);
        assert_is_undefined(result, "no element at empty point");
    });
    
    ui_test("remove decreases nodeCount and makes element not queryable", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 0, hit: false };
        var _id = tree.insert(dummy, 0, 0, 100, 100);
        tree.remove(_id);
        assert_equal(tree.nodeCount, 0, "nodeCount after remove");
        tree.queryPoint(50, 50, function(ud, ni) { ud.hit = true; });
        assert_false(dummy.hit, "element not queryable after remove");
    });
    
    ui_test("move small — element stays queryable at original position", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 0 };
        var _id = tree.insert(dummy, 0, 0, 100, 100);
        // Move by 1px (within fat AABB extension of 2px)
        tree.move(_id, 1, 1, 101, 101);
        var result = tree.getTopmostAtPoint(50, 50);
        assert_equal(result, dummy, "element still queryable after small move");
    });
    
    ui_test("move large — element queryable at new position, not old", function() {
        var tree = new DynamicAABBTree2D(16);
        var dummy = { __drawIndex: 0 };
        var _id = tree.insert(dummy, 0, 0, 100, 100);
        tree.move(_id, 500, 500, 600, 600);
        var old_result = tree.getTopmostAtPoint(50, 50);
        var new_result = tree.getTopmostAtPoint(550, 550);
        assert_is_undefined(old_result, "element not at old position");
        assert_equal(new_result, dummy, "element at new position");
    });
    
    ui_test("clear resets tree to empty state", function() {
        var tree = new DynamicAABBTree2D(16);
        var d = { __drawIndex: 0 };
        tree.insert(d, 0, 0, 100, 100);
        tree.insert(d, 200, 0, 300, 100);
        tree.clear();
        assert_equal(tree.nodeCount, 0, "nodeCount after clear");
        assert_equal(tree.root, -1, "root after clear");
    });
    
    ui_test("updateDrawIndex propagates maxDrawIndex up ancestors", function() {
        var tree = new DynamicAABBTree2D(16);
        var a = { __drawIndex: 1 };
        var b = { __drawIndex: 2 };
        var idA = tree.insert(a, 0, 0, 50, 50);
        var idB = tree.insert(b, 60, 0, 110, 50);
        tree.updateDrawIndex(idA, 99);
        // The root should now have maxDrawIndex >= 99
        assert_greater_equal(tree.maxDrawIndex[tree.root], 99, "maxDrawIndex propagated");
    });
    
    ui_test("dynamic capacity expansion — insert beyond initial capacity", function() {
        var tree = new DynamicAABBTree2D(4);
        var d = { __drawIndex: 0 };
        // Insert 10 items (forces expansion)
        for (var i = 0; i < 10; i++) {
            tree.insert(d, i * 20, 0, i * 20 + 10, 10);
        }
        // Should not crash and nodeCount should reflect the insertions
        assert_greater(tree.nodeCount, 0, "tree expanded and has nodes");
    });
    
});
