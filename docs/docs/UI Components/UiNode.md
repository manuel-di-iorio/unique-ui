---
sidebar_position: 2
---

Represents a flexible, composable UI element that manages its own layout, style, and interaction.
Each UiNode can contain children, handle user events, and be styled dynamically.

**Constructor**

```js
new UiNode(style = {}, props = {})
```

**Parameters**

| Name    | Type     | Description                                                                      |
| ------- | -------- | -------------------------------------------------------------------------------- |
| `style` | `struct` | FlexPanel style properties (position, width, height, etc.).                      |
| `props` | `struct` | Behavior and configuration options (e.g., `pointerEvents`, `visible`, `onDraw`). |

**Core properties**

| Property         | Type                   | Description                                     |
| ---------------- | ---------------------- | ----------------------------------------------- |
| `id`             | `integer`              | Unique node identifier.                         |
| `type`           | `string`               | Always `"UiNode"`.                              |
| `isUiNode`       | `boolean`              | True for all UI nodes.                          |
| `parent`         | `UiNode` | `undefined` | Parent node, if any.                            |
| `children`       | `array<UiNode>`        | List of child nodes.                            |
| `childrenLength` | `integer`              | Cached child count.                             |
| `visible`        | `boolean`              | Whether the node is visible.                    |
| `display`        | `boolean`              | FlexPanel display flag.                         |
| `pointerEvents`  | `boolean`              | Whether the node reacts to pointer events.      |
| `border`         | `boolean`              | If true, draws a border for debugging.          |
| `borderColor`    | `int`                  | Color of the border if enabled.                 |
| `draggable`      | `boolean`              | Enables drag behavior.                          |
| `dropzone`       | `boolean`              | Enables node to receive dropped elements.       |
| `scrollTop`      | `real`                 | Current scroll offset (for scrollable parents). |
| `layout`         | `struct`               | Layout box (position, margins, paddings, size). |
| `onDraw`         | `function`             | Called every frame before drawing.              |
| `onDestroy`      | `function`             | Called when the node is destroyed.              |
| `tooltip`        | `string|function`      | Optional tooltip text or function. If set, `tooltipDelay` (ms) controls how long the cursor must hover before the tooltip is shown. |
| `tooltipDelay`   | `integer`              | Milliseconds to wait before showing the tooltip (default `500`). |

**Hierarchy methods**

| Method              | Description                                             |
| ------------------- | ------------------------------------------------------- |
| `add(...nodes)`     | Adds one or more children to this node.                 |
| `remove(node)`      | Removes a child from this node.                         |
| `clear()`           | Removes all children (but does not destroy them).       |
| `destroy()`         | Deletes this node and its children from memory.         |
| `destroyChildren()` | Deletes all children but keeps this node alive.         |
| `count()`           | Returns the number of direct children.                  |
| `countAll()`        | Returns the number of nodes in the subtree (recursive). |

**Traversal**

| Method                                      | Description                                         |
| ------------------------------------------- | --------------------------------------------------- |
| `traverse(cb, recursive = true)`            | Calls `cb(node)` on self and all descendants.       |
| `traverseChildren(cb, recursive = true)`    | Calls `cb(node)` on children (recursively if true). |
| `reduceChildren(cb, acc, recursive = true)` | Reduces the node tree into a single value.          |

**Focus management**

| Method         | Description                                     |
| -------------- | ----------------------------------------------- |
| `focus()`      | Gives focus to this element.                    |
| `blur()`       | Removes focus from this element.                |
| `hasFocus()`   | Returns `true` if this element is focused.      |
| `getFocused()` | Returns the currently focused element (static). |

**Layout & style**

| Method                             | Description                       |
| ---------------------------------- | --------------------------------- |
| `setSize(w, h)`                    | Sets node width and height.       |
| `setWidth(value)` / `getWidth()`   | Sets or gets the node width.      |
| `setHeight(value)` / `getHeight()` | Sets or gets the node height.     |
| `setLeft(value)` / `getLeft()`     | Sets or gets the left position.   |
| `setTop(value)` / `getTop()`       | Sets or gets the top position.    |
| `setRight(value)` / `getRight()`   | Sets or gets the right position.  |
| `setBottom(value)` / `getBottom()` | Sets or gets the bottom position. |

