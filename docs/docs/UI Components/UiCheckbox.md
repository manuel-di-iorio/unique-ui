---
sidebar_position: 5
---

Creates a customizable checkbox node with optional label and event handling.

`UiCheckbox` is used to represent a boolean value (`true` / `false`) that can be toggled by the user, supporting labels, callbacks, and dynamic data binding.

```gml
UiCheckbox(style = {}, props = {})
```

**Description**

UiCheckbox provides an interactive checkbox element built with the UniqueUI system.
It can display an optional text label, synchronize its value with an external variable through `setValue()`, and execute callbacks when the user toggles its state.

The component consists of two parts:

- Main Node → container with optional label.

- Input Node → small clickable box that draws the check mark and handles hover/click events.

---

**Properties**

| Property        | Type                     | Default           | Description                                                                            |
| --------------- | ------------------------ | ----------------- | -------------------------------------------------------------------------------------- |
| `value`         | `bool`                   | `false`           | Current state of the checkbox (checked or not).                                        |
| `label`         | `string`                 | `undefined`       | Optional label text displayed next to the checkbox.                                    |
| `onChange`      | `function(value, node)`  | `undefined`       | Callback on value change. Pass as prop or register later via `onChange(cb)` method.    |
| `Input`         | `UiNode`                 | *auto-created*    | Inner node representing the clickable checkbox square.                                 |
| `pointerEvents` | `bool`                   | `true` (on Input) | Enables click and hover detection.                                                     |
| `handpoint`     | `bool`                   | `true` (on Input) | Shows hand cursor when hovering the checkbox.                                          |

**Methods**

| Method               | Description                                                                      |
| -------------------- | -------------------------------------------------------------------------------- |
| **`onClick()`**      | Toggles the checkbox value, triggers `onChange`, and requests a UI redraw.       |
| **`setValue(val)`**  | Sets the value and fires `onChange` listeners. Inherited from UiNode.            |
| **`onChange(cb)`**   | Registers a change listener. Multiple listeners supported. Inherited from UiNode.|
| **`onDraw()`**       | Draws the label (if defined) and manages color and alignment.                    |
| **`Input.onDraw()`** | Handles rendering of the checkbox square, hover highlight, and checkmark sprite. |

---

**Behavior**

The checkbox value is toggled on click, and the UI is marked for redraw.

- The onChange callback is invoked with the new value and reference to the node.

- Use `setValue()` to synchronize the checkbox with external state (e.g., store subscription).

- The checkbox uses a hover highlight effect and a tick sprite (sprUiCheckTick) when active.

- Labels are drawn to the left of the checkbox with small padding and vertical centering.

**Examples**

```js
// Basic checkbox
var checkbox = new UiCheckbox({}, {
    label: "Enable Sound",
    onChange: function(value, input) {
        audio_enabled = value;
    }
});

// Checkbox with external sync (via store subscription)
var syncBox = new UiCheckbox({}, {
    label: "Show Debug Info",
    onChange: function(value) {
        global.showDebug = value;
    }
});
settingsStore.subscribe(method(syncBox, function(state) {
    self.setValue(state.showDebug);
}));
```

**Visual Notes**

- The Input node (UiCheckbox.Input) handles all visual and interactive behavior.

- When hovered, a subtle highlight is drawn using global.UI_COL_HOVER.

- When checked, the tick mark (sprUiCheckTick) appears centered within the box.

- The label uses white text with fa_left and fa_middle alignment for clarity.
