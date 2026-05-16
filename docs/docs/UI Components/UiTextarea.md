---
sidebar_position: 8
---

A multiline editable text input component supporting selection, clipboard actions, undo/redo, cursor navigation, and scrolling.

**Constructor**

```js
UiTextarea(style = {}, props = {})
```

| Parameter | Type     | Description                       |
| --------- | -------- | --------------------------------- |
| `style`   | `struct` | UI styling overrides.             |
| `props`   | `struct` | Component properties (see below). |

**Macros**

| Macro                      | Default  | Description                             |
| -------------------------- | -------- | --------------------------------------- |
| `TEXTAREA_INITIAL_DELAY`   | `400` ms | Initial delay before key repeat starts. |
| `TEXTAREA_REPEAT_DELAY`    | `50` ms  | Delay between each key repeat.          |
| `TEXTAREA_CURSOR_BLINK`    | `500` ms | Cursor blinking interval.               |
| `TEXTAREA_UNDO_STACK_SIZE` | `100`    | Maximum undo/redo states stored.        |

**Properties**

| Property      | Type                     | Default        | Description                                               |
| ------------- | ------------------------ | -------------- | --------------------------------------------------------- |
| `label`       | `string`                 | `undefined`    | Optional label drawn above the textarea.                  |
| `value`       | `string`                 | `""`           | Initial multiline value.                                  |
| `valueGetter` | `function`               | `undefined`    | Function returning a dynamic external value to sync with. |
| `onChange`    | `function(value, input)` | empty function | Called whenever text value changes.                       |
| `onBlur`      | `function(value, input)` | empty function | Called when the textarea loses focus.                     |
| `maxLength`   | `real`                   | `4000`         | Maximum allowed text length.                              |
| `placeholder` | `string`                 | `undefined`    | Placeholder text shown when empty.                        |
| `lineHeight`  | `real`                   | `22`           | Pixel height used for each text line.                     |

**Internal Node: Input**

The textarea creates an internal node `self.Input` which handles input logic, rendering, scrolling, focus, selection, cursor state, and undo history.

**State Variables (Input)**

| Variable                         | Type     | Description                                  |
| -------------------------------- | -------- | -------------------------------------------- |
| `focused`                        | `bool`   | Whether the textarea is focused.             |
| `cursorPos`                      | `real`   | Current zero-based cursor index.             |
| `selectionStart`, `selectionEnd` | `real`   | Selection range in characters.               |
| `scrollTop`, `scrollLeft`        | `real`   | Vertical and horizontal text scroll offsets. |
| `undoStack`, `redoStack`         | `array`  | Undo/redo history.                           |
| `keyRepeat`                      | `struct` | State for key repeat timing.                 |
| `isDragging`                     | `bool`   | Whether the user is dragging to select text. |
| `showCursor`                     | `bool`   | Whether the cursor is visible for blinking.  |

**Methods (Input)**

| Method                         | Description                                                      |
| ------------------------------ | ---------------------------------------------------------------- |
| `focus()`                      | Focuses the textarea and prepares to receive input.              |
| `blur()`                       | Removes focus and fires `onBlur`.                                |
| `insertText(newText)`          | Inserts text at the cursor and preserves newline characters.     |
| `getSelectedText()`            | Returns the selected text, including line breaks.                |
| `deleteSelected()`             | Deletes selected text across one or more lines.                  |
| `getLines()`                   | Parses the current value into line structs.                      |
| `getMouseCursorPos(mouseX, mouseY)` | Returns cursor index for a GUI-space mouse coordinate.      |
| `moveVertical(direction, shift)` | Moves the cursor up or down while preserving preferred column.  |
| `updateScrollOffset()`         | Keeps the cursor visible horizontally and vertically.            |
| `handleMouseDrag()`            | Updates selection and auto-scrolls while dragging near edges.    |
| `saveUndoState()`              | Saves the current state into the undo stack.                     |
| `performUndo()`                | Restores the last undo state.                                    |
| `performRedo()`                | Restores the last redo state.                                    |

**Keyboard shortcuts**

| Shortcut                         | Action                                      |
| -------------------------------- | ------------------------------------------- |
| `Ctrl + Z`                       | Undo                                        |
| `Ctrl + Shift + Z` or `Ctrl + Y` | Redo                                        |
| `Ctrl + A`                       | Select all                                  |
| `Ctrl + C`                       | Copy selection                              |
| `Ctrl + X`                       | Cut selection                               |
| `Ctrl + V`                       | Paste clipboard text, preserving newlines   |
| `Enter`                          | Insert a new line                           |
| `Left` / `Right`                 | Move cursor by character                    |
| `Up` / `Down`                    | Move cursor between lines                   |
| `Shift + Arrow`                  | Extend selection                            |
| `Ctrl + Left/Right`              | Move cursor by word                         |
| `Home` / `End`                   | Move to start or end of the current line    |
| `Ctrl + Home/End`                | Move to start or end of the whole value     |
| `Backspace` / `Delete`           | Delete text before or after the cursor      |

**Behavior Summary**

- Set an explicit `height` in the style so the multiline editing area has room to render and scroll.
- Text is clipped inside the input bounds and scrolls with the cursor, mouse wheel, or drag selection near the edges.
- Mouse selection can span multiple lines.
- Clipboard paste keeps multiline content and normalizes CRLF line endings to `\n`.
- The component is intentionally text-only; numeric `format`, `min`, and `max` constraints remain part of `UiTextbox`.
