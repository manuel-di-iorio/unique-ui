---
sidebar_position: 27
---

A virtual-scrolling list component that renders only the visible window's worth of items into a fixed-size flexpanel pool. Supports both fixed and variable item heights with lazy measurement, binary-search offset lookup, and scroll-to-index.

**Constructor**

```js
UiVirtualList(style = {}, props = {})
```

| Parameter | Type     | Description                                                     |
| --------- | -------- | --------------------------------------------------------------- |
| `style`   | `struct` | Standard UiNode style (width, height, padding, margin, etc.).   |
| `props`   | `struct` | Component properties (see below).                               |

**Properties**

| Property              | Type                  | Default  | Description                                                      |
| --------------------- | --------------------- | -------- | ---------------------------------------------------------------- |
| `value`               | `array`               | `[]`     | Array of raw data items to display.                              |
| `estimatedItemHeight` | `number`              | `40`     | Fallback height for unmeasured items.                            |
| `buffer`              | `number`              | `5`      | Extra items rendered above/below the visible window.             |
| `renderItem`          | `function(index)`     | —        | Called once per pool slot during construction; must return a UiNode. |
| `onBind`              | `function(index, node)`| —        | Called when a pool slot is rebound to a different data index.    |
| `onChange`            | `function(newValue, node)`| —     | Fired when the dataset is replaced via `setValue()`.             |
| `scrollbarColor`      | `color` or `function` | —        | Passed through to `enableScrollbar()`.                           |

**Methods**

| Method                               | Description                                                              |
| ------------------------------------ | ------------------------------------------------------------------------ |
| `getContentSize()`                   | Returns total virtual content height (O(1); used by `UiScrollbar`).      |
| `scrollToIndex(index)`               | Scrolls so that the given data index is at the top of the viewport.      |
| `setValue(newValue)`                 | Replaces the dataset and resets scroll position + offset cache.          |

**Internal Structure**

The component creates three types of children inside the flexpanel, once during construction:

| Child            | Count          | Purpose                                                        |
| ---------------- | -------------- | -------------------------------------------------------------- |
| `SpacerTop`      | 1              | Pushes the visible window down to match the current scrollTop. |
| Pool nodes       | `poolSize`     | Fixed pool of UiNodes; reused via show/hide + rebind.          |
| `SpacerBottom`   | 1              | Fills the remaining content height below the visible window.   |
| Scrollbar        | 1              | Standard `UiScrollbar` attached by `enableScrollbar()`.         |

**How Pool Size Is Calculated**

```
poolSize = clamp(ceil(containerHeight / minItemHeight) + buffer * 2, 4, 200)
```

Where `minItemHeight = max(20, estimatedItemHeight * 0.5)`.

**Recycling Algorithm** (runs each step after layout)

1. Measure actual layout heights of visible pool nodes → update `UiVirtualContainer` cache via `setItemHeight()`.
2. Binary search via `findNearestItem()` to find the first and last visible item.
3. Apply buffer, clamp to pool capacity.
4. For each pool slot: sync height from cache, call `onBind(index, node)` if the data index changed, then show the node.
5. Hide surplus pool slots.
6. Reposition spacers so flexpanel reflects the correct scroll offset.

**Key Design Points**

- **No add/remove**: Pool nodes are created once and kept in the flexpanel for the component's lifetime. Only `show()`/`hide()` and `setHeight()` are called during scrolling — zero tree churn.
- **Lazy offset cache**: Heights are measured post-layout and stored in `UiVirtualContainer`. Offsets are computed lazily only up to the requested index.
- **Binary search**: Finding the first visible item is O(log N) instead of O(N).
- **Scrollbar integration**: `getContentSize()` is detected by `UiScrollbar` via `variable_struct_exists` check, avoiding O(N) child iteration for virtual lists.
