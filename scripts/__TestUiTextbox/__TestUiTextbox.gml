// ============================================================
//  UiTextbox Tests
// ============================================================

ui_test_suite("UiTextbox", function() {
    
    // ── Creation ────────────────────────────────────────────
    
    ui_test("value defaults to empty string", function() {
        var tb = new UiTextbox({}, {});
        assert_equal(tb.value, "", "default value");
    });
    
    ui_test("value set from props", function() {
        var tb = new UiTextbox({}, { value: "Hello" });
        assert_equal(tb.value, "Hello", "value from props");
    });
    
    ui_test("Input sub-node exists", function() {
        var tb = new UiTextbox({}, {});
        assert_not_undefined(tb.Input, "Input exists");
        assert_true(tb.Input.isUiNode, "Input is UiNode");
    });
    
    ui_test("Input.focused defaults to false", function() {
        var tb = new UiTextbox({}, {});
        assert_false(tb.Input.focused, "not focused on create");
    });
    
    ui_test("maxLength defaults to 255", function() {
        var tb = new UiTextbox({}, {});
        assert_equal(tb.maxLength, 255, "maxLength = 255");
    });
    
    ui_test("maxLength can be overridden via props", function() {
        var tb = new UiTextbox({}, { maxLength: 10 });
        assert_equal(tb.maxLength, 10, "maxLength = 10");
    });
    
    ui_test("format defaults to string", function() {
        var tb = new UiTextbox({}, {});
        assert_equal(tb.format, "string", "format = string");
    });
    
    ui_test("placeholder stored from props", function() {
        var tb = new UiTextbox({}, { placeholder: "Type here..." });
        assert_equal(tb.placeholder, "Type here...", "placeholder");
    });
    
    ui_test("negative defaults to false", function() {
        var tb = new UiTextbox({}, {});
        assert_false(tb.negative, "negative = false");
    });
    
    // ── insertText ───────────────────────────────────────────
    
    ui_test("insertText appends text at cursor position 0", function() {
        var tb  = new UiTextbox({}, {});
        var inp = tb.Input;
        inp.focused = true;
        inp.cursorPos = 0;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.insertText("Hi");
        assert_equal(tb.value, "Hi", "value after insertText");
        assert_equal(inp.cursorPos, 2, "cursor moved to end");
    });
    
    ui_test("insertText respects maxLength", function() {
        var tb  = new UiTextbox({}, { maxLength: 5 });
        var inp = tb.Input;
        inp.focused = true;
        inp.cursorPos = 0;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.insertText("Hello World");
        assert_equal(string_length(tb.value), 5, "truncated to maxLength");
    });
    
    ui_test("insertText at middle of text inserts at cursor", function() {
        var tb  = new UiTextbox({}, { value: "Helo" });
        var inp = tb.Input;
        inp.focused = true;
        inp.cursorPos = 3;
        inp.selectionStart = 3;
        inp.selectionEnd   = 3;
        inp.insertText("l");
        assert_equal(tb.value, "Hello", "inserted at position 3");
    });
    
    ui_test("insertText calls onChange", function() {
        var state = { called_with: "" };
        var tb  = new UiTextbox({}, { onChange: method(state, function(v) { called_with = v; }) });
        var inp = tb.Input;
        inp.focused = true;
        inp.cursorPos = 0;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.insertText("X");
        assert_equal(state.called_with, "X", "onChange called with new value");
    });
    
    // ── Selection ────────────────────────────────────────────
    
    ui_test("getSelectedText returns correct substring", function() {
        var tb  = new UiTextbox({}, { value: "Hello World" });
        var inp = tb.Input;
        inp.selectionStart = 0;
        inp.selectionEnd   = 5;
        var sel = inp.getSelectedText();
        assert_equal(sel, "Hello", "selected text = 'Hello'");
    });
    
    ui_test("getSelectedText handles reversed selection", function() {
        var tb  = new UiTextbox({}, { value: "Hello World" });
        var inp = tb.Input;
        inp.selectionStart = 5;
        inp.selectionEnd   = 0;
        var sel = inp.getSelectedText();
        assert_equal(sel, "Hello", "handles reversed selection");
    });
    
    ui_test("getSelectedText returns empty string when no selection", function() {
        var tb  = new UiTextbox({}, { value: "Hello" });
        var inp = tb.Input;
        inp.selectionStart = 3;
        inp.selectionEnd   = 3;
        var sel = inp.getSelectedText();
        assert_equal(sel, "", "no selection = empty string");
    });
    
    ui_test("deleteSelected removes selected text and moves cursor", function() {
        var tb  = new UiTextbox({}, { value: "Hello World" });
        var inp = tb.Input;
        inp.selectionStart = 5;
        inp.selectionEnd   = 11;
        var deleted = inp.deleteSelected();
        assert_true(deleted, "deleteSelected returns true");
        assert_equal(tb.value, "Hello", "selection deleted");
        assert_equal(inp.cursorPos, 5, "cursor at selection start");
    });
    
    ui_test("deleteSelected returns false when no selection", function() {
        var tb  = new UiTextbox({}, { value: "Hello" });
        var inp = tb.Input;
        inp.selectionStart = 2;
        inp.selectionEnd   = 2;
        var deleted = inp.deleteSelected();
        assert_false(deleted, "no deletion when no selection");
    });
    
    // ── Undo/Redo ────────────────────────────────────────────
    
    ui_test("saveUndoState pushes state onto undoStack", function() {
        var tb  = new UiTextbox({}, { value: "Hello" });
        var inp = tb.Input;
        inp.cursorPos = 3;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.saveUndoState();
        assert_equal(array_length(inp.undoStack), 1, "1 item in undoStack");
        assert_equal(inp.undoStack[0].text, "Hello", "correct text saved");
    });
    
    ui_test("saveUndoState does not duplicate identical states", function() {
        var tb  = new UiTextbox({}, { value: "Hello" });
        var inp = tb.Input;
        inp.cursorPos = 3;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.saveUndoState();
        inp.saveUndoState(); // same state
        assert_equal(array_length(inp.undoStack), 1, "no duplicate");
    });
    
    ui_test("performUndo restores previous value", function() {
        var tb  = new UiTextbox({}, { value: "Hello" });
        var inp = tb.Input;
        inp.cursorPos = 5;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.saveUndoState();
        tb.value = "Hello World";
        inp.cursorPos = 11;
        inp.performUndo();
        assert_equal(tb.value, "Hello", "undo restores 'Hello'");
    });
    
    ui_test("performRedo restores redone value", function() {
        var tb  = new UiTextbox({}, { value: "Hello" });
        var inp = tb.Input;
        inp.cursorPos = 5;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.saveUndoState();
        tb.value = "Hello World";
        inp.cursorPos = 11;
        inp.performUndo();
        inp.performRedo();
        assert_equal(tb.value, "Hello World", "redo restores 'Hello World'");
    });
    
    ui_test("insertText clears redo stack", function() {
        var tb  = new UiTextbox({}, { value: "Hello" });
        var inp = tb.Input;
        inp.focused = true;
        inp.cursorPos = 5;
        inp.selectionStart = 0;
        inp.selectionEnd   = 0;
        inp.saveUndoState();
        // push something to redo
        inp.redoStack = [{ text: "xyz", cursorPos: 3, selectionStart: 0, selectionEnd: 0 }];
        inp.insertText("!");
        assert_equal(array_length(inp.redoStack), 0, "redo stack cleared after new input");
    });
    
    ui_test("undoStack limited to TEXTBOX_UNDO_STACK_SIZE", function() {
        var tb  = new UiTextbox({}, { value: "A" });
        var inp = tb.Input;
        inp.cursorPos = 0; inp.selectionStart = 0; inp.selectionEnd = 0;
        // Fill past the limit
        repeat (TEXTBOX_UNDO_STACK_SIZE + 5) {
            tb.value += "x";
            inp.saveUndoState();
        }
        assert_less(array_length(inp.undoStack), TEXTBOX_UNDO_STACK_SIZE + 5,
            "undo stack does not grow unbounded");
    });
    
    // ── Format validation ────────────────────────────────────
    
    ui_test("integer format - digit is valid", function() {
        var tb  = new UiTextbox({}, { format: "integer" });
        var inp = tb.Input;
        assert_true(inp.isValidCharacter("5", "", 0), "digit valid for integer");
    });
    
    ui_test("integer format - letter is invalid", function() {
        var tb  = new UiTextbox({}, { format: "integer" });
        var inp = tb.Input;
        assert_false(inp.isValidCharacter("a", "", 0), "letter invalid for integer");
    });
    
    ui_test("integer format - minus valid at pos 0 with negative=true", function() {
        var tb  = new UiTextbox({}, { format: "integer", negative: true });
        var inp = tb.Input;
        assert_true(inp.isValidCharacter("-", "", 0), "minus valid at pos 0");
    });
    
    ui_test("integer format - minus invalid at pos 1", function() {
        var tb  = new UiTextbox({}, { format: "integer", negative: true });
        var inp = tb.Input;
        assert_false(inp.isValidCharacter("-", "1", 1), "minus invalid at pos 1");
    });
    
    ui_test("integer format - minus invalid when negative=false", function() {
        var tb  = new UiTextbox({}, { format: "integer", negative: false });
        var inp = tb.Input;
        assert_false(inp.isValidCharacter("-", "", 0), "minus invalid when negative=false");
    });
    
    ui_test("float format - digit is valid", function() {
        var tb  = new UiTextbox({}, { format: "float" });
        var inp = tb.Input;
        assert_true(inp.isValidCharacter("3", "", 0), "digit valid for float");
    });
    
    ui_test("float format - first dot is valid", function() {
        var tb  = new UiTextbox({}, { format: "float" });
        var inp = tb.Input;
        assert_true(inp.isValidCharacter(".", "", 0), "first dot valid");
    });
    
    ui_test("float format - second dot is invalid", function() {
        var tb  = new UiTextbox({}, { format: "float" });
        var inp = tb.Input;
        assert_false(inp.isValidCharacter(".", "1.", 1), "second dot invalid");
    });
    
    ui_test("string format - all printable chars valid", function() {
        var tb  = new UiTextbox({}, { format: "string" });
        var inp = tb.Input;
        assert_true(inp.isValidCharacter("a", "", 0), "letter valid for string");
        assert_true(inp.isValidCharacter("!", "", 0), "symbol valid for string");
        assert_true(inp.isValidCharacter("5", "", 0), "digit valid for string");
    });
    
    // ── Cursor movement ──────────────────────────────────────
    
    ui_test("cursorPos starts at 0", function() {
        var tb = new UiTextbox({}, {});
        assert_equal(tb.Input.cursorPos, 0, "cursor at 0");
    });
    
    ui_test("selectionStart and selectionEnd start at 0", function() {
        var tb = new UiTextbox({}, {});
        assert_equal(tb.Input.selectionStart, 0, "selectionStart = 0");
        assert_equal(tb.Input.selectionEnd,   0, "selectionEnd = 0");
    });
    
    ui_test("scrollOffset starts at 0", function() {
        var tb = new UiTextbox({}, {});
        assert_equal(tb.Input.scrollOffset, 0, "scrollOffset = 0");
    });
    
    // ── findWordStart / findWordEnd ──────────────────────────
    
    ui_test("findWordStart returns 0 for position at start", function() {
        var tb  = new UiTextbox({}, { value: "Hello World" });
        var inp = tb.Input;
        var result = inp.findWordStart(0);
        assert_equal(result, 0, "word start at 0");
    });
    
    ui_test("findWordEnd returns end of word", function() {
        var tb  = new UiTextbox({}, { value: "Hello World" });
        var inp = tb.Input;
        var result = inp.findWordEnd(0);
        assert_equal(result, 5, "word end at 5 for 'Hello'");
    });
    
    ui_test("findWordStart stops at space", function() {
        var tb  = new UiTextbox({}, { value: "Hello World" });
        var inp = tb.Input;
        // Starting from position 8 (inside 'World')
        var result = inp.findWordStart(8);
        // Should stop at the space (position 5)
        assert_equal(result, 6, "word start of 'World' at pos 6");
    });
    
    // ── onBlur cleanup ───────────────────────────────────────
    
    ui_test("onBlur sets focused = false", function() {
        var tb  = new UiTextbox({}, {});
        var inp = tb.Input;
        inp.focused = true;
        inp.onBlur();
        assert_false(inp.focused, "focused = false after onBlur");
    });
    
    ui_test("onBlur for integer format - empty becomes '0'", function() {
        var tb  = new UiTextbox({}, { format: "integer" });
        var inp = tb.Input;
        inp.focused  = true;
        tb.value     = "";
        inp.onBlur();
        assert_equal(tb.value, "0", "empty integer → '0'");
    });
    
    ui_test("onBlur for float format - clamps to max if exceeded", function() {
        var tb  = new UiTextbox({}, { format: "float", max: 10 });
        var inp = tb.Input;
        inp.focused = true;
        tb.value    = "99.5";
        inp.onBlur();
        assert_equal(real(tb.value), 10, "clamped to max=10");
    });
    
    ui_test("onBlur for float format - clamps to min if below", function() {
        var tb  = new UiTextbox({}, { format: "float", min: 0 });
        var inp = tb.Input;
        inp.focused = true;
        tb.value    = "-5.0";
        inp.onBlur();
        assert_equal(real(tb.value), 0, "clamped to min=0");
    });
    
    ui_test("onBlur removes trailing dot from float", function() {
        var tb  = new UiTextbox({}, { format: "float" });
        var inp = tb.Input;
        inp.focused = true;
        tb.value    = "3.";
        inp.onBlur();
        assert_equal(tb.value, "3", "trailing dot removed");
    });
    
    
});
