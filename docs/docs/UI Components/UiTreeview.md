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
| `onRemoveItem`   | `function(item, wasSelected)`| Called when an item is removed; second arg indicates if it was selected. |
| `onItemSelected` | `function(item, focus)`     | Triggered when an item is selected. Second arg indicates whether focus should be given. |
| `onAssetDrop`    | `function(dragged, target)` | Handles drag & drop between items. Return `true` to accept the drop. |
| `onContextMenu`  | `function(item)`            | Optional callback invoked when an item is right-clicked; receives the item. |

**Item properties (per node)**

Each individual item node may expose the following fields (set when items are created):

| Name     | Type    | Description |
| -------- | ------- | ----------- |
| `name`   | `string`| Item display name. |
| `icon`   | `sprite`| Optional icon sprite displayed next to label. |
| `value`  | `any`   | The item's underlying value. |
| `collapsed` | `bool` | Whether the item is collapsed (default `true` for folders). |
| `entity` | `bool`  | Flag used to denote entity nodes (affects drag behaviour). |
| `asset`  | `any`   | Optional asset reference attached to the item. |
| `assetType` | `string` | A string describing the asset type (used by drop validation). |
| `acceptsDropOf` | `array` | Optional array of assetType strings that this item accepts when dropped onto it. |
| `collapseSprite` | `sprite` | Optional sprite used for the collapsed arrow button. |
| `expandSprite` | `sprite` | Optional sprite used for the expanded arrow button. |

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

**Structure & Nodes**

- `UiTreeview.Items`: root container for top-level items.
- Each item is a `UiTreeviewItem` composed of:
    - `Content` (a `UiNode` with `pointerEvents` and `dropzone`),
    - `LeftContent` (container for arrow + icon + label),
    - `Arrow` (a `UiButton` used to expand/collapse children),
    - `Items` (a `UiNode` containing child items).

**Selection & Interaction**

- Clicking an item's content with the left mouse button selects it. Selection is tracked by `tree.selectedItem` and the `onItemSelected` callback is invoked with the selected item.
- Right-clicking an item triggers the tree's `onContextMenu(item)` callback if provided.
- Pressing `Delete` while the tree has focus and an item is selected will call the item's internal `__removeItem()` method which invokes the tree's `onRemoveItem` callback.

**Drag & Drop**

- Items are draggable (`draggable = true`) and each item's `Content` acts as a `dropzone`.
- The tree supports a per-item `acceptsDropOf` array and an `assetType` string to validate whether a dragged item can be dropped on a target. The built-in `validateDrop(draggedItem, targetItem)` enforces:
    - an item cannot be dropped onto itself,
    - items of type `Texture` or `Material` are not movable,
    - if the target defines `acceptsDropOf`, the dragged item's `assetType` must be listed there,
    - folders (`assetType == "Folder"`) accept any drop.

**Public Item Methods**

| Method | Description |
| ------ | ----------- |
| `addChild(childItem, expand = true)` | Add a child `UiTreeviewItem` to this item. Expands the parent by default. |
| `removeChild(childItem)` | Remove a specific child from this item. |
| `moveItemTo(targetParent, shouldExpand = true, onClearCb = undefined)` | Move this item under `targetParent`. Optionally run `onClearCb` to clear selection/gizmos before move. |
| `expandItem()` | Expand this item to show its children. Updates arrow sprite and visibility. |
| `collapseItem()` | Collapse this item and hide children. |
| `__removeItem()` | Internal removal function that asks for confirmation, invokes `onRemoveItem` and destroys the node. |

**Callbacks / Events**

- `onNewAsset(child)`: invoked when a new child item is programmatically added (`__addItem` helper).
- `onRemoveItem(item, wasSelected)`: invoked when an item is removed; second argument indicates whether the item was selected.
- `onItemSelected(item, focus)`: invoked when an item is selected; `focus` indicates whether the selection should focus the UI.
- `onAssetDrop(dragged, target)`: if defined, it is called when an item is dropped on a target; should return `true` to accept the drop.
- `onContextMenu(item)`: optional; called on right-click to show custom context menus.

**Arrow / Expand/Collapse**

- Each item exposes `Arrow`, a `UiButton` initially hidden. `__updateArrowVisibility()` shows the arrow when the item has children. The button swaps its sprite between `collapseSprite` and `expandSprite` and toggles collapsed state.

**Rendering Notes**

- The item's `onDraw` draws hover highlight (`global.UI_COL_BTN_HOVER`), selected highlight (`global.UI_COL_SELECTED`) and item background when expanded (`global.UI_COL_TREE_BG`).

**Example with drop handler and context menu**

```js
var tree = new UiTreeview();
tree.onAssetDrop = function(draggedItem, targetItem) {
        // validate/move asset
        return true; // accept
};

tree.onContextMenu = function(item) {
        var menu = new UiContextMenu(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), [
                { label: "Rename", onClick: function() { /* ... */ } },
                { label: "Delete", onClick: function() { item.__removeItem(); } }
        ]);
        menu.show();
};
```
