function ui_demo_example_radio(PreviewCard) {
    PreviewCard.add(new UiText("Scegli un'opzione:", { marginBottom: 12, height: 20 }, { color: #0F172A }));
    PreviewCard.add(new UiCheckbox({ marginBottom: 12 }, { label: "Opzione A", variant: "radio", group: "demo_group" }));
    PreviewCard.add(new UiCheckbox({}, { label: "Opzione B", variant: "radio", value: true, group: "demo_group" }));
    return [
        "new UiCheckbox({ marginBottom: 12 }, { label: \"Opzione A\", variant: \"radio\", group: \"demo\" });",
        "new UiCheckbox({}, { label: \"Opzione B\", variant: \"radio\", group: \"demo\", value: true });"
    ];
}
