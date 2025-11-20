---
sidebar_position: 1
---

The root container for all UI elements in **UniqueUI**.  
`UiRoot` manages the top-level node hierarchy, event dispatching, and rendering order.  
It acts as the entry point for your entire interface, typically stored in a global variable like `global.UI`.

---

**Constructor**

```js
new UiRoot()
```

**Description**

Creates a new root node responsible for:

- Storing all top-level UI nodes.

- Managing mouse and keyboard events.

- Handling redraw requests (needsRedraw flag).

- Managing layout and rendering through GameMaker’s flexpanel functions.

Usually, you only need one instance of UiRoot per scene or project.

---

**Properties**

| Name                       | Type                     | Description                                                                         |
| -------------------------- | ------------------------ | ----------------------------------------------------------------------------------- |
| `root`                     | `boolean`                | Always `true` for the root node. Used to identify the top-level container.          |
| `needsUpdate`              | `boolean`                | Triggers a full layout recalculation via FlexPanel.                                 |
| `needsRedraw`              | `boolean`                | Marks the UI as dirty — causes re-rendering on the next `render()` call.            |
| `layoutUpdated`            | `boolean`                | `true` if a new layout was computed during the last `update()`.                     |

**Methods**

| Method                               | Returns         | Description                                                                                                               |
| ------------------------------------ | --------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `setSize(w, h)`                      | `UiRoot`        | Sets the root node’s dimensions and resizes the spatial grid accordingly.                                                 |
| `update()`                           | `void`          | Updates layout, mouse input, hover detection, drag events, and dispatches UI events. Should be called every step.         |
| `render(debug = false)`              | `void`          | Renders the UI tree to an internal surface and draws it to the screen. If `debug = true`, draws element bounds and names. |
| `setName(name)`                      | `void`          | Inherited from `UiNode`; sets the FlexPanel node name (used in debug view).                                               |

---

## Focus System

UniqueUI includes a built-in focus management system that handles keyboard navigation (Tab/Shift+Tab), mouse interaction, and focus events.

### Making Elements Focusable

To make a `UiNode` capable of receiving focus, set the `focusable` property to `true` in its configuration or constructor.

```gml
var input = new UiTextbox({
    width: 200,
    height: 30
}, {
    focusable: true // Enable focus
});
```

### Handling Focus Events

You can respond to focus changes using the `onFocus` and `onBlur` callbacks.

```gml
var button = new UiButton("Submit");

button.onFocus = function() {
    // Called when the element gains focus
    self.borderColor = c_aqua;
};

button.onBlur = function() {
    // Called when the element loses focus
    self.borderColor = c_white;
};
```

### Programmatic Control

The focus system is managed by `global.UI.focusManager`. You can use it to control focus from code.

#### `global.UI.focusManager.setFocus(element)`
Sets focus to a specific element.

```gml
global.UI.focusManager.setFocus(myTextbox);
```

#### `global.UI.focusManager.blur()`
Removes focus from the currently focused element.

```gml
global.UI.focusManager.blur();
```

#### `global.UI.focusManager.getFocused()`
Returns the currently focused element, or `undefined` if none.

```gml
var current = global.UI.focusManager.getFocused();
```

#### Checking Focus State
To check if a specific element has focus, use `hasFocus()`:

```gml
if (global.UI.focusManager.hasFocus(myElement)) {
    // myElement is focused
}
```

> **Note:** The `focused` property on a `UiNode` is **not** automatically updated by the focus manager. If you need to track focus state within your component (e.g., for rendering), you should update a state variable inside your `onFocus` and `onBlur` callbacks.

### Keyboard Navigation

The system automatically handles **Tab** navigation:
- **Tab**: Moves focus to the next focusable element.
- **Shift + Tab**: Moves focus to the previous focusable element.

The navigation order is determined by the order in which elements are mounted (added) to the UI tree.

### Focus Logic

- **Clicking**: Clicking on a focusable element gives it focus. Clicking on a non-focusable element (like the background) clears the focus (blurs the current element).
- **Visibility**: Hidden or disabled elements are skipped during tab navigation.
