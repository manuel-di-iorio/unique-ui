function ui_demo_example_badge(PreviewCard) {
    var brow = new UiNode({ flexDirection: "row", flexWrap: "wrap" });
    PreviewCard.add(brow);
    // Mocking Badge with UiButton ghost
    brow.add(new UiButton("Beta", { marginRight: 8, height: 24, paddingLeft: 8, paddingRight: 8 }, { variant: "outline" }));
    brow.add(new UiButton("Success", { marginRight: 8, height: 24, paddingLeft: 8, paddingRight: 8 }, { variant: "primary" }));
    brow.add(new UiButton("Error", { height: 24, paddingLeft: 8, paddingRight: 8 }, { variant: "danger" }));
    return [
        "new UiButton(\"Beta\", { height: 24, paddingHorizontal: 8 }, { variant: \"outline\" });",
        "new UiButton(\"Success\", { height: 24, paddingHorizontal: 8 }, { variant: \"primary\" });"
    ];
}
