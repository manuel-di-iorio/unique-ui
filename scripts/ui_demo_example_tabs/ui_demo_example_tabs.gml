function ui_demo_example_tabs(PreviewCard) {
    if (!variable_struct_exists(global.UI_DEMO, "tabSelected")) global.UI_DEMO.tabSelected = 0;
    var tabRow = new UiNode({ flexDirection: "row", marginBottom: 20 });
    PreviewCard.add(tabRow);
    
    var btnA = new UiButton("Tab A", { height: 32, marginRight: 4 }, { variant: global.UI_DEMO.tabSelected == 0 ? "primary" : "ghost" });
    btnA.onClick(function() { global.UI_DEMO.tabSelected = 0; __ui_demo_refresh(); });
    tabRow.add(btnA);
    
    var btnB = new UiButton("Tab B", { height: 32, marginRight: 4 }, { variant: global.UI_DEMO.tabSelected == 1 ? "primary" : "ghost" });
    btnB.onClick(function() { global.UI_DEMO.tabSelected = 1; __ui_demo_refresh(); });
    tabRow.add(btnB);
    
    var tabContent = (global.UI_DEMO.tabSelected == 0) ? "Contenuto della Tab A." : "Contenuto della Tab B.";
    PreviewCard.add(new UiText(tabContent, {}, { color: #64748B }));
    
    return [
        "var tabRow = new UiNode({ flexDirection: \"row\", marginBottom: 20 });",
        "",
        "var btnA = new UiButton(\"Tab A\", { height: 32 }, { ",
        "    variant: selected == 0 ? \"primary\" : \"ghost\" ",
        "});",
        "btnA.onClick(function() { selected = 0; refresh(); });",
        "",
        "tabRow.add(btnA);",
        "tabRow.add(new UiText(selected == 0 ? \"Content A\" : \"Content B\"));"
    ];
}
