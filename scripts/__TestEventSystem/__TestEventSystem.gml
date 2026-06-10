// ============================================================
//  Event System Tests (DOM-like capture/bubble)
// ============================================================

ui_test_suite("EventSystem", function() {
    
    function __node() { return new UiNode({}, {}); }
    
    ui_test("Bubble: event fires on target then propagates to parent", function() {
        var parent = __node();
        var child  = __node();
        parent.add(child);
        
        var state = { fired: [] };
        child.addEventListener(UI_EVENT.mousedown,  method(state, function(t) { array_push(fired, "child");  return false; }));
        parent.addEventListener(UI_EVENT.mousedown, method(state, function(t) { array_push(fired, "parent"); return false; }));
        
        child.dispatchEvent(UI_EVENT.mousedown, child);
        assert_equal(array_length(state.fired), 2, "both fired");
        assert_equal(state.fired[0], "child",  "child before parent");
        assert_equal(state.fired[1], "parent", "parent after child");
    });
    
    ui_test("Capture: capture listener fires before target", function() {
        var parent = __node();
        var child  = __node();
        parent.add(child);
        
        var state = { fired: [] };
        parent.addEventListener(UI_EVENT.click, method(state, function(t) { array_push(fired, "parent-capture"); return false; }), true);
        child.addEventListener(UI_EVENT.click,  method(state, function(t) { array_push(fired, "child-bubble");   return false; }));
        
        child.dispatchEvent(UI_EVENT.click, child);
        assert_equal(state.fired[0], "parent-capture", "capture fires first");
        assert_equal(state.fired[1], "child-bubble",   "bubble fires second");
    });
    
    ui_test("stopPropagation on child stops bubble to parent", function() {
        var parent = __node();
        var child  = __node();
        parent.add(child);
        
        var state = { parent_hit: false };
        child.addEventListener(UI_EVENT.click,  function(t) { return true; }); // stop
        parent.addEventListener(UI_EVENT.click, method(state, function(t) { parent_hit = true; return false; }));
        
        child.dispatchEvent(UI_EVENT.click, child);
        assert_false(state.parent_hit, "parent not reached after stop");
    });
    
    ui_test("stopPropagation on capture stops target and bubble", function() {
        var parent = __node();
        var child  = __node();
        parent.add(child);
        
        var state = { child_hit: false };
        parent.addEventListener(UI_EVENT.click, function(t) { return true; }, true); // stop in capture
        child.addEventListener(UI_EVENT.click,  method(state, function(t) { child_hit = true; return false; }));
        
        child.dispatchEvent(UI_EVENT.click, child);
        assert_false(state.child_hit, "child not reached when capture stopped");
    });
    
    ui_test("mouseenter and mouseleave do NOT bubble", function() {
        var parent = __node();
        var child  = __node();
        parent.add(child);
        
        var state = { parent_enter: false };
        parent.addEventListener(UI_EVENT.mouseenter, method(state, function(t) { parent_enter = true; return false; }));
        
        child.dispatchEvent(UI_EVENT.mouseenter, child);
        assert_false(state.parent_enter, "mouseenter does not bubble to parent");
    });
    
    ui_test("mouseleave does NOT bubble", function() {
        var parent = __node();
        var child  = __node();
        parent.add(child);
        
        var state = { parent_leave: false };
        parent.addEventListener(UI_EVENT.mouseleave, method(state, function(t) { parent_leave = true; return false; }));
        
        child.dispatchEvent(UI_EVENT.mouseleave, child);
        assert_false(state.parent_leave, "mouseleave does not bubble to parent");
    });
    
    ui_test("Multiple listeners on same event - all called in order", function() {
        var n = __node();
        var state = { order: [] };
        n.addEventListener(UI_EVENT.click, method(state, function(t) { array_push(order, 1); return false; }));
        n.addEventListener(UI_EVENT.click, method(state, function(t) { array_push(order, 2); return false; }));
        n.addEventListener(UI_EVENT.click, method(state, function(t) { array_push(order, 3); return false; }));
        
        n.dispatchEvent(UI_EVENT.click, n);
        assert_equal(array_length(state.order), 3, "all 3 fired");
        assert_equal(state.order[0], 1, "first");
        assert_equal(state.order[1], 2, "second");
        assert_equal(state.order[2], 3, "third");
    });
    
    ui_test("Deep hierarchy - bubble traverses all ancestors", function() {
        var root  = __node();
        var mid   = __node();
        var child = __node();
        root.add(mid);
        mid.add(child);
        
        var state = { hits: [] };
        root.addEventListener(UI_EVENT.click,  method(state, function(t) { array_push(hits, "root");  return false; }));
        mid.addEventListener(UI_EVENT.click,   method(state, function(t) { array_push(hits, "mid");   return false; }));
        child.addEventListener(UI_EVENT.click, method(state, function(t) { array_push(hits, "child"); return false; }));
        
        child.dispatchEvent(UI_EVENT.click, child);
        assert_equal(array_length(state.hits), 3, "3 nodes hit");
        assert_equal(state.hits[0], "child", "child first");
        assert_equal(state.hits[1], "mid",   "mid second");
        assert_equal(state.hits[2], "root",  "root third");
    });
    
    ui_test("onMouseDown shorthand registers mousedown listener", function() {
        var n = __node();
        var state = { hit: false };
        n.onMouseDown(method(state, function() { hit = true; return false; }));
        n.dispatchEvent(UI_EVENT.mousedown, n);
        assert_true(state.hit, "mousedown fired");
    });
    
    ui_test("onMouseEnter shorthand registers mouseenter listener", function() {
        var n = __node();
        var state = { hit: false };
        n.onMouseEnter(method(state, function() { hit = true; return false; }));
        n.dispatchEvent(UI_EVENT.mouseenter, n);
        assert_true(state.hit, "mouseenter fired");
    });
    
    ui_test("onWheelUp / onWheelDown register wheel listeners", function() {
        var n = __node();
        var state = { up_hit: false, dn_hit: false };
        n.onWheelUp(method(state,   function() { up_hit = true; return false; }));
        n.onWheelDown(method(state, function() { dn_hit = true; return false; }));
        n.dispatchEvent(UI_EVENT.wheelup,   n);
        n.dispatchEvent(UI_EVENT.wheeldown, n);
        assert_true(state.up_hit, "wheelup fired");
        assert_true(state.dn_hit, "wheeldown fired");
    });
    
    ui_test("onDoubleClick registers doubleclick listener", function() {
        var n = __node();
        var state = { hit: false };
        n.onDoubleClick(method(state, function() { hit = true; return false; }));
        n.dispatchEvent(UI_EVENT.doubleclick, n);
        assert_true(state.hit, "doubleclick fired");
    });
    
});

