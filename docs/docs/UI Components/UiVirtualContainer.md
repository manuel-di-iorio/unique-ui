---
sidebar_position: 26
---

A pure logic helper struct (not a UiNode) that provides a lazy offset cache and binary search for virtual scrolling. It tracks per-item heights, computes cumulative pixel offsets on demand, and locates which item is at a given scroll offset via binary search.

**Constructor**

```js
UiVirtualContainer(dataLength, estimatedItemHeight)
```

| Parameter            | Type     | Description                                                     |
| -------------------- | -------- | --------------------------------------------------------------- |
| `dataLength`         | `number` | Number of items in the virtual dataset.                         |
| `estimatedItemHeight`| `number` | Fallback height used before an item's actual height is measured.|

**Methods**

| Method                                    | Description                                                                                        |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------|
| `getItemOffset(index)`                    | Returns the cumulative pixel offset of the given item (O(1) cached, O(n) amortized for new regions).|
| `getItemHeight(index)`                    | Returns the measured or estimated height at the given index.                                       |
| `getTotalContentSize()`                   | Returns the total scrollable height of all items (measured + estimated for unmeasured items).       |
| `findNearestItem(offset)`                 | Binary search: returns the index of the last item whose offset ≤ the given scroll offset (O(log N)).|
| `setItemHeight(index, height)`            | Stores a real measured height and invalidates the offset cache from this index forward.              |
| `reset(newDataLength, newEstimatedHeight)`| Clears the cache and reinitializes for a new dataset.                                              |
| `setEstimatedHeight(h)`                   | Updates the fallback estimated height for unmeasured items.                                        |

**Internal State**

| Variable              | Type     | Description                                                          |
| --------------------- | -------- | -------------------------------------------------------------------- |
| `__itemHeights`       | `array`  | Per-index measured or estimated heights, populated lazily.           |
| `__itemOffsets`       | `array`  | Cumulative pixel offsets, computed lazily on demand.                 |
| `__lastMeasuredIndex` | `number` | Index of the last item whose offset has been computed (for lazy eval).|

**Key Design Points**

- The offset cache is computed **lazily**: `getItemOffset(n)` only computes offsets from `__lastMeasuredIndex + 1` to `n`, not the entire list.
- After `setItemHeight(index, height)`, the cache is invalidated at `index` (by setting `__lastMeasuredIndex = index - 1`), so subsequent offset queries will recompute the affected range.
- `findNearestItem` runs a standard binary search; each visited index triggers a lazy offset calculation for that region.
- This struct is used internally by `UiVirtualList` and is designed to be reused by `UiVirtualGrid` and `UiVirtualTreeView` in the future.
