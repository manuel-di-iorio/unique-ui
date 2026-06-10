// ============================================================
//  UiStore Tests
// ============================================================

ui_test_suite("UiStore", function() {
    
    ui_test("Create with initial state - state is set", function() {
        var store = new UiStore({ count: 0, name: "test" });
        assert_equal(store.state.count, 0, "count = 0");
        assert_equal(store.state.name, "test", "name = test");
    });
    
    ui_test("Create with empty state - state is empty struct", function() {
        var store = new UiStore({});
        assert_equal(variable_struct_get_names(store.state), [], "state is empty");
    });
    
    ui_test("getState returns state struct", function() {
        var store = new UiStore({ count: 5 });
        var state = store.getState();
        assert_equal(state.count, 5, "count = 5");
    });
    
    ui_test("setState with partial state - merges correctly", function() {
        var store = new UiStore({ count: 0, name: "test" });
        store.setState({ count: 10 });
        assert_equal(store.state.count, 10, "count updated");
        assert_equal(store.state.name, "test", "name unchanged");
    });
    
    ui_test("setState with replace mode - replaces entire state", function() {
        var store = new UiStore({ count: 0, name: "test" });
        store.setState({ newKey: "value" }, true);
        assert_is_undefined(store.state.count, "count removed");
        assert_is_undefined(store.state.name, "name removed");
        assert_equal(store.state.newKey, "value", "newKey added");
    });
    
    ui_test("setState with updater function - merges result", function() {
        var store = new UiStore({ count: 0, name: "test" });
        store.setState(function(state) {
            return { count: state.count + 1 };
        });
        assert_equal(store.state.count, 1, "count incremented");
        assert_equal(store.state.name, "test", "name unchanged");
    });
    
    ui_test("setState with updater and replace mode - replaces entire state", function() {
        var store = new UiStore({ count: 0, name: "test" });
        store.setState(function(state) {
            return { newCount: state.count + 1 };
        }, true);
        assert_is_undefined(store.state.count, "count removed");
        assert_is_undefined(store.state.name, "name removed");
        assert_equal(store.state.newCount, 1, "newCount added");
    });
    
    ui_test("get returns value for existing key", function() {
        var store = new UiStore({ count: 5 });
        assert_equal(store.get("count"), 5, "count = 5");
    });
    
    ui_test("get returns defaultValue for missing key", function() {
        var store = new UiStore({ count: 5 });
        assert_equal(store.get("missing", 42), 42, "defaultValue returned");
    });
    
    ui_test("has returns true for existing key", function() {
        var store = new UiStore({ count: 5 });
        assert_true(store.has("count"), "has count");
    });
    
    ui_test("has returns false for missing key", function() {
        var store = new UiStore({ count: 5 });
        assert_false(store.has("missing"), "does not have missing");
    });
    
    ui_test("remove removes key from state", function() {
        var store = new UiStore({ count: 5, name: "test" });
        store.remove("name");
        assert_false(store.has("name"), "name removed");
        assert_equal(store.state.count, 5, "count unchanged");
    });
    
    ui_test("remove returns self for chaining", function() {
        var store = new UiStore({ count: 5 });
        var result = store.remove("count");
        assert_equal(result, store, "returns self");
    });
    
    ui_test("reset restores initial state", function() {
        var store = new UiStore({ count: 0 });
        store.setState({ count: 10 });
        store.reset();
        assert_equal(store.state.count, 0, "count restored to 0");
    });
    
    ui_test("reset returns self for chaining", function() {
        var store = new UiStore({ count: 0 });
        var result = store.reset();
        assert_equal(result, store, "returns self");
    });
    
    ui_test("subscribe with selector - callback receives selected value", function() {
        var store = new UiStore({ count: 0 });
        var received = undefined;
        store.subscribe(function(state) { return state.count; }, function(val) {
            received = val;
        });
        store.setState({ count: 5 });
        assert_equal(received, 5, "callback received 5");
    });
    
    ui_test("subscribe - callback only fires when value changes", function() {
        var store = new UiStore({ count: 0 });
        var callCount = 0;
        store.subscribe(function(state) { return state.count; }, function(val) {
            callCount++;
        });
        store.setState({ count: 0 }); // Same value
        assert_equal(callCount, 0, "callback not fired for same value");
        store.setState({ count: 1 }); // Different value
        assert_equal(callCount, 1, "callback fired for different value");
    });
    
    ui_test("subscribe - unsubscribe function works", function() {
        var store = new UiStore({ count: 0 });
        var callCount = 0;
        var unsubscribe = store.subscribe(function(state) { return state.count; }, function(val) {
            callCount++;
        });
        unsubscribe();
        store.setState({ count: 5 });
        assert_equal(callCount, 0, "callback not fired after unsubscribe");
    });
    
    ui_test("use - adds middleware to chain", function() {
        var store = new UiStore({ count: 0 });
        var middlewareCalled = false;
        store.use(function(changedKeys, newState, store) {
            middlewareCalled = true;
            return undefined;
        });
        store.setState({ count: 5 });
        assert_true(middlewareCalled, "middleware called");
    });
    
    ui_test("use - middleware can interrupt update by returning false", function() {
        var store = new UiStore({ count: 0 });
        store.use(function(changedKeys, newState, store) {
            return false; // Interrupt
        });
        store.setState({ count: 5 });
        assert_equal(store.state.count, 0, "state unchanged");
    });
    
    ui_test("use - middleware can transform state", function() {
        var store = new UiStore({ count: 0 });
        store.use(function(changedKeys, newState, store) {
            newState.count = 999;
            return newState;
        });
        store.setState({ count: 5 });
        assert_equal(store.state.count, 999, "state transformed");
    });
    
    ui_test("use - middleware receives changedKeys", function() {
        var store = new UiStore({ count: 0, name: "test" });
        var receivedKeys = undefined;
        store.use(function(changedKeys, newState, store) {
            receivedKeys = changedKeys;
            return undefined;
        });
        store.setState({ count: 5 });
        assert_equal(array_length(receivedKeys), 1, "one key changed");
        assert_equal(receivedKeys[0], "count", "count key changed");
    });
    
    ui_test("use - multiple middleware chain in order", function() {
        var store = new UiStore({ count: 0 });
        var callOrder = [];
        store.use(function(changedKeys, newState, store) {
            array_push(callOrder, "first");
            return undefined;
        });
        store.use(function(changedKeys, newState, store) {
            array_push(callOrder, "second");
            return undefined;
        });
        store.setState({ count: 5 });
        assert_equal(callOrder[0], "first", "first middleware called");
        assert_equal(callOrder[1], "second", "second middleware called");
    });
    
    ui_test("use - returns self for chaining", function() {
        var store = new UiStore({ count: 0 });
        var result = store.use(function(changedKeys, newState, store) {
            return undefined;
        });
        assert_equal(result, store, "returns self");
    });
    
    ui_test("destroy - clears all listeners", function() {
        var store = new UiStore({ count: 0 });
        var callCount = 0;
        store.subscribe(function(state) { return state.count; }, function(val) {
            callCount++;
        });
        store.destroy();
        store.setState({ count: 5 });
        assert_equal(callCount, 0, "callback not fired after destroy");
    });
    
    ui_test("destroy - clears middleware", function() {
        var store = new UiStore({ count: 0 });
        store.use(function(changedKeys, newState, store) {
            return undefined;
        });
        store.destroy();
        assert_equal(array_length(store.__middleware), 0, "middleware cleared");
    });
    
});
