---
sidebar_position: 8
---

A vertical scrollbar component that enables scrolling within a parent container when its content exceeds the visible area.

Automatically calculates thumb size and position based on the content height, and supports mouse dragging and scroll wheel interaction.

**Constructor**

```js
UiScrollbar(style = {}, props = {})
```

| Parameter | Type     | Description                                                   |
| --------- | -------- | ------------------------------------------------------------- |
| `style`   | `struct` | Optional style overrides for layout, dimensions, or position. |
| `props`   | `struct` | Optional properties (see below).                              |

**Properties**

| Property     | Type  | Default             | Description                         |
| ------------ | ----- | ------------------- | ----------------------------------- |
| `thumbColor` | `int` | `global.UI_COL_BOX` | Color used for the scrollbar thumb. |

**Internal State Variables**

| Variable             | Type   | Description                                    |
| -------------------- | ------ | ---------------------------------------------- |
| `dragged`            | `bool` | Whether the thumb is currently being dragged.  |
| `dragStartY`         | `real` | Mouse Y position at the start of dragging.     |
| `dragStartScrollTop` | `real` | Scroll offset at the start of dragging.        |
| `maxScroll`          | `real` | Maximum vertical scroll amount for the parent. |
| `pointerEvents`      | `bool` | Always `true`, to capture mouse input.         |

**Behavior Summary**

| Behavior               | Description                                                                                                   |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Dynamic sizing**     | Automatically computes thumb height based on the visible area vs total content height.                        |
| **Wheel scrolling**    | The parent container listens to `onWheelUp` and `onWheelDown` events and adjusts `scrollTop` accordingly.     |
| **Dragging**           | Click-and-drag the thumb to scroll the parent content proportionally.                                         |
| **Auto-hide behavior** | If the content fits within the visible area (`__maxScroll <= 0`), the thumb resets and scrolling is disabled. |
| **Continuous sync**    | Thumb position updates automatically each frame to reflect the parent’s `scrollTop` value.                    |

**Scroll calculation logic**

| Step                                                       | Computation                                                                                  |
| ---------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| 1                                                          | Compute total content height by summing child node heights (excluding the scrollbar itself). |
| 2                                                          | Calculate thumb height = `layoutHeight * (layoutHeight / __contentHeight)`.                  |
| 3                                                          | Clamp minimum thumb height to 10px.                                                          |
| 4                                                          | Compute `__maxThumbPosition = layoutHeight - thumbHeight`.                                   |
| 5                                                          | Compute `__maxScroll = __contentHeight - parent.layout.height`.                              |
| 6                                                          | Convert scroll offset ↔ thumb position using proportional mapping:                           |
| `thumbY = (scrollTop / __maxScroll) * __maxThumbPosition`. |                                                                                              |

**Methods**

| Method                   | Description                                                                                              |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| `onStep(layoutUpdated)`  | Updates the scrollbar each frame. Handles layout recalculation, dragging, and thumb synchronization.     |
| `onMount()`              | Registers mouse wheel listeners on the parent to handle scrolling. *(Called automatically when mounted)* |
| `createThumb()`          | Creates and attaches the internal thumb node. *(Executed in constructor)*                                |
| `__computeThumbHeight()` | Internal helper (inlined) to calculate thumb size and position.                                          |

**Mouse interactions**

| Event                  | Description                                                            |
| ---------------------- | ---------------------------------------------------------------------- |
| **Wheel Up**           | Decreases parent `scrollTop` by 30 units (clamped at 0).               |
| **Wheel Down**         | Increases parent `scrollTop` by 30 units (clamped to `__maxScroll`).   |
| **Drag Start (Thumb)** | Activates dragging mode, recording initial mouse and scroll positions. |
| **Dragging**           | Updates scroll position proportionally to mouse movement.              |
| **Mouse Release**      | Ends dragging, resets thumb width and offset.                          |
