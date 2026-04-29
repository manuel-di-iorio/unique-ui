function ui_demo_example_tooltip(PreviewCard) {
    PreviewCard.add(new UiButton("Hover me", { width: 150 }, { tooltip: "My fantastic tooltip!" }));
    return [
        "new UiButton(\"Hover me\", { width: 150 }, { tooltip: \"My tooltip!\" });"
    ];
}
