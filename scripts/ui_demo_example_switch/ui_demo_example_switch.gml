function ui_demo_example_switch(PreviewCard) {
    PreviewCard.add(new UiSwitch({ marginBottom: 12 }, { label: "Notifiche Push" }));
    PreviewCard.add(new UiSwitch({}, { label: "Modalità Scura", value: true }));
    return [
        "new UiSwitch({ marginBottom: 12 }, { label: \"Notifiche Push\" });",
        "new UiSwitch({}, { label: \"Modalità Scura\", value: true });"
    ];
}
