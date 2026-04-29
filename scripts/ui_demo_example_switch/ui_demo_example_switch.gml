function ui_demo_example_switch(PreviewCard) {
    PreviewCard.add(new UiSwitch({ marginBottom: 12 }, { label: "Push Notifications" }));
    PreviewCard.add(new UiSwitch({}, { label: "Dark Mode", value: true }));
    return [
        "new UiSwitch({ marginBottom: 12 }, { label: \"Push Notifications\" });",
        "new UiSwitch({}, { label: \"Dark Mode\", value: true });"
    ];
}
