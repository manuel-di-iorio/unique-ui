---
sidebar_position: 16
---

# UiAlert

A contextual feedback banner that communicates important information to the user. Supports four semantic types, an optional title, and a dismissible close button.

---

**Constructor**

```js
new UiAlert(message, style = {}, props = {})
```

**Parameters**

| Name      | Type     | Description                                          |
| --------- | -------- | ---------------------------------------------------- |
| `message` | `string` | The main alert message to display.                   |
| `style`   | `struct` | FlexPanel layout style (width, marginBottom, etc.).  |
| `props`   | `struct` | Alert configuration (type, title, dismissible, …).  |

**Properties**

| Property       | Type       | Description                                                           |
| -------------- | ---------- | --------------------------------------------------------------------- |
| `alertType`    | `string`   | Semantic type: `"info"`, `"success"`, `"warning"`, `"error"`.        |
| `alertTitle`   | `string`   | Optional bold title rendered above the message (`undefined` = none). |
| `message`      | `string`   | The alert body text.                                                  |
| `dismissible`  | `boolean`  | Whether a close (×) button is rendered (default `false`).             |
| `onDismiss`    | `function` | Callback fired when the dismiss button is clicked.                    |

**Methods**

| Method                 | Returns | Description                                      |
| ---------------------- | ------- | ------------------------------------------------ |
| `setType(type)`        | `void`  | Changes the alert type and redraws.              |
| `setMessage(message)`  | `void`  | Updates the body text and requests a layout update. |

**Example**

```js
// Basic types
parent.add(new UiAlert("Saved successfully.", { marginBottom: 12 }, { type: "success", title: "Done" }));
parent.add(new UiAlert("Update available.",   { marginBottom: 12 }, { type: "info"    }));
parent.add(new UiAlert("Storage is full.",    { marginBottom: 12 }, { type: "warning" }));
parent.add(new UiAlert("Connection failed.",  { marginBottom: 12 }, { type: "error",  title: "Error" }));

// Dismissible with callback
var alert = new UiAlert("Click × to close.", { marginBottom: 12 }, {
    type: "warning",
    dismissible: true,
    onDismiss: function() { show_debug_message("Alert dismissed"); }
});
parent.add(alert);
```

**Type Palette**

| Type      | Background  | Border     | Text       |
| --------- | ----------- | ---------- | ---------- |
| `info`    | `#EFF6FF`   | `#BFDBFE`  | `#1E40AF`  |
| `success` | `#F0FDF4`   | `#86EFAC`  | `#166534`  |
| `warning` | `#FFFBEB`   | `#FCD34D`  | `#92400E`  |
| `error`   | `#FEF2F2`   | `#FECACA`  | `#991B1B`  |

**Notes**

- Default width is `"100%"`.
- A colored left accent bar is drawn to reinforce the alert type.
- The dismiss button calls `hide()` on the alert node automatically; no external state management required.
