function ui_demo_example_textbox(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Standard");
    PreviewCard.add(new UiTextbox({ width: "100%", height: 36, marginBottom: 16 }, { placeholder: "Write something..." }));
    PreviewCard.add(new UiTextbox({ width: "100%", height: 36, marginBottom: 32 }, { label: "Email", placeholder: "john@doe.com" }));
    
    __ui_demo_preview_section(PreviewCard, "Number Formats");
    var numRow = new UiNode({ flexDirection: "row", width: "100%", marginBottom: 32 });
    PreviewCard.add(numRow);
    numRow.add(new UiTextbox({ flex: 1, height: 36, marginRight: 12 }, { label: "Integer", placeholder: "0", format: "integer" }));
    numRow.add(new UiTextbox({ flex: 1, height: 36 },                  { label: "Float",   placeholder: "0.0", format: "float" }));
    
    return [
        "// Standard textbox",
        "new UiTextbox({ width: \"100%\", height: 36 }, { placeholder: \"Write...\" });",
        "new UiTextbox({ width: \"100%\", height: 36 }, { label: \"Email\", placeholder: \"...\" });",
        "",
        "// Integer / Float format",
        "new UiTextbox({ flex: 1 }, { format: \"integer\", placeholder: \"0\" });",
        "new UiTextbox({ flex: 1 }, { format: \"float\",   placeholder: \"0.0\" });"
    ];
}
