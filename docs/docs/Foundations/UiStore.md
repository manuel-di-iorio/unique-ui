---
sidebar_position: 1
---

# UiStore

Zustand-inspired state management for GameMaker. Minimal, fast, selector-based subscriptions.

`UiStore` is lib-agnostic and can be used outside of UniqueUI. It provides a clean API inspired by Zustand with optional middleware for advanced features like undo/redo, logging, and persistence.

## Performance Features

- **Selector-based subscriptions**: Subscribe to specific values with `subscribe(selector, callback)` - only notified when selected value changes
- **No deep clone on updates**: Changed keys tracking instead of full state cloning for O(k) performance where k = changed keys
- **Middleware system**: Composable middleware for undo/redo, logging, validation, and more
- **Replace mode**: `setState(partial, true)` for complete state replacement
- **Change detection**: Only notifies subscribers when values actually change
- **Minimal API**: Core API is small and focused - advanced features via optional middleware

## Usage

```gml
// 1. Create a store with initial state
var store = new UiStore({
    counter: 0,
    themeMode: "dark"
});

// 2. Subscribe to changes with selector
store.subscribe(
    function(state) { return state.counter; },
    function(count) {
        show_debug_message("Counter: " + string(count));
    }
);

// 3. Update state with partial state (merge)
store.setState({ counter: 10, themeMode: "light" });

// OR update with function
store.setState(function(state) {
    return { counter: state.counter + 1 };
});

// OR replace entire state
store.setState({ newKey: "value" }, true);

// 4. Add optional middleware
store.use(function(changedKeys, newState, store) {
    show_debug_message("Keys changed: " + string(changedKeys));
    return undefined; // pass through
});
```

## Constructor

`new UiStore(initialState)`

- `initialState` (Struct): Starting key/value pairs. A clone is kept internally for `reset()`.

## Methods

### `setState(arg, replace = false)`

Supports four signatures:
- `setState(partialState)` - Merge partial state struct
- `setState(partialState, true)` - Replace entire state
- `setState(updater)` - Function that receives state and returns partial state
- `setState(updater, true)` - Function that receives state and replaces entire state

```gml
// Partial state (merge)
store.setState({ counter: 10, themeMode: "light" });

// Replace entire state
store.setState({ newKey: "value" }, true);

// Updater function (merge)
store.setState(function(state) {
    return { counter: state.counter + 1 };
});

// Updater function (replace)
store.setState(function(state) {
    return { newCount: state.counter + 1 };
}, true);
```

### `get(key, defaultValue?)`

Returns the value for `key`, or `defaultValue` if the key is not defined.

**WARNING**: `get()` and `getState()` return live references to the state. Do not directly mutate arrays or structs obtained through these methods. Always use `set()` for modifications.

```gml
var count = store.get("counter", 0);
```

### `getState()`

Returns the live `state` struct reference. Prefer `get()` for reads unless you need the full struct.

**WARNING**: Returns a live reference. Do not directly mutate arrays or structs obtained through this method. Always use `set()` for modifications.

```gml
// DON'T DO THIS - won't trigger reactivity
var items = store.get("items");
array_push(items, "new item"); // ❌ No notification

// DO THIS - will trigger reactivity
store.set(function(state) {
    var newItems = array_copy(state.items);
    array_push(newItems, "new item");
    return { items: newItems }; // ✅ Notifies subscribers
});
```

### `has(key)`

Returns `true` if the key exists in state.

```gml
if (store.has("notifications")) { … }
```

### `remove(key)`

Removes a key from state and notifies subscribers. Returns `self` for chaining.

```gml
store.remove("tempFlag");
```

### `reset()`

Restores state to the initial snapshot passed to the constructor and notifies subscribers. Returns `self`.

```gml
store.reset();
```

### `subscribe(selector, callback)`

Subscribe to state changes using a selector function. Only notified when the selected value changes.

Returns an unsubscribe function.

```gml
var unsubscribe = store.subscribe(
    function(state) { return state.counter; },
    function(count) {
        show_debug_message("Counter: " + string(count));
    }
);

// Cleanup
unsubscribe();
```

### `use(middleware)`

Apply middleware to the store. Middleware receives `(changedKeys, newState, store)` and can:
- Return `undefined` to use newState as-is
- Return a new state to transform it
- Return `false` to interrupt the update

Returns `self` for chaining.

```gml
// Logger middleware
store.use(function(changedKeys, newState, store) {
    show_debug_message("Changed keys: " + string(changedKeys));
    show_debug_message("New state: " + string(newState));
    return undefined;
});

// Validation middleware
store.use(function(changedKeys, newState, store) {
    if (newState.count < 0) {
        return false; // Interrupt update
    }
    return undefined;
});

// Transform middleware
store.use(function(changedKeys, newState, store) {
    newState.timestamp = current_time;
    return newState;
});
```

### `destroy()`

Destroy the store and cleanup all listeners. Use this when you're done with the store to prevent memory leaks.

```gml
store.destroy();
```

## Performance Patterns

### Selector-based subscriptions (recommended)

Use selector-based `subscribe()` when you only care about specific values. This prevents unnecessary callback executions and scales to nested state.

```gml
var store = new UiStore({ 
    user: { name: "Test", age: 25 },
    count: 0 
});

// Only notified when user.name changes
store.subscribe(
    function(state) { return state.user.name; },
    function(name) {
        show_debug_message("Name changed to " + name);
    }
);

// Only notified when count changes
store.subscribe(
    function(state) { return state.count; },
    function(count) {
        show_debug_message("Count changed to " + string(count));
    }
);
```

### Component-level reactive binding

Use `bind()` on components for clean reactive property updates.

```gml
var label = new UiText("", {}, {});
label.bind(store, function(state) { return state.counter; }, "text", function(val) {
    return "Count: " + string(val);
});
```

### Mutations

Use `set()` with an updater function for cleaner state mutations when updating multiple related values.

```gml
store.set(function(state) {
    return {
        x: state.x + 10,
        y: state.y + 10,
        z: state.z + 10
    };
});
```


### Undo/Redo with middleware

Undo/redo is now optional via middleware instead of built-in.

```gml
var editorStore = new UiStore({
    document: "",
    cursor: { x: 0, y: 0 }
});

// Add undo/redo middleware
editorStore.use(UiStoreMiddleware_undoRedo());

// Every state change is automatically saved
editorStore.setState({ document: "Hello World" });

// Undo the last change
editorStore.undo();

// Redo the undone change
editorStore.redo();
```

## How Reactivity Works

1. You call `setState()`, `remove()`, or `reset()`.
2. Changed keys are tracked (no deep clone of prevState for performance).
3. Middleware chain is applied - each middleware can transform or interrupt the update.
4. `__notify()` iterates registered selector-based subscribers:
   - Only notifies subscribers when their selected value actually changed

There is no automatic two-way binding — you wire reads (`get()` / `getState()` / `subscribe`) and writes (`setState()`) explicitly, which keeps data flow predictable in GML.

## Performance Notes

- **No deep clone on updates**: Changed keys are tracked instead of cloning the entire previous state. This makes updates O(k) where k is the number of changed keys, not O(n) where n is the total state size.
- **Selector-based subscriptions**: Only subscribers whose selected value changed are notified, preventing unnecessary callback executions.
- **Middleware is optional**: Core API is minimal and fast. Add middleware only when you need advanced features like undo/redo, logging, or persistence.
