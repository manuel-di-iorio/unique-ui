---
sidebar_position: 6
---

Creates a radio button component for mutually exclusive selections.

`UiRadio` is a specialized version of `UiCheckbox` that defaults to the "radio" variant. It is designed to be used in groups where only one option can be selected at a time.

```gml
UiRadio(style = {}, props = {})
```

**Description**

UiRadio provides a circular selection element. When multiple `UiRadio` components share the same `group` property and the same parent node, selecting one will automatically deselect the others in that group.

---

**Properties**

| Property   | Type                     | Default        | Description                                                                 |
| ---------- | ------------------------ | -------------- | --------------------------------------------------------------------------- |
| `value`    | `bool`                   | `false`        | Current state of the radio (selected or not).                               |
| `label`    | `string`                 | `undefined`    | Optional label text displayed next to the radio button.                     |
| `group`    | `string`                 | `undefined`    | The name of the radio group. Essential for mutual exclusion.                |
| `onChange` | `function(input, value)` | Empty function | Callback executed when the radio state changes.                             |

---

**Examples**

```js
// Group of radio buttons
var container = new UiNode({ flexDirection: "column" });

container.add(new UiRadio({}, { 
    label: "Option 1", 
    group: "settings", 
    value: true 
}));

container.add(new UiRadio({}, { 
    label: "Option 2", 
    group: "settings" 
}));
```

**Visual Notes**

- Renders as a circle instead of a square.
- When selected, a smaller solid circle appears in the center.
- Inherits all styling and behavior from [UiCheckbox](UiCheckbox.md).
