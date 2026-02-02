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
| `setSize(w, h)`                      | `UiRoot`        | Sets the root node’s dimensions and updates the spatial tree bounds.                                                      |
| `update()`                           | `void`          | Updates layout, mouse input, hover detection, drag events, and dispatches UI events. Should be called every step.         |
| `render(debug = false)`              | `void`          | Renders the UI tree to an internal surface and draws it to the screen. If `debug = true`, draws element bounds and names. |
| `requestUpdate(element?)`            | `void`          | Marks the UI (or a specific element) as needing a layout update on the next `update()` call.                              |
| `requestRedraw(element?)`            | `void`          | Marks the UI (or a specific element) as needing a redraw on the next `render()` call.                                     |
| `focusNext()`                        | `void`          | Moves focus to the next focusable element (Tab navigation).                                                               |
| `focusPrevious()`                    | `void`          | Moves focus to the previous focusable element (Shift+Tab navigation).                                                     |
| `clearAllFocused()`                  | `void`          | Blurs the current focused element and clears the list of focusable elements.                                              |
| `hasAnyFocus()`                      | `boolean`       | Returns `true` if any element currently has focus.                                                                        |
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

You can respond to focus changes using the `onFocus` and `onBlur` callbacks on any `UiNode`.

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

The focus system is managed directly by the `UiRoot` instance (usually `global.UI`).

#### `global.UI.focusNext()`
Moves focus to the next available focusable element.

#### `global.UI.focusPrevious()`
Moves focus to the previous focusable element.

#### `global.UI.hasAnyFocus()`
Returns whether any element in the UI currently has focus.

#### `global.UI.clearAllFocused()`
Removes focus from any currently focused element.

### Keyboard Navigation

The system automatically handles **Tab** navigation:
- **Tab**: Moves focus to the next focusable element.
- **Shift + Tab**: Moves focus to the previous focusable element.

The navigation order is determined by the order in which elements are mounted (added) to the UI tree.

### Focus Logic

- **Clicking**: Clicking on a focusable element gives it focus. Clicking on a non-focusable element (like the background) clears the focus (blurs the current element).
- **Visibility**: Hidden or disabled elements are skipped during tab navigation.
