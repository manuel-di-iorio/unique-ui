function ui_demo_example_button(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Variants");
    var row1 = new UiNode({ flexDirection: "row", marginBottom: 32, flexWrap: "wrap" });
    PreviewCard.add(row1);
    row1.add(new UiButton("Primary", { marginRight: 12, marginBottom: 8 }, { variant: "primary" }));
    row1.add(new UiButton("Secondary", { marginRight: 12, marginBottom: 8 }, { variant: "secondary" }));
    row1.add(new UiButton("Outline", { marginRight: 12, marginBottom: 8 }, { variant: "outline" }));
    row1.add(new UiButton("Danger", { marginBottom: 8 }, { variant: "danger" }));
    
    __ui_demo_preview_section(PreviewCard, "Sizes");
    var row2 = new UiNode({ flexDirection: "row", alignItems: "center" });
    PreviewCard.add(row2);
    row2.add(new UiButton("Small", { height: 28, marginRight: 12 }, { variant: "outline" }));
    row2.add(new UiButton("Medium", { height: 36, marginRight: 12 }, { variant: "primary" }));
    row2.add(new UiButton("Large", { height: 44 }, { variant: "outline" }));
    
    return [
        "new UiButton(\"Primary\", { marginRight: 12 }, { variant: \"primary\" });",
        "new UiButton(\"Secondary\", { marginRight: 12 }, { variant: \"secondary\" });",
        "new UiButton(\"Outline\", { marginRight: 12 }, { variant: \"outline\" });",
        "new UiButton(\"Small\", { height: 28 }, { variant: \"outline\" });",
        "new UiButton(\"Large\", { height: 44 }, { variant: \"outline\" });"
    ];
}