// ============================================================
//  UiStore Tests (Reactive State Management)
// ============================================================

ui_test_suite("UiStore", function() {
    
    ui_test("UiStore stores initial state from constructor", function() {
        var store = new UiStore({ username: "Manuel", theme: "dark" });
        assert_equal(store.get("username"), "Manuel", "get username");
        assert_equal(store.get("theme"), "dark", "get theme");
    });
    
    ui_test("UiStore get method supports default values", function() {
        var store = new UiStore();
        assert_is_undefined(store.get("nonexistent"), "returns undefined by default");
        assert_equal(store.get("nonexistent", "fallback"), "fallback", "returns default value");
    });
    
    ui_test("UiStore setState method updates state values", function() {
        var store = new UiStore({ count: 0 });
        store.setState({ count: 42 });
        assert_equal(store.get("count"), 42, "updates state key");
    });
    
    ui_test("UiStore subscribe triggers callback on setState", function() {
        var store = new UiStore({ count: 10 });
        var testState = { triggeredCount: 0, receivedState: undefined };
        
        var callback = method(testState, function(newState) {
            self.triggeredCount++;
            self.receivedState = newState;
        });
        
        store.subscribe(function(state) { return state; }, callback);
        store.setState({ count: 20 });
        
        assert_equal(testState.triggeredCount, 1, "subscriber was called once");
        assert_not_undefined(testState.receivedState, "received new state");
        assert_equal(testState.receivedState[$ "count"], 20, "received correct state value");
    });
    
    ui_test("UiStore supports multiple subscribers", function() {
        var store = new UiStore({ val: "A" });
        var tracker = { hits: 0 };
        
        var cb = method(tracker, function(s) { hits++; });
        store.subscribe(function(state) { return state; }, cb);
        store.subscribe(function(state) { return state; }, cb);
        
        store.setState({ val: "B" });
        assert_equal(tracker.hits, 2, "both subscribers called");
    });
    
});
