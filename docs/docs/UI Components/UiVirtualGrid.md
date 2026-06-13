---
sidebar_position: 28
---

A virtual-scrolling 2D grid component that renders only the visible window's worth of rows into a fixed-size flexpanel pool. Each pooled row contains one cell per column; as the user scrolls vertically, rows are rebound to the correct data indices. Supports both fixed and variable row heights with lazy measurement, binary-search offset lookup, and horizontal scrolling for wide column sets.

**Constructor**

```js
UiVirtualGrid(style = {}, props = {})
```

| Parameter | Type     | Description                                                     |
| --------- | -------- | --------------------------------------------------------------- |
| `style`   | `struct` | Standard UiNode style (width, height, padding, margin, etc.).   |
| `props`   | `struct` | Component properties (see below).                               |

**Properties**

| Property                | Type                    | Default  | Description                                                      |
| ----------------------- | ----------------------- | -------- | ---------------------------------------------------------------- |
| `value`                 | `array`                 | `[]`     | 2D array of data items (array of rows, each row is an array).    |
| `estimatedRowHeight`    | `number`                | `40`     | Fallback height for unmeasured rows.                             |
| `estimatedColumnWidth`  | `number`                | `120`    | Fallback width for each column (determines total grid width).    |
| `buffer`                | `number`                | `3`      | Extra rows rendered above/below the visible window.              |
| `numColumns`            | `number`                | -        | Fixed column count (auto-detected from `value[0]` if omitted).   |
| `renderCell`            | `function(rowIndex, colIndex)` | - | Called once per pool slot per column during construction; must return a UiNode. |
| `onBind`                | `function(rowIndex, colIndex, node)` | - | Called when a cell is rebound to a different data index. |
| `onChange`              | `function(newValue, grid)` | -      | Fired when the dataset is replaced via `setValue()`.             |
| `scrollbarColor`        | `color` or `function`   | -        | Passed through to `enableScrollbar()`.                           |
| `scrollbarColorH`       | `color` or `function`   | -        | Color for the horizontal scrollbar (defaults to `scrollbarColor`). |

**Methods**

| Method                               | Description                                                              |
| ------------------------------------ | ------------------------------------------------------------------------ |
| `getContentSize()`                   | Returns total virtual content height (O(1); used by `UiScrollbar`).      |
| `scrollToIndex(index)`               | Scrolls so that the given row index is at the top of the viewport.       |
| `setValue(newValue)`                 | Replaces the dataset and resets scroll position + offset cache.          |

**Internal Structure**

The component creates three types of children inside the flexpanel, once during construction:

| Child            | Count                  | Purpose                                                        |
| ---------------- | ---------------------- | -------------------------------------------------------------- |
| `SpacerTop`      | 1                      | Pushes the visible window down to match the current scrollTop. |
| Pool rows        | `poolSize`             | Each row is a flex row containing `numColumns` cell nodes.     |
| `SpacerBottom`   | 1                      | Fills the remaining content height below the visible window.   |
| Scrollbar        | 1 (vertical) + 1 (horizontal) | Standard `UiScrollbar` for both axes.                 |

**How Pool Size Is Calculated**

```
poolSize = clamp(ceil(containerHeight / minRowHeight) + buffer * 2, 4, 200)
```

Where `minRowHeight = max(20, estimatedRowHeight * 0.5)`.

**Recycling Algorithm** (runs each step after layout)

1. Binary search via `findNearestItem()` to find the first and last visible row.
2. Apply buffer, clamp to pool capacity.
3. For each pool row: rebind all cells via `onBind(rowIndex, colIndex, cell)`, then set row height from cache.
4. Hide surplus pool rows.
5. Reposition spacers so flexpanel reflects the correct scroll offset.

**Key Design Points**

- **No add/remove**: Pool rows are created once and kept in the flexpanel for the component's lifetime. Only `show()`/`hide()` and `setHeight()` are called during scrolling - zero tree churn.
- **Lazy offset cache**: Row heights are measured post-layout and stored in `UiVirtualContainer`. Offsets are computed lazily only up to the requested index.
- **Binary search**: Finding the first visible row is O(log N) instead of O(N).
- **Horizontal scrollbar**: The grid content width equals `numColumns * estimatedColumnWidth`, enabling a horizontal scrollbar for wide datasets.
- **Per-cell onBind**: Each cell in the visible window receives `onBind(rowIndex, colIndex, node)` so the user can update cell content individually.
