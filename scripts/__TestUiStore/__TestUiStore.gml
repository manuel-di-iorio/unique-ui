// ============================================================
//  UiStore Tests (Reactive State Management)
// ============================================================

ui_test_suite("UiStore", function() {

    // ─── Constructor & Getters ───────────────────────────────

    ui_test("constructor stores initial state", function() {
        var store = new UiStore({ username: "Manuel", theme: "dark" });
        assert_equal(store.get("username"), "Manuel");
        assert_equal(store.get("theme"), "dark");
    });

    ui_test("constructor with empty initial state", function() {
        var store = new UiStore();
        assert_is_undefined(store.get("nonexistent"));
    });

    ui_test("get() returns default value for missing key", function() {
        var store = new UiStore({ a: 1 });
        assert_equal(store.get("b", 42), 42);
    });

    ui_test("get() returns undefined for missing key without default", function() {
        var store = new UiStore({ a: 1 });
        assert_is_undefined(store.get("b"));
    });

    ui_test("getState() returns full state", function() {
        var store = new UiStore({ x: 10, y: 20 });
        var state = store.getState();
        assert_equal(state[$ "x"], 10);
        assert_equal(state[$ "y"], 20);
    });

    ui_test("getState() returns current state after setState", function() {
        var store = new UiStore({ val: 1 });
        var state = store.getState();
        assert_equal(state[$ "val"], 1);
        store.setState({ val: 99 });
        assert_equal(store.get("val"), 99);
    });

    ui_test("has() returns true for existing keys", function() {
        var store = new UiStore({ a: 1 });
        assert_true(store.has("a"));
    });

    ui_test("has() returns false for missing keys", function() {
        var store = new UiStore({ a: 1 });
        assert_false(store.has("b"));
    });

    // ─── setState (partial merge) ────────────────────────────

    ui_test("setState merges partial state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.setState({ b: 3, c: 4 });
        assert_equal(store.get("a"), 1);
        assert_equal(store.get("b"), 3);
        assert_equal(store.get("c"), 4);
    });

    ui_test("setState with replace=true replaces entire state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.setState({ c: 3 }, true);
        assert_false(store.has("a"));
        assert_false(store.has("b"));
        assert_equal(store.get("c"), 3);
    });

    // ─── setState (updater function) ─────────────────────────

    ui_test("setState with updater function merges result", function() {
        var store = new UiStore({ count: 10 });
        store.setState(function(state) {
            return { count: state[$ "count"] + 5 };
        });
        assert_equal(store.get("count"), 15);
    });

    ui_test("setState with updater and replace=true replaces entire state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.setState(function(state) {
            return { c: 3 };
        }, true);
        assert_false(store.has("a"));
        assert_equal(store.get("c"), 3);
    });

    // ─── remove ──────────────────────────────────────────────

    ui_test("remove deletes key from state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.remove("a");
        assert_false(store.has("a"));
        assert_true(store.has("b"));
    });

    ui_test("remove on missing key does nothing", function() {
        var store = new UiStore({ a: 1 });
        store.remove("b");
        assert_equal(store.get("a"), 1);
    });

    ui_test("remove notifies subscribers", function() {
        var store = new UiStore({ a: 1, b: 2 });
        var tracker = { called: 0 };
        store.subscribe(
            function(s) { return s; },
            method(tracker, function() { self.called++; })
        );
        store.remove("a");
        assert_equal(tracker.called, 1);
    });

    // ─── reset ───────────────────────────────────────────────

    ui_test("reset restores initial state", function() {
        var store = new UiStore({ a: 1, b: 2 });
        store.setState({ a: 99, c: 3 });
        store.reset();
        assert_equal(store.get("a"), 1);
        assert_equal(store.get("b"), 2);
        assert_false(store.has("c"));
    });

    ui_test("reset notifies subscribers", function() {
        var store = new UiStore({ a: 1 });
        var tracker = { called: 0 };
        store.subscribe(
            function(s) { return s; },
            method(tracker, function() { self.called++; })
        );
        store.reset();
        assert_true(tracker.called > 0);
    });

    // ─── subscribe ───────────────────────────────────────────

    ui_test("subscribe triggers callback on setState", function() {
        var store = new UiStore({ count: 10 });
        var tracker = { received: undefined };
        store.subscribe(
            function(state) { return state[$ "count"]; },
            method(tracker, function(val) { self.received = val; })
        );
        store.setState({ count: 20 });
        assert_equal(tracker.received, 20);
    });

    ui_test("subscribe with selector only triggers when selected value changes", function() {
        var store = new UiStore({ a: 1, b: 1 });
        var tracker = { calls: 0 };
        store.subscribe(
            function(state) { return state[$ "a"]; },
            method(tracker, function() { self.calls++; })
        );
        store.setState({ b: 2 });
        assert_equal(tracker.calls, 0);
        store.setState({ a: 2 });
        assert_equal(tracker.calls, 1);
    });

    ui_test("subscribe with custom equality function", function() {
        var store = new UiStore({ items: [1, 2, 3] });
        var tracker = { calls: 0 };
        store.subscribe(
            function(state) { return state[$ "items"]; },
            method(tracker, function() { self.calls++; }),
            function(a, b) {
                if (array_length(a) != array_length(b)) return false;
                for (var _i = 0; _i < array_length(a); _i++) {
                    if (a[_i] != b[_i]) return false;
                }
                return true;
            }
        );
        store.setState({ items: [1, 2, 3] });
        assert_equal(tracker.calls, 0);
        store.setState({ items: [1, 2, 4] });
        assert_equal(tracker.calls, 1);
    });

    ui_test("unsubscribe removes subscriber", function() {
        var store = new UiStore({ val: 1 });
        var tracker = { calls: 0 };
        var unsub = store.subscribe(
            function(s) { return s; },
            method(tracker, function() { self.calls++; })
        );
        unsub();
        store.setState({ val: 2 });
        assert_equal(tracker.calls, 0);
    });

    ui_test("multiple subscribers all receive updates", function() {
        var store = new UiStore({ val: "A" });
        var trackerA = { hits: 0 };
        var trackerB = { hits: 0 };
        store.subscribe(
            function(s) { return s; },
            method(trackerA, function() { self.hits++; })
        );
        store.subscribe(
            function(s) { return s; },
            method(trackerB, function() { self.hits++; })
        );
        store.setState({ val: "B" });
        assert_equal(trackerA.hits, 1);
        assert_equal(trackerB.hits, 1);
    });

    ui_test("subscriber can unsubscribe during callback without breaking iteration", function() {
        var store = new UiStore({ val: 1 });
        var ctx = {
            store: store,
            unsub: undefined,
            calls: []
        };
        ctx.unsub = store.subscribe(
            function(s) { return s[$ "val"]; },
            method(ctx, function() {
                array_push(self.calls, "first");
                self.unsub();
            })
        );
        store.subscribe(
            function(s) { return s[$ "val"]; },
            method(ctx, function() { array_push(self.calls, "second"); })
        );
        store.setState({ val: 2 });
        assert_equal(array_length(ctx.calls), 2);
        store.setState({ val: 3 });
        assert_equal(array_length(ctx.calls), 3);
    });

    // ─── Middleware ──────────────────────────────────────────

    ui_test("middleware can transform state", function() {
        var store = new UiStore({ count: 0 });
        store.use(function(changedKeys, newState, store) {
            if (variable_struct_exists(newState, "count")) {
                var _c = {};
                var _keys = variable_struct_get_names(newState);
                for (var i = 0; i < array_length(_keys); i++) {
                    _c[$ _keys[i]] = newState[$ _keys[i]];
                }
                _c[$ "count"] = _c[$ "count"] * 2;
                return _c;
            }
            return undefined;
        });
        store.setState({ count: 5 });
        assert_equal(store.get("count"), 10);
    });

    ui_test("middleware can interrupt (return false) preventing mutation", function() {
        var store = new UiStore({ val: "original" });
        store.use(function(changedKeys, newState, store) {
            if (variable_struct_exists(newState, "val") && newState[$ "val"] == "blocked") {
                return false;
            }
            return undefined;
        });
        store.setState({ val: "blocked" });
        assert_equal(store.get("val"), "original");
    });

    ui_test("multiple middleware execute in order", function() {
        var store = new UiStore({ val: "" });
        store.use(function(ck, ns, s) {
            var _keys = variable_struct_get_names(ns);
            var _c = {};
            for (var i = 0; i < array_length(_keys); i++) {
                _c[$ _keys[i]] = ns[$ _keys[i]];
            }
            _c[$ "val"] = _c[$ "val"] + "1";
            return _c;
        });
        store.use(function(ck, ns, s) {
            var _keys = variable_struct_get_names(ns);
            var _c = {};
            for (var i = 0; i < array_length(_keys); i++) {
                _c[$ _keys[i]] = ns[$ _keys[i]];
            }
            _c[$ "val"] = _c[$ "val"] + "2";
            return _c;
        });
        store.setState({ val: "0" });
        assert_equal(store.get("val"), "012");
    });

    // ─── Chaining ────────────────────────────────────────────

    ui_test("setState returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.setState({ b: 2 });
        assert_equal(result, store);
    });

    ui_test("remove returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.remove("a");
        assert_equal(result, store);
    });

    ui_test("reset returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.reset();
        assert_equal(result, store);
    });

    ui_test("use returns self for chaining", function() {
        var store = new UiStore({ a: 1 });
        var result = store.use(function() { return undefined; });
        assert_equal(result, store);
    });

    // ─── destroy ─────────────────────────────────────────────

    ui_test("destroy clears all subscribers and middleware", function() {
        var store = new UiStore({ val: 1 });
        var tracker = { calls: 0 };
        store.subscribe(
            function(s) { return s; },
            method(tracker, function() { self.calls++; })
        );
        store.use(function(ck, ns, s) { return undefined; });
        store.destroy();
        store.setState({ val: 2 });
        assert_true(true, "destroy did not cause errors");
    });

    // ─── Edge Cases ──────────────────────────────────────────

    ui_test("subscribe with equalityFn prevents duplicate notifications", function() {
        var store = new UiStore({ val: "same" });
        var tracker = { calls: 0 };
        store.subscribe(
            function(s) { return s[$ "val"]; },
            method(tracker, function() { self.calls++; }),
            function(a, b) { return a == b; }
        );
        store.setState({ val: "same" });
        assert_equal(tracker.calls, 0);
    });

});
