function ui_demo_example_contextmenu(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Esempio (Tasto Destro)");
    var zone = new UiNode({ width: "100%", height: 200, backgroundColor: #F1F5F9, borderRadius: 8, justifyContent: "center", alignItems: "center" });
    zone.pointerEvents = true;
    zone.add(new UiText("Clicca col tasto destro qui", {}, { color: #64748B }));
    PreviewCard.add(zone);
    
    zone.onContextMenu(function() {
        var menu = new UiContextMenu(global.UI.mouseX, global.UI.mouseY);
        menu.addItem("Azione 1", function() { show_message("Azione 1"); });
        menu.addItem("Azione 2", function() { show_message("Azione 2"); });
        menu.show();
    });
    
    return [
        "zone.onContextMenu(function() {",
        "  var menu = new UiContextMenu(global.UI.mouseX, global.UI.mouseY);",
        "  menu.addItem(\"Azione 1\", function() { ... });",
        "  menu.show();",
        "});"
    ];
}
