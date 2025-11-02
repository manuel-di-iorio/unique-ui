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

## 🔧 Requirements

- GameMaker Studio 2 (latest LTS or IDE version recommended)

---

## 📦 Installation

1. Download or copy the UniqueUI files from the Github Repository.  
2. Import the `uui.yymps` file by dragging it into your GameMaker project.  
3. You’re ready to start building your UI system!

---

## 🚀 Your First UI

Here’s a simple example that creates a text label inside a panel using UniqueUI:

```js
// Create and initialize the root UI
global.UI = new UiRoot();

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

This creates a simple, dynamic UI structure directly from code — no external layout tools required.
