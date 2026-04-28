function ui_demo_example_radio(PreviewCard) {
    PreviewCard.add(new UiText("Scegli un'opzione:", { marginBottom: 12, height: 20 }, { color: #0F172A }));
    PreviewCard.add(new UiRadio({ marginBottom: 12 }, { label: "Opzione A", group: "demo_group" }));
    PreviewCard.add(new UiRadio({}, { label: "Opzione B", value: true, group: "demo_group" }));
    
    return [
        "new UiText(\"Scegli un'opzione:\", { marginBottom: 12, height: 20 }, { color: #0F172A });",
        "new UiRadio({ marginBottom: 12 }, { label: \"Opzione A\", group: \"demo_group\" });",
        "new UiRadio({}, { label: \"Opzione B\", value: true, group: \"demo_group\" });"
    ];
}
