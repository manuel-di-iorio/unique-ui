---
sidebar_position: 6
---

A flexible and interactive dropdown menu component for selecting from a list of items.  
`UiDropdown` supports dynamic data sources, search filtering, and automatic positioning within the viewport.

```gml
UiDropdown(style = {}, props = {})
```

**Description**

`UiDropdown` provides a composable dropdown selector similar to HTML `<select>` elements.

It allows users to choose an option from a list, dynamically populate items through getters, and optionally display a label or a search bar.

The dropdown consists of:

- A main container node (the label and input button)

- An input button (UiDropdown.Input) that opens/closes the list

- A popup list (UiDropdown.List) containing selectable items (and an optional search field)

---

**Properties**

| Property      | Type                        | Default        | Description                                                       |
| ------------- | --------------------------- | -------------- | ----------------------------------------------------------------- |
| `value`       | `any`                       | `undefined`    | Currently selected value.                                         |
| `items`       | `array<struct>`             | `[]`           | List of selectable items (`[{label, value}, ...]`).               |
| `itemsGetter` | `function`                  | `undefined`    | Optional function returning a filtered list of items dynamically. |
| `label`       | `string`                    | `undefined`    | Text label displayed next to the dropdown.                        |
| `onChange`    | `function(value, dropdown)` | Empty function | Called when the user selects a new value.                         |
| `List`        | `UiNode`                    | `undefined`    | Active list node (created when the dropdown opens).               |
| `Input`       | `UiButton`                  | *auto-created* | The clickable button used to open/close the dropdown.             |
| `search`      | `string`                    | `undefined`    | Placeholder for the optional search bar (enables filtering).      |

**Structure**

| Node                     | Type                     | Purpose                                            |
| ------------------------ | ------------------------ | -------------------------------------------------- |
| `UiDropdown`             | `UiNode`                 | Root container (label + input).                    |
| `UiDropdown.Input`       | `UiButton`               | Clickable button that toggles the list visibility. |
| `UiDropdown.List`        | `UiNode`                 | Floating panel containing item nodes.              |
| `UiDropdown.List.Items`  | `UiNode`                 | Scrollable container of selectable options.        |
| `UiDropdown.List.Search` | `UiTextbox` *(optional)* | Input field for live filtering via `itemsGetter`.  |

**Methods**

| Method                       | Description                                                                                          |
| ---------------------------- | ---------------------------------------------------------------------------------------------------- |
| **`createList()`**           | Creates and opens the dropdown list. Builds items and positions the list below (or above if needed). |
| **`closeList()`**            | Destroys the list node and closes the dropdown.                                                      |
| **`List.computePosition()`** | Ensures the list stays aligned with the dropdown input and within screen bounds.                     |
| **`List.createItems()`**     | Builds all dropdown items dynamically from `items` or `itemsGetter`.                                 |
| **`onStep()`**               | Updates the `items` array from `itemsGetter` and validates the current selection.                    |
| **`onDraw()`**               | Renders the label (if defined).                                                                      |
| **`Input.onDraw()`**         | Draws the button background, arrow icon, divider, and current selection text.                        |

---

**Behavior**

- When the input button is clicked, the list opens dynamically as a floating panel.

- Clicking outside the list automatically closes it.
 
- If the selected value becomes invalid (e.g. item removed), the dropdown resets to undefined.
 
- The onChange callback fires whenever a new item is selected.
 
- When itemsGetter is provided, the dropdown can auto-refresh its contents each frame or via the search field.
 
- The dropdown adjusts its position automatically to avoid overflowing the screen.

**Search Support**

If the `search` property is set, the dropdown will include a text input (`UiTextbox`) at the top of the list.

Typing in this field calls:

```js
items = itemsGetter(searchValue)
```

This allows dynamic filtering, ideal for asset browsers or large data lists.

**Visual Notes**

- Arrow icon: drawn using sprUiDropdownArrow on the right side.

- Hovered items: highlighted with global.UI_COL_INSPECTOR_BG.

- Selected item: drawn with a filled rectangle.

- List background: uses global.UI_COL_DROPDOWN_LIST_BG.

- Search highlight: scrollbar uses global.UI_COL_CHECKBOX_HOVER.

---

**Examples**

```js
// Basic dropdown with static items
var dd = new UiDropdown({}, {
    label: "Language",
    items: [
        { label: "English", value: "en" },
        { label: "Italiano", value: "it" },
        { label: "Deutsch", value: "de" }
    ],
    onChange: function(value, dropdown) {
        global.lang = value;
    }
});

// Dynamic dropdown with search
var assetDropdown = new UiDropdown({}, {
    label: "Model",
    search: "Search asset...",
    itemsGetter: function(query) {
        return array_filter(global.assetList, function(a) {
            return string_pos(string_lower(query), string_lower(a.label)) > 0;
        });
    },
    onChange: function(value) {
        show_debug_message("Selected asset: " + string(value));
    }
});
```

**Performance Notes**

Performance Notes

- Dropdown lists are instantiated on demand and destroyed when closed, saving memory.

- Scrollbars are auto-enabled for long lists.
