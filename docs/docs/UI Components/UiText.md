---
sidebar_position: 4
---

# UiText

Creates a dynamic text node with optional icon and auto-resizing.

`UiText` is designed for displaying static or dynamically updated text, supporting icons, custom fonts, and automatic layout resizing based on the text content.

```gml
UiText(text = "", style = {}, props = {})
```

**Description**

UiText is a simple and efficient UI element that renders text within the UniqueUI system.
It can automatically resize itself based on the rendered string. Use `setValue()` to update text dynamically, making it suitable for labels, counters, or real-time indicators.

If an icon is provided, it will be drawn next to the text with proper spacing.

**Properties**

| Property     | Type       | Default                              | Description                                                                    |
| ------------ | ---------- | ------------------------------------ | ------------------------------------------------------------------------------ |
| `value`      | `string`   | `""`                                 | The text displayed by the node (inherited from UiNode).                        |
| `autoResize` | `bool`     | `true` (if no width/height in style) | Automatically adjusts node size to match text content.                         |
| `halign`     | `constant` | `fa_left`                            | Horizontal alignment (left, center, right).                                    |
| `valign`     | `constant` | `fa_top`                             | Vertical alignment (top, middle, bottom).                                      |
| `icon`       | `sprite`   | `undefined`                          | Optional sprite drawn before the text.                                         |
| `color`      | `color`    | `c_white`                            | Text color.                                                                    |
| `font`       | `font`     | `fText`                              | Font used to draw the text.                                                    |

**Methods**

| Method                | Description                                                                                                     |
| --------------------- | --------------------------------------------------------------------------------------------------------------- |
| **`computeSize()`**   | Calculates and updates the node's width and height based on the text and optional icon. Used for auto-resizing. |
| **`setValue(text)`**  | Updates the text content and triggers `onChange` listeners. Inherited from UiNode.                               |
| **`onChange(cb)`**    | Registers a change listener. Multiple listeners supported. Inherited from UiNode.                                |
| **`onDraw()`**        | Handles the rendering of both icon and text, applying alignment, font, and color settings.                      |

**Behavior**

- If autoResize is true, the node automatically adjusts its size when the text changes.
 - If `autoResize` is true (the default when no explicit width/height is provided in `style`), the node automatically adjusts its size when the text changes by calling `computeSize()` which measures text width/height and optionally accounts for an icon.
- Use `setValue()` to update the text reactively (e.g., from a store subscription or callback).
- Supports both static and reactive UI text.

**Example**

```js
// Create a static text label
var label = new UiText("Hello World!", { x: 20, y: 20 });

// Create a dynamic label that displays the current FPS
var fpsText = new UiText("", {});
// Update via store subscription
fpsStore.subscribe(method(fpsText, function(state) {
    self.setValue("FPS: " + string(state.fps));
}));

// Add an icon before the text
var iconText = new UiText("Settings", {}, { icon: spr_settings });
```
