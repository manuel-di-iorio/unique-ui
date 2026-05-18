---
sidebar_position: 1
---

# Getting Started

Welcome to UniqueUI, a lightweight and modular user interface system for GameMaker, designed to make complex layouts and interactions simple, efficient, and expressive.

UniqueUI provides a flexible node-based architecture, where each UiNode controls its layout, style, and events.
You can compose reusable components, manage event propagation, and apply styles declaratively - all within native GML.

Under the hood, UniqueUI leverages GameMaker's built-in flexpanel functions to handle automatic layout and alignment, combining native performance with a higher-level, object-oriented API.

Whether you're building in-game editors, debug tools, or dynamic menus, UniqueUI gives you full control over structure, appearance, and performance.

---

## Requirements

- GameMaker Studio 2 (latest LTS or IDE version recommended)

---

## Installation

1. Download or copy the UniqueUI files from the GitHub repository.  
2. Import the `uui.yymps` file by dragging it into your GameMaker project.  
3. You are now ready to build your user interface.

---

## Your First UI

Below is a simple example that creates a button inside a panel using UniqueUI:

```js
// Create a button
var btn = new UiButton("Click Me");
btn.onClick(function() {
    show_debug_message("Button clicked!");
});

// Add the button to the root
global.UI.add(btn);

// In Step event:
global.UI.update();

// In Draw GUI event:
global.UI.draw();
```

This creates a simple, dynamic UI structure directly from code, with no external layout tools required.

---

## Theming

UniqueUI supports light and dark themes out of the box. Use `ui_set_theme()` to switch between them:

```gml
// Switch to dark mode
ui_set_theme("dark");

// Switch to light mode
ui_set_theme("light");
```

### Custom Themes

You can also define your own custom themes by modifying `global.UI_THEMES` in `__UniqueUI_Globals.gml`!

```gml
global.UI_THEMES.myCustomTheme = {
    primary: #FF5722,
    primaryHover: #E64A19,
    bgSidebar: #121212,
    bgMain: #1E1E1E,
    bgCard: #2D2D2D,
    textMain: #FFFFFF,
    textDim: #B0B0B0,
    border: #404040,
    selected: #FF5722,
    selectedHover: #E64A19,
    btnHover: #3D3D3D,
    box: #2D2D2D,
    inputBg: #121212,
    barBg: #2D2D2D,
    checkboxHover: #3D3D3D,
    dropdownListBg: #1E1E1E,
    inspectorBg: #2D2D2D,
    treeBg: #121212,
    selection: #FF5722,
    success: #4CAF50,
    warning: #FF9800,
    danger: #F44336
};

// Then use it:
ui_set_theme("myCustomTheme");
```
