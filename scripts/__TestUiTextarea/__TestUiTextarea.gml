// ============================================================
//  UiTextarea Tests
// ============================================================

ui_test_suite("UiTextarea", function() {
    
    ui_test("value defaults to empty string", function() {
        var ta = new UiTextarea({}, {});
        assert_equal(ta.value, "", "default value");
    });
    
    ui_test("value set from props", function() {
        var ta = new UiTextarea({}, { value: "Hello\nWorld" });
        assert_equal(ta.value, "Hello\nWorld", "value from props");
    });
    
    ui_test("Input sub-node exists", function() {
        var ta = new UiTextarea({}, {});
        assert_not_undefined(ta.Input, "Input exists");
        assert_true(ta.Input.isUiNode, "Input is UiNode");
    });
    
    ui_test("maxLength defaults to 4000", function() {
        var ta = new UiTextarea({}, {});
        assert_equal(ta.maxLength, 4000, "maxLength = 4000");
    });
    
    ui_test("lineHeight defaults to 22", function() {
        var ta = new UiTextarea({}, {});
        assert_equal(ta.lineHeight, 22, "lineHeight = 22");
    });
    
    ui_test("getLines splits multiline value", function() {
        var ta = new UiTextarea({}, { value: "One\nTwo\nThree" });
        var lines = ta.Input.getLines();
        assert_equal(array_length(lines), 3, "three lines");
        assert_equal(lines[1].text, "Two", "second line");
        assert_equal(lines[2].start, 8, "third line start");
    });
    
    ui_test("insertText preserves newline characters", function() {
        var ta = new UiTextarea({}, {});
        var inp = ta.Input;
        inp.cursorPos = 0;
        inp.selectionStart = 0;
        inp.selectionEnd = 0;
        inp.insertText("A\nB");
        assert_equal(ta.value, "A\nB", "newline inserted");
        assert_equal(inp.cursorPos, 3, "cursor after inserted text");
    });
    
    ui_test("insertText normalizes CRLF clipboard text", function() {
        var ta = new UiTextarea({}, {});
        var inp = ta.Input;
        inp.insertText("A\r\nB\rC");
        assert_equal(ta.value, "A\nB\nC", "CRLF normalized");
    });
    
    ui_test("insertText respects maxLength", function() {
        var ta = new UiTextarea({}, { maxLength: 5 });
        var inp = ta.Input;
        inp.insertText("Hello\nWorld");
        assert_equal(string_length(ta.value), 5, "truncated to maxLength");
    });
    
    ui_test("getSelectedText returns multiline substring", function() {
        var ta = new UiTextarea({}, { value: "One\nTwo\nThree" });
        var inp = ta.Input;
        inp.selectionStart = 2;
        inp.selectionEnd = 7;
        assert_equal(inp.getSelectedText(), "e\nTwo", "multiline selection");
    });
    
    ui_test("deleteSelected removes text across lines", function() {
        var ta = new UiTextarea({}, { value: "One\nTwo\nThree" });
        var inp = ta.Input;
        inp.selectionStart = 3;
        inp.selectionEnd = 8;
        var deleted = inp.deleteSelected();
        assert_true(deleted, "selection deleted");
        assert_equal(ta.value, "OneThree", "cross-line deletion");
        assert_equal(inp.cursorPos, 3, "cursor at selection start");
    });
    
    ui_test("getLineStart and getLineEnd use current cursor line", function() {
        var ta = new UiTextarea({}, { value: "One\nTwo\nThree" });
        var inp = ta.Input;
        assert_equal(inp.getLineStart(5), 4, "line start");
        assert_equal(inp.getLineEnd(5), 7, "line end");
    });
    
    ui_test("vertical movement keeps preferred x where possible", function() {
        var ta = new UiTextarea({}, { value: "abcd\nxy\nabcdef" });
        var inp = ta.Input;
        inp.cursorPos = 3;
        inp.updateScrollOffset();
        inp.moveVertical(1, false);
        assert_equal(inp.cursorPos, 7, "moves to end of shorter line");
        inp.moveVertical(1, false);
        assert_equal(inp.cursorPos, 11, "returns to preferred column");
    });
    
    ui_test("saveUndoState pushes state onto undoStack", function() {
        var ta = new UiTextarea({}, { value: "Hello" });
        var inp = ta.Input;
        inp.cursorPos = 5;
        inp.saveUndoState();
        assert_equal(array_length(inp.undoStack), 1, "undo state saved");
        assert_equal(inp.undoStack[0].text, "Hello", "correct text saved");
    });
    
    ui_test("performUndo restores multiline value", function() {
        var ta = new UiTextarea({}, { value: "Hello" });
        var inp = ta.Input;
        inp.cursorPos = 5;
        inp.saveUndoState();
        ta.value = "Hello\nWorld";
        inp.cursorPos = 11;
        inp.performUndo();
        assert_equal(ta.value, "Hello", "undo restores previous value");
    });
    
    ui_test("performRedo restores multiline value", function() {
        var ta = new UiTextarea({}, { value: "Hello" });
        var inp = ta.Input;
        inp.cursorPos = 5;
        inp.saveUndoState();
        ta.value = "Hello\nWorld";
        inp.cursorPos = 11;
        inp.performUndo();
        inp.performRedo();
        assert_equal(ta.value, "Hello\nWorld", "redo restores value");
    });
    
    ui_test("onBlur calls parent onBlur", function() {
        var state = { value: "" };
        var ta = new UiTextarea({}, { value: "Done", onBlur: method(state, function(v) { value = v; }) });
        ta.Input.focused = true;
        ta.Input.onBlur();
        assert_equal(state.value, "Done", "onBlur value");
        assert_false(ta.Input.focused, "focused false after blur");
    });
    
});
