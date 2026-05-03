function ui_demo_example_tabs(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Underline Variant");
    
    var panelA = new UiNode({ flexDirection: "column" });
    panelA.add(new UiText("This is the content of Tab A.", { marginBottom: 8 }, { color: #64748B }));
    panelA.add(new UiText("You can put any UiNode children here.", {}, { color: #94A3B8 }));
    
    var panelB = new UiNode({ flexDirection: "column" });
    panelB.add(new UiText("Tab B content goes here.", { marginBottom: 8 }, { color: #64748B }));
    panelB.add(new UiButton("Action", {}, { variant: "primary" }));
    
    var panelC = new UiNode({ flexDirection: "column" });
    panelC.add(new UiText("Settings panel content.", {}, { color: #64748B }));
    
    var tabs1 = new UiTabs([
        { label: "Overview",  content: panelA },
        { label: "Details",   content: panelB },
        { label: "Settings",  content: panelC }
    ], { width: "100%", marginBottom: 40 });
    PreviewCard.add(tabs1);
    
    __ui_demo_preview_section(PreviewCard, "Pills Variant");
    
    var pillA = new UiNode({ flexDirection: "column" });
    pillA.add(new UiText("Home panel content.", {}, { color: #64748B }));
    
    var pillB = new UiNode({ flexDirection: "column" });
    pillB.add(new UiText("Profile panel content.", {}, { color: #64748B }));
    
    var pillC = new UiNode({ flexDirection: "column" });
    pillC.add(new UiText("Notifications panel.", {}, { color: #64748B }));
    
    var tabs2 = new UiTabs([
        { label: "Home",          content: pillA },
        { label: "Profile",       content: pillB },
        { label: "Notifications", content: pillC }
    ], { width: "100%", marginBottom: 40 }, { variant: "pills" });
    PreviewCard.add(tabs2);
    
    return [
        "// Underline variant (default)",
        "var tabs = new UiTabs([",
        "    { label: \"Overview\", content: panelA },",
        "    { label: \"Details\",  content: panelB },",
        "], { width: \"100%\" });",
        "",
        "// Pills variant",
        "var tabs = new UiTabs([...], {}, { variant: \"pills\" });",
        "",
        "// onChange callback",
        "new UiTabs([...], {}, {",
        "    onChange: function(index, label) { ... }",
        "});"
    ];
}
