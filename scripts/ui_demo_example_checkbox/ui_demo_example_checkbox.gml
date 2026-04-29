function ui_demo_example_checkbox(PreviewCard) {
    PreviewCard.add(new UiCheckbox({ marginBottom: 12 }, { label: "Accept the terms" }));
    PreviewCard.add(new UiCheckbox({}, { label: "Newsletter", value: true }));
    return [
        "new UiCheckbox({ marginBottom: 12 }, { label: \"Accept the terms\" });",
        "new UiCheckbox({}, { label: \"Newsletter\", value: true });"
    ];
}
