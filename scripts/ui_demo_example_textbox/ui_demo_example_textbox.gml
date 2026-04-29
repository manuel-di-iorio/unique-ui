function ui_demo_example_textbox(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Standard");
    PreviewCard.add(new UiTextbox({ width: "100%", height: 36, marginBottom: 24 }, { placeholder: "Write something..." }));
    PreviewCard.add(new UiTextbox({ width: "100%", height: 36 }, { label: "Email", placeholder: "john@doe.com" }));
    return [
        "new UiTextbox({ width: \"100%\", height: 36 }, { placeholder: \"Write...\" });",
        "new UiTextbox({ width: \"100%\", height: 36 }, { label: \"Email\", placeholder: \"...\" });"
    ];
}
