// ============================================================
//  UiTooltip Tests
// ============================================================

ui_test_suite("UiTooltip", function() {
    
    ui_test("Tooltip display is false by default", function() {
        var tip = new UiTooltip();
        assert_false(tip.display, "display = false by default");
    });
    
    ui_test("Tooltip visible is false by default", function() {
        var tip = new UiTooltip();
        assert_false(tip.visible, "visible = false by default");
    });
    
    ui_test("Tooltip has textNode child", function() {
        var tip = new UiTooltip();
        assert_not_undefined(tip.textNode, "textNode exists");
        assert_true(tip.textNode.isUiNode, "textNode is UiNode");
    });
    
    ui_test("textNode starts with empty text", function() {
        var tip = new UiTooltip();
        assert_equal(tip.textNode.text, "", "textNode.text = ''");
    });
    
    ui_test("target starts as undefined", function() {
        var tip = new UiTooltip();
        assert_is_undefined(tip.target, "target = undefined");
    });
    
    ui_test("show() sets display = true", function() {
        var tip    = new UiTooltip();
        var target = new UiNode({}, {});
        global.UI.mouseX = 100;
        global.UI.mouseY = 100;
        tip.show(target, "Tooltip text");
        assert_true(tip.display, "display = true after show()");
    });
    
    ui_test("show() sets target", function() {
        var tip    = new UiTooltip();
        var target = new UiNode({}, {});
        global.UI.mouseX = 50;
        global.UI.mouseY = 50;
        tip.show(target, "Hello");
        assert_equal(tip.target, target, "target set after show()");
    });
    
    ui_test("show() sets textNode.text", function() {
        var tip    = new UiTooltip();
        var target = new UiNode({}, {});
        global.UI.mouseX = 50;
        global.UI.mouseY = 50;
        tip.show(target, "My Tooltip");
        assert_equal(tip.textNode.text, "My Tooltip", "textNode.text set");
    });
    
    ui_test("hide() sets display = false", function() {
        var tip    = new UiTooltip();
        var target = new UiNode({}, {});
        global.UI.mouseX = 50;
        global.UI.mouseY = 50;
        tip.show(target, "Test");
        tip.hide();
        assert_false(tip.display, "display = false after hide()");
    });
    
    ui_test("hide() sets target to undefined", function() {
        var tip    = new UiTooltip();
        var target = new UiNode({}, {});
        global.UI.mouseX = 50;
        global.UI.mouseY = 50;
        tip.show(target, "Test");
        tip.hide();
        assert_is_undefined(tip.target, "target = undefined after hide()");
    });
    
    ui_test("show() positions tooltip near mouse", function() {
        var tip    = new UiTooltip();
        var target = new UiNode({}, {});
        global.UI.mouseX = 200;
        global.UI.mouseY = 150;
        tip.show(target, "Pos Test");
        // Should be positioned near mouse (offset by ~15, 20)
        assert_equal(tip.getLeft(), 215, "left = mouseX + 15");
        assert_equal(tip.getTop(),  170, "top  = mouseY + 20");
    });
    
    ui_test("isUiNode true (inherits UiNode)", function() {
        var tip = new UiTooltip();
        assert_true(tip.isUiNode, "isUiNode = true");
    });
    
    ui_test("backgroundColor is set", function() {
        var tip = new UiTooltip();
        assert_not_undefined(tip.backgroundColor, "backgroundColor exists");
    });
    
    ui_test("borderColor is set", function() {
        var tip = new UiTooltip();
        assert_not_undefined(tip.borderColor, "borderColor exists");
    });
    
});
