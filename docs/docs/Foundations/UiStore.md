---
sidebar_position: 1
---

# UiStore

Simple push-based state management for GameMaker. Minimal, fast, no selectors - just set and notify.

`UiStore` is lib-agnostic and can be used outside of UniqueUI. It provides a clean API with optional middleware for advanced features like undo/redo, logging, and persistence.

## Performance Features

- **Direct mutation**: State is mutated directly instead of cloning - no `variable_clone()` bottleneck
- **Simple subscriptions**: Subscribe with a callback that receives the full state - no selectors, no equality checks
- **Middleware system**: Composable middleware for undo/redo, logging, validation, and more
- **Replace mode**: `set(partial, true)` for complete state replacement
- **Minimal API**: Core API is small and focused - advanced features via optional middleware

## Usage

```gml
// 1. Create a store with initial state
var store = new UiStore({
    counter: 0,
    themeMode: "dark"
});

// 2. Subscribe to changes (callback receives full state)
store.subscribe(function(state) {
    show_debug_message("Counter: " + string(state.counter));
});

// 3. Update state with partial state (merge)
store.set({ counter: 10, themeMode: "light" });

// OR replace entire state
store.set({ newKey: "value" }, true);

// 4. Add custom middleware
store.use(function(newState, store) {
    show_debug_message("State changed: " + string(newState));
    return undefined; // pass through
});
```

## Constructor

`new UiStore(initialState)`

- `initialState` (Struct): Starting key/value pairs. A clone is kept internally for `reset()`.

## Methods

### `set(partialState, replace = false)`

Merge a state struct, or replace the entire state when `replace` is `true`.

```gml
// Partial state (merge)
store.set({ counter: 10, themeMode: "light" });

// Replace entire state
store.set({ newKey: "value" }, true);
```

### `get(key, defaultValue?)`

Returns the value for `key`, or `defaultValue` if the key is not defined.

**WARNING**: `get()` and `.state` return live references to the state. Do not directly mutate arrays or structs obtained through these methods. Always use `set()` for modifications.

```gml
var count = store.get("counter", 0);
```

### `.state`

Returns the live `state` struct reference. Prefer `get()` for reads unless you need the full struct.

**WARNING**: Returns a live reference. Do not directly mutate arrays or structs obtained through this method. Always use `set()` for modifications.

```gml
// DON'T DO THIS - won't trigger reactivity
var items = store.get("items");
array_push(items, "new item"); // ❌ No notification

// DO THIS - will trigger reactivity
var newItems = array_copy(store.get("items"));
array_push(newItems, "new item");
store.set({ items: newItems }); // ✅ Notifies subscribers
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

### `subscribe(callback)`

Subscribe to state changes. The callback receives the full state on every change.

Returns an unsubscribe function.

```gml
var unsubscribe = store.subscribe(function(state) {
    show_debug_message("Counter: " + string(state.counter));
});

// Cleanup
unsubscribe();
```

### `use(middleware)`

Apply middleware to the store. Middleware receives `(newState, store)` and can:
- Return `undefined` to use newState as-is
- Return a new state to transform it

Returns `self` for chaining.

```gml
// Logger middleware
store.use(function(newState, store) {
    show_debug_message("New state: " + string(newState));
    return undefined;
});

// Transform middleware
store.use(function(newState, store) {
    newState.timestamp = current_time;
    return newState;
});
```

### `destroy()`

Destroy the store and cleanup all listeners. Use this when you're done with the store to prevent memory leaks.

```gml
store.destroy();
```

## How Reactivity Works

1. You call `set()`, `remove()`, or `reset()`.
2. State is mutated directly (no cloning for performance).
3. Middleware chain is applied - each middleware can transform the update.
4. `__notify()` iterates registered subscribers in reverse order and calls each callback with the full state.

There is no automatic two-way binding - you wire reads (`get()` / `state` / `subscribe`) and writes (`set()`) explicitly, which keeps data flow predictable in GML.

## Performance Notes

- **Direct mutation**: State is mutated directly instead of cloning - no `variable_clone()` bottleneck. This is especially important for per-frame updates (mouseX, mouseY, scroll, hovered, focused).
- **Simple callbacks**: Every subscriber receives the full state on each change. Keep callbacks lightweight for best performance.
- **Middleware is optional**: Core API is minimal and fast. Add middleware only when you need advanced features like undo/redo, logging, or persistence.
