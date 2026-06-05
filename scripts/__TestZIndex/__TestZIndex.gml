// ============================================================
//  Z-Index / Draw Order Tests
// ============================================================

ui_test_suite("ZIndexAndDrawOrder", function() {
    
    ui_test("Spatial tree: element with higher drawIndex wins overlap", function() {
        var tree = new DynamicAABBTree2D(32);
        var low  = { __drawIndex: 1 };
        var high = { __drawIndex: 20 };
        tree.insert(low,  10, 10, 200, 200);
        tree.insert(high, 10, 10, 200, 200);
        var result = tree.getTopmostAtPoint(100, 100);
        assert_equal(result, high, "high drawIndex element wins");
    });
    
    ui_test("Spatial tree: three overlapping - highest drawIndex wins", function() {
        var tree = new DynamicAABBTree2D(32);
        var a = { __drawIndex: 5  };  
        var b = { __drawIndex: 15 };  
        var c = { __drawIndex: 10 };  
        tree.insert(a, 0, 0, 100, 100);
        tree.insert(b, 0, 0, 100, 100);
        tree.insert(c, 0, 0, 100, 100);
        var result = tree.getTopmostAtPoint(50, 50);
        assert_equal(result, b, "b (drawIndex=15) wins");
    });
    
    ui_test("Non-overlapping: each point returns its own element", function() {
        var tree = new DynamicAABBTree2D(32);
        var left  = { __drawIndex: 1 };
        var right = { __drawIndex: 2 };
        tree.insert(left,  0,   0, 100, 100);
        tree.insert(right, 200, 0, 300, 100);
        assert_equal(tree.getTopmostAtPoint(50,  50),  left,  "left at its point");
        assert_equal(tree.getTopmostAtPoint(250, 50),  right, "right at its point");
    });
    
    ui_test("Removed element no longer in spatial query", function() {
        var tree = new DynamicAABBTree2D(32);
        var d = { __drawIndex: 5 };
        var _id = tree.insert(d, 0, 0, 100, 100);
        tree.remove(_id);
        var result = tree.getTopmostAtPoint(50, 50);
        assert_is_undefined(result, "removed element not returned");
    });
    
    ui_test("updateDrawIndex changes priority in getTopmostAtPoint", function() {
        var tree = new DynamicAABBTree2D(32);
        var a = { __drawIndex: 10 };
        var b = { __drawIndex: 5  };
        var idA = tree.insert(a, 0, 0, 100, 100);
        var idB = tree.insert(b, 0, 0, 100, 100);
        
        // Before update: a wins
        assert_equal(tree.getTopmostAtPoint(50, 50), a, "a wins initially");
        
        // Update b to higher draw index
        tree.updateDrawIndex(idB, 20);
        b.__drawIndex = 20;
        var result = tree.getTopmostAtPoint(50, 50);
        assert_equal(result, b, "b wins after drawIndex update");
    });
    
    ui_test("Element outside spatial tree (display=false) is not queryable", function() {
        var tree = new DynamicAABBTree2D(32);
        // Never inserted - simulates a hidden element
        var result = tree.getTopmostAtPoint(50, 50);
        assert_is_undefined(result, "nothing in empty tree");
    });
    
    ui_test("Move element to new position - old position returns undefined", function() {
        var tree = new DynamicAABBTree2D(32);
        var d  = { __drawIndex: 1 };
        var _id = tree.insert(d, 0, 0, 50, 50);
        tree.move(_id, 300, 300, 350, 350);
        
        // Old position
        var old = tree.getTopmostAtPoint(25, 25);
        // New position
        var new_ = tree.getTopmostAtPoint(325, 325);
        
        assert_is_undefined(old,  "old position empty after move");
        assert_equal(new_, d,    "element at new position");
    });
    
});