**Margin helpers**

| Method                                         | Description    |
| ---------------------------------------------- | -------------- |
| `setMarginTop(value)` / `getMarginTop()`       | Top margin.    |
| `setMarginLeft(value)` / `getMarginLeft()`     | Left margin.   |
| `setMarginRight(value)` / `getMarginRight()`   | Right margin.  |
| `setMarginBottom(value)` / `getMarginBottom()` | Bottom margin. |

**Visibility**

| Method        | Description                                         |
| ------------- | --------------------------------------------------- |
| `show()`      | Displays the node.                                  |
| `hide()`      | Hides the node.                                     |
| `isVisible()` | Returns `true` if visible and inside scroll bounds. |

---

### Event System

The UiNode class supports DOM-like event bubbling and capture phases, including mouse and wheel interactions.
Events propagate along the parent chain unless stopped.

**Available Events**

```js
UI_EVENT.wheelup
UI_EVENT.wheeldown
UI_EVENT.mousedown
UI_EVENT.mouseup
UI_EVENT.click
UI_EVENT.doubleclick
UI_EVENT.mouseover
UI_EVENT.mouseout
UI_EVENT.mouseenter
UI_EVENT.mouseleave
```

**Event methods**

| Method                                                     | Description                                      |
| ---------------------------------------------------------- | ------------------------------------------------ |
| `addEventListener(event, callback, useCapture = false)`    | Adds an event listener (capture or bubble).      |
| `removeEventListener(event, callback, useCapture = false)` | Removes an event listener.                       |
| `clearEventListeners(event)`                               | Clears all listeners of a specific event.        |
| `dispatchEvent(event, target)`                             | Dispatches an event manually (bubbles/captures). |

**Shorthand listeners**

| Method             | Description                      |
| ------------------ | -------------------------------- |
| `onClick(cb)`      | Triggered when clicked.          |
| `onMouseDown(cb)`  | Triggered on mouse down.         |
| `onMouseUp(cb)`    | Triggered on mouse up.           |
| `onMouseEnter(cb)` | Triggered when the mouse enters. |
| `onMouseLeave(cb)` | Triggered when the mouse leaves. |
| `onWheelUp(cb)`    | Triggered on scroll up.          |
| `onWheelDown(cb)`  | Triggered on scroll down.        |
| `onDoubleClick(cb)`| Triggered on double click.       |
| `click()`          | Manually triggers a click event. |
| `onStep(cb)`       | Adds a per-frame step handler.   |

> 🧠 Note: The UI system uses an internal **Dynamic AABB Tree 2D** for event dispatch, optimizing hit detection and interaction on complex interfaces with many elements.

**Drag & Drop**

| Property    | Description                        |
| ----------- | ---------------------------------- |
| `draggable` | Enables dragging.                  |
| `dropzone`  | Allows receiving dropped elements. |

| Callback      | Description                               |
| ------------- | ----------------------------------------- |
| `onDragStart` | Called when dragging starts.              |
| `onDrag`      | Called while dragging.                    |
| `onDragEnd`   | Called when dragging stops.               |
| `onDrop`      | Called when another node is dropped over. |

**Scrollbars**

| Method                         | Description                            |
| ------------------------------ | -------------------------------------- |
| `enableScrollbar(thumbColor?)` | Adds a vertical scrollbar to the node. |
| `disableScrollbar()`           | Removes the scrollbar.                 |

**Naming**

| Method          | Description                            |
| --------------- | -------------------------------------- |
| `setName(name)` | Sets the internal FlexPanel node name. |
| `getName()`     | Returns the node name.                 |

---

**⚡ Performance Notes**

- UiNode is backed by GameMaker's FlexPanel functions, a lightweight Yoga-style layout engine.
- The event system uses a **Dynamic AABB Tree 2D** to efficiently resolve pointer targets, allowing for high performance even with thousands of nodes.
- Internal caching (e.g., for scroll bounds) avoids redundant computations.
- All core methods are marked with gml_pragma("forceinline") for maximum performance.
