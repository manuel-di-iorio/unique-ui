---
sidebar_position: 1
---

# UiStore

Lightweight reactive state management for UniqueUI. `UiStore` lets you share state across components and react to changes with push-based subscriptions — no polling, no per-frame `valueGetter` evaluation unless you choose to use one for display binding.

When state changes, all subscribers fire immediately and `global.UI.requestRedraw()` is called automatically.

## Usage

```gml
// 1. Create a store with initial state
global.settings = new UiStore({
    counter: 0,
    themeMode: "dark"
});

// 2. Subscribe to changes
global.settings.subscribe(function(state) {
    show_debug_message("Counter: " + string(state.counter));
});

// 3. Update state reactively
global.settings.set("counter", global.settings.get("counter") + 1);
```

## Constructor

`new UiStore(initialState)`

- `initialState` (Struct): Starting key/value pairs. A clone is kept internally for `reset()`.

## Methods

### `set(key, value)`

Updates a single state key and notifies all subscribers.

```gml
store.set("volume", 0.8);
```

### `setState(partialState)`

Merges multiple keys at once with a **single** notification — more efficient than calling `set()` repeatedly.

```gml
store.setState({ counter: 0, label: "Reset" });
```

### `get(key, defaultValue?)`

Returns the value for `key`, or `defaultValue` if the key is not defined.

```gml
var count = store.get("counter", 0);
```

### `getState()`

Returns the live `state` struct reference. Prefer `get()` for reads unless you need the full struct.

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

Registers `callback(state)` to run on every state change. Returns `self` for chaining.

```gml
var onChange = function(state) {
    myLabel.text = "Count: " + string(state.count);
};
store.subscribe(onChange);
```

### `unsubscribe(callback)`

Removes a previously registered callback (must be the **exact same function reference**). Returns `self`.

```gml
store.unsubscribe(onChange);
```

## Reactivity Pattern

### Subscribe + direct mutation (recommended)

Subscribers fire only when state actually changes. This is the most efficient pattern for updating UI nodes:

```gml
var store = new UiStore({ count: 0 });

var label = new UiText("Count: 0", {}, {});
store.subscribe(method(label, function(state) {
    self.text = "Count: " + string(state.count);
}));

btn.onClick(function() {
    store.set("count", store.get("count") + 1);
});
```

### Side effects via subscribe

Subscriptions are also ideal for non-UI actions triggered by state changes:

```gml
var gameStore = new UiStore({ soundVolume: 0.8 });

gameStore.subscribe(function(state) {
    audio_group_set_gain(audiogroup_default, state.soundVolume, 100);
});

gameStore.set("soundVolume", 0.5); // triggers audio update
```

## How Reactivity Works

1. You call `set()`, `setState()`, `remove()`, or `reset()`.
2. `__notify()` iterates all registered listeners, passing the current `state` struct.
3. If `global.UI` exists, `requestRedraw()` is called so bound components repaint.

There is no automatic two-way binding — you wire reads (`get()` / `valueGetter` / `subscribe`) and writes (`set()` / `onChange`) explicitly, which keeps data flow predictable in GML.
