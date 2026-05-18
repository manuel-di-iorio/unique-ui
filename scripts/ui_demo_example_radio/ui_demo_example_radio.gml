function ui_demo_example_radio(PreviewCard) {
    PreviewCard.add(new UiText("Pick an option:", { marginBottom: 12, height: 20 }, { color: global.UI_COL_TEXT_MAIN }));
    PreviewCard.add(new UiRadio({ marginBottom: 12 }, { label: "Option A", group: "demo_group" }));
    PreviewCard.add(new UiRadio({}, { label: "Option B", value: true, group: "demo_group" }));
    
    return [
        "new UiText(\"Pick an option:\", { marginBottom: 12, height: 20 }, { color: #0F172A });",
        "new UiRadio({ marginBottom: 12 }, { label: \"Option A\", group: \"demo_group\" });",
        "new UiRadio({}, { label: \"Option B\", value: true, group: \"demo_group\" });"
    ];
}
