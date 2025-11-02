---
sidebar_position: 9
---

UiTreeview is a UI node that displays a hierarchical structure of items (child nodes), allowing for selection, drag & drop, and customizable callbacks to manage assets or entities.

It's designed for complex asset trees or scene hierarchies, such as in a 3D editor or asset browser.

Main Features

- ✅ Single-item selection (selectedItem)

- 🧩 Dynamic child container (Items)

- ⚙️ Custom callbacks for events: new asset, remove item, selection, drop, etc.

- 🔄 Automatic visual updates when state changes

- 🧠 Integrated with the event propagation system

- ⚡ Optimized for performance via surface caching and spatial partitioning

**Constructor**

```js
new UiTreeview(style = {}, props = {})
```

| Parameter | Type   | Description                                             |
| --------- | ------ | ------------------------------------------------------- |
| `style`   | struct | Visual and layout styling for the root node.            |
| `props`   | struct | Logical properties and event handlers for the TreeView. |

**Properties**

| Name             | Type                        | Description                                  |
| ---------------- | --------------------------- | -------------------------------------------- |
| `selectedItem`   | `UiTreeviewItem`            | The currently selected tree item.            |
| `Items`          | `UiNode`                    | The container node holding all child items.  |
| `onNewAsset`     | `function(child)`           | Called when a new item is created.           |
| `onRemoveItem`   | `function(item)`            | Called when an item is removed.              |
| `onItemSelected` | `function(item)`            | Triggered when an item is selected.          |
| `onAssetDrop`    | `function(dragged, target)` | Handles drag & drop between items.           |

**Example**

```js
var tree = new UiTreeview();
tree.onItemSelected = function(item) {
    show_debug_message("Selected: " + item.name);
};
root.add(tree);
```

**Visual Features**

- Hover and selection highlighting

- Icon + label alignment with dynamic positioning

- Expand/collapse arrow with sprites:

- sprUiTreeviewArrowDown / sprUiTreeviewArrowRight

- Background rendering for non-collapsed entities (global.UI_COL_TREE_BG)
