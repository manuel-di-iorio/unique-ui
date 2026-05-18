# UiStore

Lightweight reactive UI state management store that allows component state sharing and reactive data binding.

## Usage

```gml
// 1. Create a reactive state store
global.store = new UiStore({
    counter: 0,
    themeMode: "dark"
});

// 2. Subscribe a component or callback to state changes
global.store.subscribe(function(state) {
    show_debug_message("Counter changed to: " + string(state.counter));
});

// 3. Update the state reactively
global.store.set("counter", global.store.get("counter") + 1);
```

## Methods

- `set(key, value)`: Updates the value for a specific state key, notifies all reactive subscribers, and automatically calls `global.UI.requestRedraw()`.
- `get(key, defaultValue)`: Retrieves the value of a state key, or returns the specified `defaultValue` if the key is not defined.
- `subscribe(callback)`: Registers a callback function that is automatically executed whenever the store's state is modified. Receives the updated `state` struct as its argument. Returns `self` for method chaining.

## Advanced Examples

### 1. Reactive UI Binding (Counter Example)
You can bind UI components directly to a `UiStore` state by using a `valueGetter` on components like `UiText`. When the store state updates, `global.UI.requestRedraw()` is called automatically, which forces the UI to re-read and render the updated state instantly.

```gml
// Initialize the store
global.counterStore = new UiStore({ count: 10 });

// Add a label that dynamically displays the count
var counterLabel = new UiText("Count: 10", {}, {
    valueGetter: function() {
        return "Count: " + string(global.counterStore.get("count"));
    }
});

// Add a button that increments the counter
var incrementBtn = new UiButton("+", {}, {});
incrementBtn.onClick(function() {
    var currentCount = global.counterStore.get("count");
    global.counterStore.set("count", currentCount + 1);
});
```

### 2. Two-Way State Syncing (Switch & Custom Panel)
You can synchronize the state of interactive components (like switches or checkboxes) across multiple different areas of your UI.

```gml
// Initialize a shared settings store
global.settingsStore = new UiStore({ notificationsEnabled: false });

// Create a switch bound to the store state
var notificationSwitch = new UiSwitch({}, {
    label: "Enable Notifications",
    valueGetter: function() {
        return global.settingsStore.get("notificationsEnabled");
    },
    onChange: function(newValue) {
        global.settingsStore.set("notificationsEnabled", newValue);
    }
});

// Create a status panel that changes color/text based on the switch state
var statusText = new UiText("Disabled", {}, {
    color: function() {
        return global.settingsStore.get("notificationsEnabled") ? c_green : c_red;
    },
    valueGetter: function() {
        return global.settingsStore.get("notificationsEnabled") ? "Active" : "Inactive";
    }
});
```

### 3. Store Subscriptions for Side Effects
Subscriptions are incredibly useful for trigger-based actions (like saving settings, playing sound effects, or calling backend APIs) when specific state values change.

```gml
global.gameStore = new UiStore({ soundVolume: 0.8 });

// Subscribe to track and apply sound volume changes
global.gameStore.subscribe(function(state) {
    audio_group_set_gain(audiogroup_default, state.soundVolume, 100); // Apply volume smoothly
    show_debug_message("Audio gain updated to: " + string(state.soundVolume));
});

// Changing the state will now trigger the volume adjustment automatically
global.gameStore.set("soundVolume", 0.5);
```
