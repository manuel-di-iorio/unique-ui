---
sidebar_position: 10
---

# UiTooltip

A small floating tooltip that follows the cursor and shows contextual text for other UI elements.

---

**Constructor**

```js
new UiTooltip()
```

**Description**

`UiTooltip` is an absolutely positioned `UiNode` hidden by default. It contains an internal `UiText` node and exposes `show(target, text)` and `hide()` methods to control visibility. The tooltip follows the cursor while visible and clamps its position within the window.

**Default Style**

The tooltip is created with the following default style:

- `position: absolute`
- `padding: 3` (with extra left/right padding inside constructor)
- `border: true`
- `left: -9999, top: -9999` (hidden offscreen)
- `display: none`

**Properties**

| Property         | Type      | Description |
| ---------------- | --------- | ------------------------------------------------------------------ |
| `backgroundColor`| `color`   | Tooltip background color (default `#282a36`).                     |
| `borderColor`    | `color`   | Border color (default `#44475a`).                                 |
| `borderRadius`   | `number`  | Corner radius for background (default `4`).                        |
| `textNode`       | `UiText`  | Internal text node used to render the tooltip string.              |
| `target`         | `UiNode`? | The target the tooltip is associated with (set in `show`).        |
| `isPositioned`   | `boolean` | Internal flag used while computing position.                      |

**Methods**

| Method | Returns | Description |
| ------ | ------- | ------------------------------------------------------------------ |
| `show(target, text)` | `void` | Sets tooltip text, associates `target`, computes size and positions tooltip near cursor; makes it visible. |
| `hide()`            | `void` | Hides the tooltip and clears `target`.                              |

**Behavior**

- `show` updates the internal `textNode.text` and calls `textNode.computeSize()` to measure the content; it then places the tooltip slightly offset from the cursor (`mouseX + 15, mouseY + 20`) and clamps the position to remain inside the window.
- The tooltip's `onStep` handler updates position to follow the cursor while visible and prevents constant layout invalidation by only applying small changes when necessary.
- `onDraw` renders a rounded background and a border using `backgroundColor` and `borderColor`.

**Example**

```js
var tip = new UiTooltip();
global.UI.add(tip);
// Show tooltip for a target on hover
someNode.onMouseEnter(function() { tip.show(someNode, "This is a helpful tooltip"); });
someNode.onMouseLeave(function() { tip.hide(); });
```

````
