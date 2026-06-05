// ============================================================
//  UiNode Tests
// ============================================================

ui_test_suite("UiNode", function() {
    
    // ── Helpers ─────────────────────────────────────────────
    
    /// Make a detached root-like environment so nodes can .add() freely
    /// without needing global.UI to exist in tests.
    /// We simply set global.UI.requestUpdate/requestRedraw to no-ops if needed.
    function __make_node(style = {}, props = {}) {
        return new UiNode(style, props);
    }
    
    // ── Creation ────────────────────────────────────────────
    
    ui_test("Node has unique numeric id", function() {
        var a = __make_node();
        var b = __make_node();
        assert_true(is_real(a.id), "id is real");
        assert_greater(b.id, a.id, "ids increment");
    });
    
    ui_test("Default properties set correctly", function() {
        var n = __make_node();
        assert_equal(n.type, "UiNode", "type");
        assert_true(n.isUiNode, "isUiNode");
        assert_false(n.destroyed, "not destroyed");
        assert_false(n.focused, "not focused");
        assert_false(n.hovered, "not hovered");
        assert_true(n.visible, "visible by default");
        assert_true(n.display, "display by default");
        assert_false(n.pointerEvents, "pointerEvents off by default");
        assert_equal(n.childrenLength, 0, "no children");
        assert_equal(array_length(n.children), 0, "children array empty");
    });
    
    ui_test("pointerEvents prop passed correctly", function() {
        var n = __make_node({}, { pointerEvents: true });
        assert_true(n.pointerEvents, "pointerEvents = true");
    });
    
    // ── setName / getName ────────────────────────────────────
    
    ui_test("setName and getName round-trip", function() {
        var n = __make_node();
        n.setName("TestNode");
        assert_equal(n.getName(), "TestNode", "name round-trip");
    });
    
    // ── Children management ──────────────────────────────────
    
    ui_test("add single child sets parent and childrenLength", function() {
        var parent = __make_node();
        var child  = __make_node();
        parent.add(child);
        assert_equal(parent.childrenLength, 1, "childrenLength = 1");
        assert_equal(array_length(parent.children), 1, "children array length");
        assert_equal(child.parent, parent, "child.parent set");
    });
    
    ui_test("add multiple children in one call", function() {
        var parent = __make_node();
        var c1 = __make_node();
        var c2 = __make_node();
        var c3 = __make_node();
        parent.add(c1, c2, c3);
        assert_equal(parent.childrenLength, 3, "3 children");
        assert_equal(parent.children[0], c1, "correct order [0]");
        assert_equal(parent.children[1], c2, "correct order [1]");
        assert_equal(parent.children[2], c3, "correct order [2]");
    });
    
    ui_test("add re-parents child from old parent", function() {
        var p1 = __make_node();
        var p2 = __make_node();
        var c  = __make_node();
        p1.add(c);
        assert_equal(c.parent, p1, "initial parent");
        p2.add(c);
        assert_equal(c.parent, p2, "new parent after re-add");
        assert_equal(p1.childrenLength, 0, "old parent has 0 children");
        assert_equal(p2.childrenLength, 1, "new parent has 1 child");
    });
    
    ui_test("remove child clears parent and childrenLength", function() {
        var parent = __make_node();
        var child  = __make_node();
        parent.add(child);
        parent.remove(child);
        assert_equal(parent.childrenLength, 0, "childrenLength = 0");
        assert_is_undefined(child.parent, "child.parent = undefined");
    });
    
    ui_test("remove specific child from multi-children node", function() {
        var parent = __make_node();
        var c1 = __make_node();
        var c2 = __make_node();
        var c3 = __make_node();
        parent.add(c1, c2, c3);
        parent.remove(c2);
        assert_equal(parent.childrenLength, 2, "2 children remain");
        assert_equal(parent.children[0], c1, "c1 remains at [0]");
        assert_equal(parent.children[1], c3, "c3 remains at [1]");
    });
    
    ui_test("clear removes all children", function() {
        var parent = __make_node();
        parent.add(__make_node(), __make_node(), __make_node());
        parent.clear();
        assert_equal(parent.childrenLength, 0, "childrenLength = 0 after clear");
        assert_equal(array_length(parent.children), 0, "children array empty after clear");
    });
    
    // ── count / countAll ─────────────────────────────────────
    
    ui_test("count returns direct children count", function() {
        var parent = __make_node();
        parent.add(__make_node(), __make_node());
        assert_equal(parent.count(), 2, "count = 2");
    });
    
    ui_test("countAll returns recursive count", function() {
        var root = __make_node();
        var mid  = __make_node();
        var leaf = __make_node();
        root.add(mid);
        mid.add(leaf);
        // root: 1 (self) + 1 (mid) + 1 (leaf) = 3
        assert_equal(root.countAll(), 3, "countAll = 3");
    });
    
    // ── show / hide ──────────────────────────────────────────
    
    ui_test("hide sets display = false", function() {
        var n = __make_node();
        n.hide();
        assert_false(n.display, "display = false after hide");
    });
    
    ui_test("show sets display = true", function() {
        var n = __make_node();
        n.hide();
        n.show();
        assert_true(n.display, "display = true after show");
    });
    
    // ── visible / isVisible ──────────────────────────────────
    
    ui_test("isVisible true when display and visible both true", function() {
        var n = __make_node();
        n.display = true;
        n.visible = true;
        // scrollableParent = undefined → __isInScrollBounds returns true
        assert_true(n.isVisible(), "visible with display=true, visible=true");
    });
    
    ui_test("isVisible false when display = false", function() {
        var n = __make_node();
        n.hide();
        assert_false(n.isVisible(), "not visible when display=false");
    });
    
    ui_test("isVisible false when visible = false", function() {
        var n = __make_node();
        n.visible = false;
        assert_false(n.isVisible(), "not visible when visible=false");
    });
    
    // ── traverse ─────────────────────────────────────────────
    
    ui_test("traverse calls callback on self and all descendants", function() {
        var root = __make_node();
        var mid  = __make_node();
        var leaf = __make_node();
        root.add(mid);
        mid.add(leaf);
        
        var state = { visited: [] };
        root.traverse(method(state, function(n) { array_push(visited, n); }));
        assert_equal(array_length(state.visited), 3, "3 nodes visited");
        assert_equal(state.visited[0], root, "root visited first");
        assert_equal(state.visited[1], mid,  "mid visited second");
        assert_equal(state.visited[2], leaf, "leaf visited third");
    });
    
    ui_test("traverseChildren skips self", function() {
        var root = __make_node();
        var c1   = __make_node();
        root.add(c1);
        
        var state = { visited: [] };
        root.traverseChildren(method(state, function(n) { array_push(visited, n); }));
        assert_equal(array_length(state.visited), 1, "1 child visited");
        assert_equal(state.visited[0], c1, "child visited");
    });
    
    ui_test("traverseChildren with recursive=false visits only direct children", function() {
        var root = __make_node();
        var mid  = __make_node();
        var leaf = __make_node();
        root.add(mid);
        mid.add(leaf);
        
        var state = { visited: [] };
        root.traverseChildren(method(state, function(n) { array_push(visited, n); }), false);
        assert_equal(array_length(state.visited), 1, "only 1 direct child visited");
        assert_equal(state.visited[0], mid, "mid visited");
    });
    
    ui_test("reduceChildren accumulates value", function() {
        var root = __make_node();
        var c1 = __make_node();
        var c2 = __make_node();
        root.add(c1, c2);
        
        var count = root.reduceChildren(function(acc, child, i) {
            return acc + 1;
        }, 0, false);
        assert_equal(count, 2, "reduced to 2");
    });
    
    // ── Event listeners ──────────────────────────────────────
    
    ui_test("addEventListener bubble - callback stored", function() {
        var n = __make_node();
        var cb = function() {};
        n.addEventListener(UI_EVENT.click, cb);
        var listeners = n.eventListeners[$ UI_EVENT.click];
        assert_not_undefined(listeners, "listeners struct exists");
        assert_equal(array_length(listeners.bubble), 1, "1 bubble listener");
    });
    
    ui_test("addEventListener capture - callback stored in capture array", function() {
        var n = __make_node();
        var cb = function() {};
        n.addEventListener(UI_EVENT.click, cb, true);
        var listeners = n.eventListeners[$ UI_EVENT.click];
        assert_equal(array_length(listeners.capture), 1, "1 capture listener");
    });
    
    ui_test("removeEventListener removes specific callback", function() {
        var n = __make_node();
        var cb = function() { return false; };
        n.addEventListener(UI_EVENT.click, cb);
        n.removeEventListener(UI_EVENT.click, cb);
        var listeners = n.eventListeners[$ UI_EVENT.click];
        assert_equal(array_length(listeners.bubble), 0, "0 bubble listeners after remove");
    });
    
    ui_test("clearEventListeners removes all listeners for event type", function() {
        var n = __make_node();
        n.addEventListener(UI_EVENT.click, function() {});
        n.addEventListener(UI_EVENT.click, function() {});
        n.clearEventListeners(UI_EVENT.click);
        assert_is_undefined(n.eventListeners[$ UI_EVENT.click], "listeners cleared");
    });
    
    ui_test("onClick shorthand registers click listener", function() {
        var n   = __make_node();
        var state = { hit: false };
        n.onClick(method(state, function() { hit = true; }));
        assert_equal(array_length(n.eventListeners[$ UI_EVENT.click].bubble), 1, "click listener registered");
    });
    
    ui_test("click() programmatically dispatches click event on self", function() {
        var parent = __make_node();
        var child  = __make_node();
        parent.add(child);
        
        var state = { hit: false };
        child.onClick(method(state, function() { hit = true; }));
        child.click();
        assert_true(state.hit, "click event dispatched programmatically");
    });
    
    // ── dispatchEvent bubble/capture ────────────────────────
    
    ui_test("dispatchEvent bubbles from child to parent", function() {
        var parent = __make_node();
        var child  = __make_node();
        parent.add(child);
        
        var state = { order: [] };
        parent.addEventListener(UI_EVENT.click, method(state, function(t) { array_push(order, "parent"); return false; }));
        child.addEventListener(UI_EVENT.click,  method(state, function(t) { array_push(order, "child");  return false; }));
        
        child.click(); // dispatches click on child
        assert_equal(state.order[0], "child",  "child fires first (target phase)");
        assert_equal(state.order[1], "parent", "parent fires second (bubble phase)");
    });
    
    ui_test("dispatchEvent stopPropagation (return true) stops bubble", function() {
        var parent = __make_node();
        var child  = __make_node();
        parent.add(child);
        
        var parent_hit = false;
        parent.addEventListener(UI_EVENT.click, function() { parent_hit = true; return false; });
        child.addEventListener(UI_EVENT.click,  function() { return true; }); // stop!
        
        child.click();
        assert_false(parent_hit, "parent not hit after stop propagation");
    });
    
    // ── destroy / destroyChildren ────────────────────────────
    
    ui_test("destroyChildren marks children as destroyed", function() {
        var parent = __make_node();
        var c1 = __make_node();
        var c2 = __make_node();
        parent.add(c1, c2);
        parent.destroyChildren();
        assert_true(c1.destroyed, "c1 destroyed");
        assert_true(c2.destroyed, "c2 destroyed");
        assert_equal(parent.childrenLength, 0, "parent has no children");
        assert_false(parent.destroyed, "parent itself not destroyed");
    });
    
    // ── Margin / Padding getters ─────────────────────────────
    
    ui_test("setMarginTop / getMarginTop round-trip", function() {
        var n = __make_node();
        n.setMarginTop(15);
        assert_equal(n.getMarginTop(), 15, "margin top");
    });
    
    ui_test("setMarginLeft / getMarginLeft round-trip", function() {
        var n = __make_node();
        n.setMarginLeft(20);
        assert_equal(n.getMarginLeft(), 20, "margin left");
    });
    
    ui_test("setMarginRight / getMarginRight round-trip", function() {
        var n = __make_node();
        n.setMarginRight(8);
        assert_equal(n.getMarginRight(), 8, "margin right");
    });
    
    ui_test("setMarginBottom / getMarginBottom round-trip", function() {
        var n = __make_node();
        n.setMarginBottom(3);
        assert_equal(n.getMarginBottom(), 3, "margin bottom");
    });
    
    ui_test("setPaddingTop / getPaddingTop round-trip", function() {
        var n = __make_node();
        n.setPaddingTop(10);
        assert_equal(n.getPaddingTop(), 10, "padding top");
    });
    
    ui_test("setPaddingLeft / getPaddingLeft round-trip", function() {
        var n = __make_node();
        n.setPaddingLeft(5);
        assert_equal(n.getPaddingLeft(), 5, "padding left");
    });
    
    // ── Focus (unit, no global.UI dependency) ────────────────
    
    ui_test("hasFocus returns false before focus() called", function() {
        var n = __make_node();
        // Patch global.UI.focusedElement to isolate test
        var _prev = global.UI.focusedElement;
        global.UI.focusedElement = undefined;
        assert_false(n.hasFocus(), "not focused initially");
        global.UI.focusedElement = _prev;
    });
    
    ui_test("getFocused returns the focused element", function() {
        var n = __make_node();
        var _prev = global.UI.focusedElement;
        global.UI.focusedElement = n;
        assert_equal(n.getFocused(), n, "getFocused returns self");
        global.UI.focusedElement = _prev;
    });
    
});
