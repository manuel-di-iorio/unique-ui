function ui_demo_example_contextmenu(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Example (Right Click)");
    var zone = new UiNode({ width: "100%", height: 200, justifyContent: "center", alignItems: "center" }, { backgroundColor: global.UI_COL_BG_CARD, borderRadius: 8 });
    zone.pointerEvents = true;
    zone.add(new UiText("Right click here", {}, { color: "dim" }));
    PreviewCard.add(zone);
    
    zone.onContextMenu(function() {
        var menu = new UiContextMenu(global.UI.mouseX, global.UI.mouseY);
        menu.addItem("Action 1", function() { show_message("Action 1"); });
        menu.addItem("Action 2", function() { show_message("Action 2"); });
        menu.show();
    });
    
    return [
        "zone.onContextMenu(function() {",
        "  var menu = new UiContextMenu(global.UI.mouseX, global.UI.mouseY);",
        "  menu.addItem(\"Action 1\", function() { ... });",
        "  menu.show();",
        "});"
    ];
}
