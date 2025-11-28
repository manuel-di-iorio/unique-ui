---
sidebar_position: 2
---

Represents a drawable image node that extends UiNode.

UiSprite is used to render GameMaker sprites inside the UI layout system, maintaining full compatibility with FlexPanel layout rules and event handling.

**🔧 Constructor**
```js
new UiSprite(sprite, style = {}, props = {})
```

**Parameters**
| Name     | Type     | Description                                                              |
| -------- | -------- | ------------------------------------------------------------------------ |
| `sprite` | `sprite` | The GameMaker sprite resource to display.                                |
| `style`  | `struct` | Optional FlexPanel style settings (size, position, alignment, etc.).     |
| `props`  | `struct` | Optional behavior configuration (e.g. `pointerEvents`, `onClick`, etc.). |

**🎨 Properties**
| Property | Type      | Description                                   |
| -------- | --------- | --------------------------------------------- |
| `sprite` | `sprite`  | The GameMaker sprite to render.               |
| `subimg` | `integer` | Current frame index to draw. Defaults to `0`. |


**🖌️ Rendering**

```js
function onDraw() {
    draw_sprite(self.sprite, self.subimg, ~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2));
}
```
Called automatically by the UI renderer every frame.

The sprite is drawn at the node's center position, defined as the midpoint between x1/x2 and y1/y2.
This ensures the image stays correctly aligned inside FlexPanel layouts, regardless of scaling or parent positioning.

**🧭 Behavior**

The node’s size is automatically set to match the sprite’s dimensions:

```js
setSize(sprite_get_width(sprite), sprite_get_height(sprite));
```


It can still be resized manually using standard layout functions:
```js
mySprite.setSize(64, 64);
```


Supports all event listeners (onClick, onMouseEnter, etc.) from UiNode.

**Notes**

- By default the node initializes its size to the sprite dimensions. If you pass explicit `width`/`height` via `style`, those values will override the automatic sizing.
- The `subimg` property controls the subimage/frame index drawn; change it at runtime to animate sprite frames inside UI.

**💡 Example**
```js
var icon = new UiSprite(spr_button_icon, {
    position: "absolute",
    left: 16,
    top: 16
}, {
    pointerEvents: true
});

icon.onClick(function() {
    show_debug_message("Icon clicked!");
});
```

This creates a clickable UI sprite positioned at (16,16) that logs a message when clicked.
