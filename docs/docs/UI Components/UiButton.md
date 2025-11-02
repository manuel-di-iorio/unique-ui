---
sidebar_position: 3
---

# UiButton

A clickable UI element that displays either **text** or a **sprite**, supporting automatic resizing, hover effects, and flexible alignment.

---

**Constructor**

```js
new UiButton(textOrImage, style = {}, props = {})
```

**Parameters**

| Name          | Type                | Description                                                             |
| ------------- | ------------------- | ----------------------------------------------------------------------- |
| `textOrImage` | `string` | `sprite` | Optional text or sprite to display.                                     |
| `style`       | `struct`            | FlexPanel layout style (width, height, margins, etc.).                  |
| `props`       | `struct`            | Additional configuration such as `outline`, `autoResize`, and `halign`. |

**Properties**

| Property        | Type                   | Description                                                                |
| --------------- | ---------------------- | -------------------------------------------------------------------------- |
| `text`          | `string` | `undefined` | The button label text, if any.                                             |
| `sprite`        | `sprite` | `undefined` | The button sprite (uses subimg 1 on hover if available).                   |
| `autoResize`    | `boolean`              | Automatically adjusts size to fit content. Defaults to `true`.             |
| `outline`       | `boolean`              | Draws an outline instead of a filled background.                           |
| `halign`        | `constant`             | Horizontal alignment (`fa_left`, `fa_center`, `fa_right`). Default center. |
| `handpoint`     | `boolean`              | Shows a hand cursor when hovering (UI convenience flag).                   |
| `pointerEvents` | `boolean`              | Enables pointer interaction (always `true` for buttons).                   |
| `hovered`       | `boolean`              | True when the mouse is over the button.                                    |

**Methods**

| Method              | Returns | Description                                             |
| ------------------- | ------- | ------------------------------------------------------- |
| `resize()`          | `void`  | Updates width and height to fit text or sprite content. |
| `setText(text)`     | `void`  | Sets the button text and resizes it automatically.      |
| `setSprite(sprite)` | `void`  | Sets the button sprite and resizes it automatically.    |

---

**Drawing Behavior**

The button automatically redraws when hovered or when its state changes.
It uses the global UI color palette:

| Constant                  | Description                         |
| ------------------------- | ----------------------------------- |
| `global.UI_COL_BTN_HOVER` | Background color when hovered.      |
| `global.UI_COL_BOX`       | Normal background or outline color. |


If text is defined, the button draws centered text using fText.
If sprite is defined instead, it draws the sprite centered on the button, switching to subimage 1 when hovered.

**Example**

```js
var btn = new UiButton("Click me", { left: 10, top: 10 });
btn.onClick(function() {
    show_debug_message("Button clicked!");
});
global.UI.add(btn);
```

Or with a sprite-based button:
```js
var btn = new UiButton(spr_button);
btn.onClick(function() {
    show_debug_message("Sprite button pressed!");
});
```

**Notes**

- Automatically resizes based on its content, avoiding manual layout updates.
