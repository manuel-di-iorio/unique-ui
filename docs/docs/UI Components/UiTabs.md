---
sidebar_position: 17
---

# UiTabs

A tab navigation strip that switches between content panels. Supports both the classic `underline` style and a rounded `pills` style.

---

**Constructor**

```js
new UiTabs(items, style = {}, props = {})
```

**Parameters**

| Name    | Type     | Description                                                            |
| ------- | -------- | ---------------------------------------------------------------------- |
| `items` | `array`  | Array of tab descriptors: `{ label: string, content: UiNode \| undefined }`. |
| `style` | `struct` | FlexPanel layout style (width, marginBottom, etc.).                    |
| `props` | `struct` | Configuration: `selectedIndex`, `variant`, `onChange`.                 |

**Properties**

| Property        | Type       | Description                                                                 |
| --------------- | ---------- | --------------------------------------------------------------------------- |
| `items`         | `array`    | The tab descriptor array passed at construction.                            |
| `selectedIndex` | `number`   | Zero-based index of the currently active tab.                               |
| `variant`       | `string`   | Visual style: `"underline"` (default) or `"pills"`.                         |
| `onChange`      | `function` | Callback fired when the active tab changes: `function(index, label)`.       |
| `Strip`         | `UiNode`   | The horizontal row containing the tab buttons.                              |
| `ContentArea`   | `UiNode`   | The container that holds the content panels.                                |

**Methods**

| Method                | Returns | Description                                                          |
| --------------------- | ------- | -------------------------------------------------------------------- |
| `selectTab(index)`    | `void`  | Selects the tab at `index`, updates panels, and fires `onChange`.   |
| `add(node, tabIndex)` | `void`  | Assigns a `UiNode` as the content of tab at `tabIndex`.             |

**Example**

```js
// Build content panels
var panelA = new UiNode({ flexDirection: "column" });
panelA.add(new UiText("Overview content here.", {}, { color: #64748B }));

var panelB = new UiNode({ flexDirection: "column" });
panelB.add(new UiButton("Do something", {}, { variant: "primary" }));

// Underline variant (default)
var tabs = new UiTabs([
    { label: "Overview", content: panelA },
    { label: "Actions",  content: panelB }
], { width: "100%" }, {
    selectedIndex: 0,
    onChange: function(index, label) {
        show_debug_message("Active tab: " + label);
    }
});
parent.add(tabs);

// Pills variant
var pillTabs = new UiTabs([
    { label: "Home"    },
    { label: "Profile" }
], { width: "100%" }, { variant: "pills" });
parent.add(pillTabs);
```

**Notes**

- Content panels that are not active are hidden via `UiNode.hide()`.
- `selectTab()` calls `__buildTabs()` which recreates the strip and re-shows the correct panel; avoid calling it from within `onChange` to prevent recursion.
- All panels should be created **before** passing them in `items` so the layout engine can measure them correctly.
