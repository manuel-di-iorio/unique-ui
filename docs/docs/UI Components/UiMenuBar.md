---
sidebar_position: 7
---

# UiMenuBar

Horizontal application-style menu bar with top-level labels (File, Edit, View…) that open dropdown panels on click. When a dropdown is already open, hovering over another label immediately switches to it.

## Usage

```gml
var menuBar = new UiMenuBar([
    {
        label: "File",
        items: [
            { label: "New",  onClick: function() { show_debug_message("New"); }, shortcut: "Ctrl+N" },
            { label: "Open", onClick: function() { show_debug_message("Open"); }, shortcut: "Ctrl+O" },
            { separator: true },
            { label: "Exit", onClick: game_end, shortcut: "Alt+F4" }
        ]
    },
    {
        label: "Edit",
        items: [
            { label: "Undo", onClick: function() { … }, shortcut: "Ctrl+Z" },
            { label: "Redo", onClick: function() { … }, shortcut: "Ctrl+Y" }
        ]
    }
], { width: "100%", height: 32 }, {});

global.UI.add(menuBar);
```

## Constructor

`new UiMenuBar(menus, style, props)`

- `menus` (Array): Top-level menu entries. Each entry is a struct with `label` (String) and `items` (Array).
- `style` (Struct): Layout style passed to `UiNode` (e.g. `width`, `height`).
- `props` (Struct): Optional properties. Supports `itemPadding` (number) for horizontal padding on trigger labels.

### Menu Item Structure

Each item in a menu's `items` array can have:

| Property | Type | Description |
|----------|------|-------------|
| `label` | String | Text displayed for the item. |
| `onClick` | Function | Callback executed when the item is clicked. |
| `shortcut` | String | Optional keyboard shortcut shown right-aligned. |
| `disabled` | Boolean | When `true`, the item is non-interactive and rendered at reduced opacity. |
| `separator` | Boolean | When `true`, renders a horizontal separator line. Other properties are ignored. |

## Methods

### `closeAll()`

Closes any open dropdown panel and clears the active trigger highlight.

```gml
menuBar.closeAll();
```

## Behavior

- **Click to toggle**: Clicking an open menu's trigger closes it; clicking another opens that menu instead.
- **Hover-to-switch**: While a dropdown is open, hovering over a different top-level label immediately opens that menu.
- **Auto-close**: The dropdown closes on outside click, `Escape`, or after selecting an item.
- **Screen clamping**: Dropdown panels are repositioned if they would extend beyond the GUI bounds.
- **Overlay rendering**: Open dropdowns are added to `global.UI.getOverlay()` so they render above other content.
