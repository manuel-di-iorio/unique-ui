---
sidebar_position: 6
---

# UiContextMenu

A context menu component that appears at a specific position (usually on right-click), displaying a list of actionable items.

## Usage

```gml
// Define menu items
var items = [
    { 
        label: "Edit", 
        onClick: function() { show_debug_message("Edit clicked"); },
        icon: sprEditIcon // Optional sprite
    },
    { 
        label: "Delete", 
        onClick: function() { show_debug_message("Delete clicked"); } 
    },
    { separator: true }, // Horizontal separator
    { 
        label: "Properties", 
        onClick: function() { show_debug_message("Properties clicked"); } 
    }
];

// Create and show the menu at mouse position
var menu = new UiContextMenu(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), items);
menu.show();
```

## Constructor

`new UiContextMenu(x, y, items)`

- `x` (Real): The X coordinate where the menu should appear.
- `y` (Real): The Y coordinate where the menu should appear.
- `items` (Array): An array of structs defining the menu items.

### Item Structure

Each item in the `items` array can have the following properties:

| Property | Type | Description |
|----------|------|-------------|
| `label` | String | The text to display for the item. |
| `onClick` | Function | The callback function to execute when the item is clicked. |
| `icon` | Sprite | (Optional) A sprite to display as an icon next to the label. |
| `separator` | Boolean | (Optional) If set to `true`, this item renders as a horizontal separator line. Other properties are ignored. |

## Methods

### `show()`
Displays the context menu at the configured position. It automatically closes any currently open context menu.

```gml
menu.show();
```

### `close()`
Closes and destroys the context menu.

```gml
menu.close();
```

## Behavior

- **Auto-Close**: The menu automatically closes when clicking outside of it or pressing the `Escape` key.
- **Position Adjustment**: If the menu would spawn partially off-screen, its position is automatically adjusted to stay within the window bounds.
- **Global State**: Only one `UiContextMenu` can be open at a time. Opening a new one closes the previous one.
