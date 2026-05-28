---
sidebar_position: 18
---

A color picker similar to the HTML5 `<input type="color">` control.  
Click the preview swatch to open a panel with an HSV selector and a hex text field.

```gml
UiColorPicker(style = {}, props = {})
```

**Description**

`UiColorPicker` lets users choose a color through a compact trigger button that shows the current color.  
Opening the panel reveals:

- A saturation/brightness area (two-dimensional picker)
- A hue slider
- A live preview swatch and hex input (`#RRGGBB`) for typing or copying the value

---

**Properties**

| Property      | Type                          | Default        | Description                                              |
| ------------- | ----------------------------- | -------------- | -------------------------------------------------------- |
| `value`       | `color` (real)                | `#3B82F6`      | Currently selected color.                                |
| `label`       | `string`                      | `undefined`    | Optional label shown to the left of the trigger.         |
| `onChange`    | `function(color, picker)`     | Empty function | Called when the color changes.                           |
| `valueGetter` | `function`                    | `undefined`    | Optional external source of truth for `value`.           |
| `Trigger`     | `UiNode`                      | *auto-created* | Clickable color preview button.                          |
| `Panel`       | `UiNode`                      | `undefined`    | Popup panel (created when opened).                       |

**Structure**

| Node                         | Type        | Purpose                                      |
| ---------------------------- | ----------- | -------------------------------------------- |
| `UiColorPicker`              | `UiNode`    | Root container (label + trigger).              |
| `UiColorPicker.Trigger`      | `UiNode`    | Swatch button that toggles the panel.          |
| `UiColorPicker.Panel`        | `UiNode`    | Floating popup on the UI overlay.            |
| `UiColorPicker.Panel.SvArea` | `UiNode`    | Saturation/brightness drag area.             |
| `UiColorPicker.Panel.HueBar` | `UiNode`    | Hue rainbow slider.                          |
| `UiColorPicker.Panel.Preview`| `UiNode`    | Larger preview of the selected color.        |
| `UiColorPicker.Panel.HexInput` | `UiTextbox` | Hex string editor (`#RRGGBB`).            |

**Methods**

| Method              | Description                                                |
| ------------------- | ---------------------------------------------------------- |
| **`openPanel()`**   | Creates and shows the picker panel on the overlay.         |
| **`closePanel()`**  | Destroys the panel and closes the popup.                     |
| **`setColor(col)`** | Sets `value`, syncs HSV/hex, optionally fires `onChange`.  |
| **`applyHsv()`**    | Recomputes `value` from internal `hue`/`saturation`/`brightness`. |

---

**Behavior**

- Clicking the trigger toggles the panel open or closed.
- Clicking outside the panel and trigger closes it (same pattern as `UiDropdown`).
- Dragging in the SV area or hue bar updates the color in real time.
- The hex field accepts `#RRGGBB`, `RRGGBB`, or shorthand `#RGB`.
- Invalid hex on blur is reverted to the current color.
- `onChange` fires only when the color actually changes.

---

**Examples**

```js
// Basic picker with label
var picker = new UiColorPicker({ marginBottom: 16 }, {
    label: "Background",
    value: global.UI_COL_PRIMARY,
    onChange: function(col, cp) {
        global.myBgColor = col;
    }
});

// Read hex for export
show_debug_message(__uui_color_to_hex(picker.value));
```

**Performance Notes**

- The panel is created on demand and destroyed when closed.
- SV and hue areas use gradient rectangles instead of per-pixel loops.
