---
sidebar_position: 15
---

# UiBadge

A small, pill-shaped label used to display statuses, counts, or categories. Supports six semantic color variants and an optional dot-only mode.

---

**Constructor**

```js
new UiBadge(text, style = {}, props = {})
```

**Parameters**

| Name    | Type     | Description                                   |
| ------- | -------- | --------------------------------------------- |
| `text`  | `string` | Label to display inside the badge.            |
| `style` | `struct` | FlexPanel layout style (width, height, etc.). |
| `props` | `struct` | Badge configuration (variant, dot).           |

**Properties**

| Property  | Type      | Description                                                                          |
| --------- | --------- | ------------------------------------------------------------------------------------ |
| `text`    | `string`  | The badge label.                                                                     |
| `variant` | `string`  | Color scheme: `"default"`, `"primary"`, `"success"`, `"warning"`, `"danger"`, `"info"`. |
| `dot`     | `boolean` | When `true`, renders a small colored circle with no text (default `false`).          |

**Methods**

| Method                  | Returns | Description                                           |
| ----------------------- | ------- | ----------------------------------------------------- |
| `setText(text)`         | `void`  | Updates the badge label and resizes the node.         |
| `setVariant(variant)`   | `void`  | Changes the color variant and requests a redraw.      |

**Example**

```js
// Simple variants
var b1 = new UiBadge("New",     { marginRight: 8 }, { variant: "primary" });
var b2 = new UiBadge("Success", { marginRight: 8 }, { variant: "success" });
var b3 = new UiBadge("Error",   {},                 { variant: "danger"  });
row.add(b1, b2, b3);

// Dot indicator (no label)
var dot = new UiBadge("", { marginRight: 8 }, { variant: "success", dot: true });
row.add(dot);

// Inline with text
var statusRow = new UiNode({ flexDirection: "row", alignItems: "center" });
statusRow.add(new UiText("Status", { marginRight: 8 }));
statusRow.add(new UiBadge("Online", {}, { variant: "success" }));
```

**Variant Colors**

| Variant     | Background  | Text       |
| ----------- | ----------- | ---------- |
| `default`   | `#E2E8F0`   | `#475569`  |
| `primary`   | UI primary  | White      |
| `success`   | `#16A34A`   | White      |
| `warning`   | `#D97706`   | White      |
| `danger`    | `#DC2626`   | White      |
| `info`      | `#0EA5E9`   | White      |

**Notes**

- Auto-sizes to fit text content if no explicit `width` is provided.
- In `dot` mode the badge renders as a 10×10 filled circle; `text` is ignored.
