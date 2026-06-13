---
sidebar_position: 28
---

A virtual-scrolling tree view that renders only the visible window's worth of rows into a fixed-size flexpanel pool. The tree hierarchy is flattened into a depth-first array; expand/collapse rebuilds this array and updates the virtual container.

Inherits from `UiNode` and reuses `UiVirtualContainer` for lazy offset caching and binary search.

**Constructor**

```js
UiVirtualTreeview(style = {}, props = {})
```

| Parameter | Type     | Description                                                     |
| --------- | -------- | --------------------------------------------------------------- |
| `style`   | `struct` | Standard UiNode style (width, height, padding, margin, etc.).   |
| `props`   | `struct` | Component properties (see below).                               |

**Properties**

| Property              | Type                  | Default  | Description                                                      |
| --------------------- | --------------------- | -------- | ---------------------------------------------------------------- |
| `value`               | `array`               | `[]`     | Array of tree-node structs (see data format below).              |
| `estimatedRowHeight`  | `number`              | `32`     | Fallback height for unmeasured rows.                             |
| `buffer`              | `number`              | `5`      | Extra rows rendered above/below the visible window.              |
| `renderItem`          | `function(index)`     | -        | Called once per pool slot during construction; must return a UiNode. |
| `onBind`              | `function(index, flatEntry, node)`| - | Called when a pool slot is rebound to a different flat entry.    |
| `onToggle`            | `function(index, flatEntry)`| -     | Called when a node is expanded or collapsed.                     |
| `onItemSelected`      | `function(treeItem)`  | -        | Called when a row is clicked (receives the original tree node).  |
| `scrollbarColor`      | `color` or `function` | -        | Passed through to `enableScrollbar()`.                           |

**Tree Node Data Format**

Each entry in `value` is a plain struct (not a UiNode):

| Property    | Type      | Default   | Description                                     |
| ----------- | --------- | --------- | ----------------------------------------------- |
| `name`      | `string`  | -         | Display label for the node.                     |
| `children`  | `array`   | `[]`      | Nested child nodes (same format).               |
| `collapsed` | `bool`    | `true`    | Whether children are hidden.                    |
| `assetType` | `string`  | -         | Optional type tag (`"Folder"`, `"Asset"`, etc.) |
| `icon`      | `sprite`  | `-1`      | Optional sprite drawn as node icon.             |

Example:
```js
var treeData = [
    {
        name: "src",
        assetType: "Folder",
        collapsed: true,
        children: [
            { name: "main.js",  assetType: "Asset", children: [] },
            { name: "utils.js", assetType: "Asset", children: [] }
        ]
    },
    { name: "README.md", assetType: "Asset", children: [] }
];
```

**Methods**

| Method                            | Description                                                              |
| --------------------------------- | ------------------------------------------------------------------------ |
| `getContentSize()`                | Returns total virtual content height (O(1); used by `UiScrollbar`).      |
| `scrollToIndex(index)`            | Scrolls so that the given flat entry is at the top of the viewport.      |
| `setValue(newValue)`              | Replaces the tree dataset and rebuilds flat data + cache.                |
| `expandAll()`                     | Expands all collapsible nodes (recursive).                               |
| `collapseAll()`                   | Collapses all expandable nodes.                                          |
| `getFlatData()`                   | Returns the current flat data array (depth-first, read-only).            |
| `__toggleEntry(flatIndex)`        | Toggles expand/collapse for a specific flat entry.                       |

**Default Row Template**

When `renderItem` is omitted, the component builds a default row with:

| Child      | Size   | Description                                    |
| ---------- | ------ | ---------------------------------------------- |
| Arrow      | 20×20  | Triangle pointer, visible only for expandable nodes. Click toggles expand/collapse. |
| Icon       | 20×20  | Draws the node's sprite, a folder shape, or a document rectangle. |
| Label      | flex:1 | Node name, left-aligned.                       |

Depth indentation is applied via `paddingLeft` on the row. Clicking a row selects it (highlights with `global.UI_COL_PRIMARY` at 0.3 alpha).

**Internal Structure**

| Child          | Count          | Purpose                                                        |
| -------------- | -------------- | -------------------------------------------------------------- |
| `SpacerTop`    | 1              | Pushes the visible window down to match the current scrollTop. |
| Pool nodes     | `poolSize`     | Fixed pool of UiNodes; reused via show/hide + rebind.          |
| `SpacerBottom` | 1              | Fills the remaining content height below the visible window.   |
| Scrollbar      | 1              | Standard `UiScrollbar` attached by `enableScrollbar()`.         |

**How Pool Size Is Calculated**

```
poolSize = clamp(ceil(containerHeight / minItemHeight) + buffer * 2, 4, 200)
```

Where `minItemHeight = max(20, estimatedRowHeight * 0.5)`.

**Flat Data Algorithm**

A depth-first traversal flattens the tree on construction and after every expand/collapse. Children of collapsed nodes are excluded from the flat array. Each entry is a struct:

```gml
{ node: <original tree node>, depth: <indentation level>, expandable: <has children> }
```

**Key Design Points**

- **No add/remove**: Pool nodes are created once and kept in the flexpanel for the component's lifetime.
- **Lazy offset cache**: Heights are measured post-layout and stored in `UiVirtualContainer`.
- **Binary search**: Finding the first visible row is O(log N).
- **Scrollbar integration**: `getContentSize()` is detected by `UiScrollbar` via `variable_struct_exists`, avoiding O(N) child iteration.
