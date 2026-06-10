---
sidebar_position: 1
---

# UiStore

Lightweight reactive state management for UniqueUI. `UiStore` lets you share state across components and react to changes with push-based subscriptions — no polling, no per-frame `valueGetter` evaluation unless you choose to use one for display binding.

`UiStore` is lib-agnostic and can be used outside of UniqueUI. For UniqueUI integration, use `subscribeChanged()` to connect to the redraw system.

## Performance Features

- **Selector-based subscriptions**: Subscribe to specific values with `subscribe(selector, callback)` - powerful and scalable
- **Update**: Unified `set()` method supports both partial state and updater functions
- **Snapshot/undo-redo**: Built-in undo/redo support for editor-style applications
- **Component-level binding**: Use `bind()` on components for reactive property updates
- **Automatic cleanup**: Store subscriptions are automatically cleaned up when nodes are destroyed
- **Lib-agnostic**: No direct dependency on UI framework - integrate via `subscribeChanged()`
- **Change detection**: Only notifies subscribers when values actually change (not on redundant sets)
- **UniqueUI batching**: UniqueUI batches redraws internally, so multiple state changes in a single frame result in only one redraw

## Usage

```gml
// 1. Create a store with initial state
global.settings = new UiStore({
    counter: 0,
    themeMode: "dark"
});

// 2. Integrate with UniqueUI (lib-agnostic)
global.settings.subscribeChanged(function(state) {
    global.UI.requestRedraw();
});

// 3. Subscribe to changes with selector
global.settings.subscribe(
    function(state) { return state.counter; },
    function(count) {
        show_debug_message("Counter: " + string(count));
    }
);

// 4. Update state with partial state
global.settings.set({ counter: 10, themeMode: "light" });

// OR update with function
global.settings.set(function(state) {
    return { counter: state.counter + 1 };
});

// 5. Bind component to store
var label = new UiText("", {}, {});
label.bind(global.settings, function(state) { return state.counter; }, "text", function(val) {
    return "Count: " + string(val);
});
```

## Constructor

`new UiStore(initialState)`

- `initialState` (Struct): Starting key/value pairs. A clone is kept internally for `reset()`.

## Methods

### `set(arg)`

Supports two signatures:
- `set(partialState)` - Merge partial state struct
- `set(updater)` - Function that receives state and returns partial state

```gml
// Partial state
store.set({ counter: 10, themeMode: "light" });

// Updater function
store.set(function(state) {
    return { counter: state.counter + 1 };
});

// Multiple updates in one call
store.set(function(state) {
    return {
        x: state.x + 10,
        y: state.y + 10,
        z: state.z + 10
    };
});
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

### `subscribeChanged(callback)`

Subscribe to general state changes (lib-agnostic). Use this to integrate with UI frameworks or other systems. The callback receives the full state.

Returns an unsubscribe function.

```gml
// Integrate with UniqueUI
var unsubscribe = store.subscribeChanged(function(state) {
    global.UI.requestRedraw();
});

// Or use for logging
store.subscribeChanged(function(state) {
    show_debug_message("State changed: " + json_stringify(state));
});
```

### `snapshot()`

Creates a snapshot of the current state for manual undo/redo.

```gml
var savedState = store.snapshot();
```

### `undo()`

Restores the previous state from the undo stack.

```gml
store.undo();
```

### `redo()`

Restores the next state from the redo stack.

```gml
store.redo();
```

### `enableUndoRedo()`

Enables automatic snapshot creation on every state change for undo/redo.

```gml
store.enableUndoRedo();
```

### `disableUndoRedo()`

Disables automatic snapshot creation.

```gml
store.disableUndoRedo();
```

### `setActions(actions)`

Define actions for state mutations. Actions provide a clean API for state changes and enable middleware/logging. Actions are automatically bound to the store, so you don't need to pass the store parameter.

```gml
store.setActions({
    increment: function() {
        self.set("counter", self.get("counter") + 1);
    },
    reset: function() {
        self.set("counter", 0);
    }
});

// Use actions
store.actions.increment();
store.actions.reset();
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


### Undo/Redo for editor applications

Enable automatic undo/redo for professional editor-style applications.

```gml
var editorStore = new UiStore({
    document: "",
    cursor: { x: 0, y: 0 }
});

editorStore.enableUndoRedo();

// Every state change is automatically saved
editorStore.set("document", "Hello World");

// Undo the last change
editorStore.undo();

// Redo the undone change
editorStore.redo();
```

## How Reactivity Works

1. You call `set()`, `setState()`, `update()`, `remove()`, or `reset()`.
2. Change detection: Only notifies if the value actually changed.
3. `__notify()` iterates registered selector-based subscribers:
   - Only notifies subscribers when their selected value actually changed
4. If `global.UI` exists, `requestRedraw()` is called so bound components repaint.

There is no automatic two-way binding — you wire reads (`get()` / `select()` / `subscribe`) and writes (`set()` / `onChange`) explicitly, which keeps data flow predictable in GML.
