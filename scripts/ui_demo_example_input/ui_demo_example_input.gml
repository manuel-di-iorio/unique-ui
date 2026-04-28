function ui_demo_example_input(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Standard");
    PreviewCard.add(new UiTextbox({ width: "100%", height: 36, marginBottom: 24 }, { placeholder: "Scrivi qualcosa..." }));
    PreviewCard.add(new UiTextbox({ width: "100%", height: 36 }, { label: "Email", placeholder: "mario@rossi.it" }));
    return [
        "new UiTextbox({ width: \"100%\", height: 36 }, { placeholder: \"Scrivi...\" });",
        "new UiTextbox({ width: \"100%\", height: 36 }, { label: \"Email\", placeholder: \"...\" });"
    ];
}
