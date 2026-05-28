---
sidebar_position: 16.5
---

# UiToast

A floating notification manager and container that spawns `UiAlert` components. Toast alerts stack vertically in the top-right corner of the screen, ordered from top-to-bottom (newest at the top), and can be configured to dismiss automatically after a duration or manually via their close buttons.

---

**Constructor**

```js
new UiToast(style = {}, props = {})
```

**Parameters**

| Name    | Type     | Description                                                          |
| ------- | -------- | -------------------------------------------------------------------- |
| `style` | `struct` | FlexPanel style properties (width, top, right position defaults).     |
| `props` | `struct` | Base node configuration options (inherited from `UiNode`).           |

**Instance Properties**

| Property        | Type       | Description                                                      |
| --------------- | ---------- | ---------------------------------------------------------------- |
| `pointerEvents` | `boolean`  | Overridden to `false` so clicks pass through empty spaces.       |

**Instance Methods**

| Method | Returns | Description |
| --- | --- | --- |
| `show(message, type = "info", title = undefined, duration = 4000)` | `UiAlert` | Spawns a toast notification alert. Auto-dismisses if `duration > 0` (ms). |
| `success(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns a success toast notification. |
| `error(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns an error toast notification. |
| `warning(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns a warning toast notification. |
| `info(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns an informational toast notification. |

---

### Global Helper Functions

For quick and easy access from anywhere in the codebase without managing instances:

| Function | Returns | Description |
| --- | --- | --- |
| `ui_toast_show(message, type = "info", title = undefined, duration = 4000)` | `UiAlert` | Spawns a toast. Automatically initializes the global manager if needed. |
| `ui_toast_success(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns a success toast alert globally. |
| `ui_toast_error(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns an error toast alert globally. |
| `ui_toast_warning(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns a warning toast alert globally. |
| `ui_toast_info(message, title = undefined, duration = 4000)` | `UiAlert` | Spawns an informational toast alert globally. |

---

**Example**

```js
// Spawn various global notifications
ui_toast_info("Establishing server connection...");
ui_toast_success("Profile updated successfully!", "Saved", 3000);
ui_toast_warning("Disk space is low.", "Warning");
ui_toast_error("Failed to connect to the database.", "Connection Error", 6000);

// Spawning a toast using a custom, localized instance
var customToast = new UiToast({
    top: 50,
    right: 50,
    width: 360
});
global.UI.getOverlay().add(customToast);

customToast.success("Successfully completed operation on custom container.");
```

**Notes**

- Custom toast containers align elements vertically and place newest alerts at index `0` of the children tree.
- Alerts spawned via `UiToast` are automatically configured with `dismissible: true`.
- Fired timers dynamically call `destroy()` on individual alerts, safely removing their visual and event instances from the system context without leaving orphan nodes.
