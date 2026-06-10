// ============================================================
//  UiStore Tests (Reactive State Management)
// ============================================================

ui_test_suite("UiStore", function() {

    // ─── Constructor & Getters ───────────────────────────────

    ui_test("constructor stores initial state", function() {
        var store = new UiStore({ username: "Manuel", theme: "dark" });
        assert_equal(store.get("username"), "Manuel");
        assert_equal(store.get("theme"), "dark");
        store.destroy();
    });

    ui_test("constructor with empty initial state", function() {
        var store = new UiStore();
        assert_is_undefined(store.get("nonexistent"));
        store.destroy();
    });

    ui_test("get() returns default value for missing key", function() {
        var store = new UiStore({ a: 1 });
        assert_equal(store.get("b", 42), 42);
        store.destroy();
    });

    ui_test("get() returns undefined for missing key without default", function() {
        var store = new UiStore({ a: 1 });
        assert_is_undefined(store.get("b"));
        store.destroy();
    });

    ui_test("getState() returns full state", function() {
        var store = new UiStore({ x: 10, y: 20 });
        var state = store.state;
        assert_equal(state[$ "x"], 10);
        assert_equal(state[$ "y"], 20);
        store.destroy();
    });

    ui_test("getState() returns current state after setState", function() {
        var store = new UiStore({ val: 1 });
        var state = store.state;
        assert_equal(state[$ "val"], 1);
        store.set({ val: 99 });
        assert_equal(store.get("val"), 99);
        store.destroy();
    });

    ui_test("has() returns true for existing keys", function() {
        var store = new UiStore({ a: 1 });
        assert_true(store.has("a"));
        store.destroy();
    });

    ui_test("has() returns false for missing keys", function() {
        var store = new UiStore({ a: 1 });
        assert_false(store.has("b"));
        store.destroy();
    });

    // ─── setState (partial merge) ────────────────────────────

    ui_test("setState merges partial state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.set({ b: 3, c: 4 });
        assert_equal(store.get("a"), 1);
        assert_equal(store.get("b"), 3);
        assert_equal(store.get("c"), 4);
        store.destroy();
    });

    ui_test("setState with replace=true replaces entire state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.set({ c: 3 }, true);
        assert_false(store.has("a"));
        assert_false(store.has("b"));
        assert_equal(store.get("c"), 3);
        store.destroy();
    });

    // ─── remove ──────────────────────────────────────────────

    ui_test("remove deletes key from state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.remove("a");
        assert_false(store.has("a"));
        assert_true(store.has("b"));
        store.destroy();
    });

    ui_test("remove on missing key does nothing", function() {
        var store = new UiStore({ a: 1 });
        store.remove("b");
        assert_equal(store.get("a"), 1);
        store.destroy();
    });

    ui_test("remove notifies subscribers", function() {
        var store = new UiStore({ a: 1, b: 2 });
        var tracker = { called: 0 };
        store.subscribe(method(tracker, function(state) { self.called++; }));
        store.remove("a");
        assert_equal(tracker.called, 1);
        store.destroy();
    });

    // ─── reset ───────────────────────────────────────────────

    ui_test("reset restores initial state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.set({ a: 99, c: 3 });
        store.reset();
        assert_equal(store.get("a"), 1);
        assert_equal(store.get("b"), 2);
        assert_false(store.has("c"));
        store.destroy();
    });

    ui_test("reset notifies subscribers", function() {
        var store = new UiStore({ a: 1 });
        var tracker = { called: 0 };
        store.subscribe(method(tracker, function(state) { self.called++; }));
        store.reset();
        assert_true(tracker.called > 0);
        store.destroy();
    });

    // ─── subscribe ───────────────────────────────────────────

    ui_test("subscribe triggers callback on setState", function() {
        var store = new UiStore({ count: 10 });
        var tracker = { received: undefined };
        store.subscribe(method(tracker, function(state) { self.received = state.count; }));
        store.set({ count: 20 });
        assert_equal(tracker.received, 20);
        store.destroy();
    });

    ui_test("unsubscribe removes subscriber", function() {
        var store = new UiStore({ val: 1 });
        var tracker = { calls: 0 };
        var unsub = store.subscribe(method(tracker, function(state) { self.calls++; }));
        unsub();
        store.set({ val: 2 });
        assert_equal(tracker.calls, 0);
        store.destroy();
    });

    ui_test("multiple subscribers all receive updates", function() {
        var store = new UiStore({ val: "A" });
        var trackerA = { hits: 0 };
        var trackerB = { hits: 0 };
        store.subscribe(method(trackerA, function(state) { self.hits++; }));
        store.subscribe(method(trackerB, function(state) { self.hits++; }));
        store.set({ val: "B" });
        assert_equal(trackerA.hits, 1);
        assert_equal(trackerB.hits, 1);
        store.destroy();
    });

    ui_test("subscriber can unsubscribe during callback without breaking iteration", function() {
        var store = new UiStore({ val: 1 });
        var ctx = {
            store: store,
            unsub: undefined,
            calls: []
        };
        ctx.unsub = store.subscribe(method(ctx, function(state) {
            array_push(self.calls, "first");
            self.unsub();
        }));
        store.subscribe(method(ctx, function(state) { array_push(self.calls, "second"); }));
        store.set({ val: 2 });
        assert_equal(array_length(ctx.calls), 2);
        store.set({ val: 3 });
        assert_equal(array_length(ctx.calls), 3);
        store.destroy();
    });

    // ─── Middleware ──────────────────────────────────────────

    ui_test("middleware can transform state", function() {
        var store = new UiStore({ count: 0 });
        store.use(function(newState, store) {
            var _c = {};
            var _keys = variable_struct_get_names(newState);
            for (var i = 0; i < array_length(_keys); i++) {
                _c[$ _keys[i]] = newState[$ _keys[i]];
            }
            _c[$ "count"] = _c[$ "count"] * 2;
            return _c;
        });
        store.set({ count: 5 });
        assert_equal(store.get("count"), 10);
        store.destroy();
    });

    ui_test("multiple middleware execute in order", function() {
        var store = new UiStore({ val: "" });
        store.use(function(ns, s) {
            var _keys = variable_struct_get_names(ns);
            var _c = {};
            for (var i = 0; i < array_length(_keys); i++) {
                _c[$ _keys[i]] = ns[$ _keys[i]];
            }
            _c[$ "val"] = _c[$ "val"] + "1";
            return _c;
        });
        store.use(function(ns, s) {
            var _keys = variable_struct_get_names(ns);
            var _c = {};
            for (var i = 0; i < array_length(_keys); i++) {
                _c[$ _keys[i]] = ns[$ _keys[i]];
            }
            _c[$ "val"] = _c[$ "val"] + "2";
            return _c;
        });
        store.set({ val: "0" });
        assert_equal(store.get("val"), "012");
        store.destroy();
    });

    // ─── Chaining ────────────────────────────────────────────

    ui_test("setState returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.set({ b: 2 });
        assert_equal(result, store);
        store.destroy();
    });

    ui_test("remove returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.remove("a");
        assert_equal(result, store);
        store.destroy();
    });

    ui_test("reset returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.reset();
        assert_equal(result, store);
        store.destroy();
    });

    ui_test("use returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.use(function() { return undefined; });
        assert_equal(result, store);
        store.destroy();
    });

    // ─── destroy ─────────────────────────────────────────────

    ui_test("destroy clears all subscribers and middleware", function() {
        var store = new UiStore({ val: 1 });
        var tracker = { calls: 0 };
        store.subscribe(method(tracker, function(state) { self.calls++; }));
        store.use(function(ns, s) { return undefined; });
        store.destroy();
        store.set({ val: 2 });
        assert_true(true, "destroy did not cause errors");
    });

});
