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
