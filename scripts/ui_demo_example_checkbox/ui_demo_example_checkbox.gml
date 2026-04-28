function ui_demo_example_checkbox(PreviewCard) {
    PreviewCard.add(new UiCheckbox({ marginBottom: 12 }, { label: "Accetto i termini" }));
    PreviewCard.add(new UiCheckbox({}, { label: "Newsletter", value: true }));
    return [
        "new UiCheckbox({ marginBottom: 12 }, { label: \"Accetto i termini\" });",
        "new UiCheckbox({}, { label: \"Newsletter\", value: true });"
    ];
}
