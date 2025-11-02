---
sidebar_position: 7
---

A single-line editable text input component supporting selection, copy/paste, undo/redo, cursor blinking, and numeric constraints.

**Constructor**

```js
UiTextbox(style = {}, props = {})
```

| Parameter | Type     | Description                       |
| --------- | -------- | --------------------------------- |
| `style`   | `struct` | UI styling overrides.             |
| `props`   | `struct` | Component properties (see below). |


**Macros**

| Macro                     | Default  | Description                                |
| ------------------------- | -------- | ------------------------------------------ |
| `TEXTBOX_INITIAL_DELAY`   | `400` ms | Initial delay before key repeat starts.    |
| `TEXTBOX_REPEAT_DELAY`    | `50` ms  | Delay between each key repeat.             |
| `TEXTBOX_CURSOR_BLINK`    | `500` ms | Cursor blinking interval.                  |
| `TEXTBOX_UNDO_STACK_SIZE` | `100`    | Maximum number of undo/redo states stored. |

**Properties**

| Property      | Type                               | Default        | Description                                               |
| ------------- | ---------------------------------- | -------------- | --------------------------------------------------------- |
| `label`       | `string`                           | `undefined`    | Optional label drawn before the textbox.                  |
| `value`       | `string`                           | `""`           | The initial value of the textbox.                         |
| `valueGetter` | `function`                         | `undefined`    | Function returning a dynamic external value to sync with. |
| `onChange`    | `function(value, input)`           | empty function | Called whenever text value changes.                       |
| `onBlur`      | `function(value, input)`           | empty function | Called when textbox loses focus.                          |
| `maxLength`   | `real`                             | `255`          | Maximum allowed text length.                              |
| `format`      | `"string"`, `"integer"`, `"float"` | `"string"`     | Input format constraint.                                  |
| `min`         | `real`                             | `undefined`    | Minimum numeric value (if numeric format).                |
| `max`         | `real`                             | `undefined`    | Maximum numeric value (if numeric format).                |
| `negative`    | `bool`                             | `false`        | Whether negative values are allowed (numeric).            |
| `placeholder` | `string`                           | `undefined`    | Placeholder text shown when empty/unfocused.              |

---

**Internal Node: Input**

The textbox creates an internal node `self.Input` which handles input logic, rendering, and state management (focus, selection, cursor, undo stack, etc).

**State Variables (Input)**

| Variable                         | Type     | Description                                             |
| -------------------------------- | -------- | ------------------------------------------------------- |
| `focused`                        | `bool`   | Whether the textbox is focused.                         |
| `cursorPos`                      | `real`   | Current cursor index.                                   |
| `selectionStart`, `selectionEnd` | `real`   | Selection range in characters.                          |
| `scrollOffset`                   | `real`   | Horizontal scroll offset for long text.                 |
| `undoStack`, `redoStack`         | `array`  | Undo/redo history.                                      |
| `keyRepeat`                      | `struct` | State for key repeat timing.                            |
| `isDragging`                     | `bool`   | Whether the user is dragging to select text.            |
| `showCursor`                     | `bool`   | Whether the cursor is currently visible (for blinking). |

**Methods (Main)**

| Method                                           | Description                                                                    |
| ------------------------------------------------ | ------------------------------------------------------------------------------ |
| `focus()`                                        | Focuses the textbox and prepares to receive input.                             |
| `blur()`                                         | Removes focus and validates value (for numeric fields).                        |
| `updateScrollOffset()`                           | Updates scroll offset to keep cursor visible.                                  |
| `getSelectedText()`                              | Returns the currently selected text.                                           |
| `deleteSelected()`                               | Deletes selected text and updates cursor.                                      |
| `insertText(newText)`                            | Inserts text at the current cursor position, respecting max length and format. |
| `handleKeyInput()`                               | Processes keyboard input and shortcuts.                                        |
| `handleMouseDrag()`                              | Updates selection while dragging.                                              |
| `handleKeyRepeat()`                              | Checks if the current key should repeat.                                       |
| `updateKeyRepeat()`                              | Updates repeat key state based on input.                                       |
| `saveUndoState()`                                | Saves the current input state into the undo stack.                             |
| `performUndo()`                                  | Restores the last undo state.                                                  |
| `performRedo()`                                  | Restores the last redo state.                                                  |
| `getMouseCursorPos(mouseX)`                      | Returns cursor index for a given mouse X coordinate.                           |
| `findWordStart(pos)`                             | Finds the start index of the current word.                                     |
| `findWordEnd(pos)`                               | Finds the end index of the current word.                                       |
| `resetCursorBlink()`                             | Resets the cursor blinking timer.                                              |
| `isValidCharacter(char, currentText, cursorPos)` | Checks if a character is valid given the input format.                         |
| `validateValue(value)`                           | Validates an entire value against min/max and format rules.                    |

**Keyboard shortcuts**

| Shortcut                         | Action                             |
| -------------------------------- | ---------------------------------- |
| `Ctrl + Z`                       | Undo                               |
| `Ctrl + Shift + Z` or `Ctrl + Y` | Redo                               |
| `Ctrl + A`                       | Select all                         |
| `Ctrl + C`                       | Copy selection                     |
| `Ctrl + X`                       | Cut selection                      |
| `Ctrl + V`                       | Paste clipboard text               |
| `←` / `→`                        | Move cursor                        |
| `Shift + ←/→`                    | Extend selection                   |
| `Ctrl + ←/→`                     | Move cursor by word                |
| `Home / End`                     | Move to start or end               |
| `Backspace` / `Delete`           | Delete text before or after cursor |

**Drawing**

| Layer       | Description                                       |
| ----------- | ------------------------------------------------- |
| Background  | Filled rectangle using `global.UI_COL_INPUT_BG`.  |
| Border      | Outline using `global.UI_COL_BOX`.                |
| Selection   | Semi-transparent highlight when selecting text.   |
| Text        | Drawn with `fText` font, horizontally scrollable. |
| Placeholder | Faded text when empty/unfocused.                  |
| Cursor      | Vertical line when focused and visible.           |

**Behavior Summary**

- Focus handling: gains focus on click, loses it on outside click.
- Undo/Redo system: keeps a capped stack for state restoration.
- Selection logic: supports click-drag, double-click word select, and keyboard extension.
- Key repeat system: mimics native OS key repeat delays.
- Numeric validation: enforces min, max, integer, and float formats.
- Clipboard integration: supports cut/copy/paste with system clipboard.
- Placeholder rendering: semi-transparent when inactive.
