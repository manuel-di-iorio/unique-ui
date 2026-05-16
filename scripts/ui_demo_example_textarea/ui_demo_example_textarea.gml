function ui_demo_example_textarea(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Standard");
    PreviewCard.add(new UiTextarea({ width: "100%", height: 120, marginBottom: 16 }, {
        placeholder: "Write a longer message..."
    }));
    
    PreviewCard.add(new UiTextarea({ width: "100%", height: 150, marginBottom: 32 }, {
        label: "Notes",
        value: "First line\nSecond line\nDrag to select across lines.\nUse the mouse wheel to scroll."
    }));
    
    __ui_demo_preview_section(PreviewCard, "Long Content");
    PreviewCard.add(new UiTextarea({ width: "100%", height: 130, marginBottom: 32 }, {
        maxLength: 1000,
        value: "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8"
    }));
    
    return [
        "// Multiline textarea",
        "new UiTextarea({ width: \"100%\", height: 120 }, {",
        "    placeholder: \"Write a longer message...\"",
        "});",
        "",
        "// Prefilled textarea",
        "new UiTextarea({ width: \"100%\", height: 150 }, {",
        "    label: \"Notes\",",
        "    value: \"First line\\nSecond line\"",
        "});"
    ];
}
