function ui_demo_example_tooltip(PreviewCard) {
    PreviewCard.add(new UiButton("Passa il mouse", { width: 150 }, { tooltip: "Il mio fantastico tooltip!" }));
    return [
        "new UiButton(\"Hover me\", { width: 150 }, { tooltip: \"Il mio tooltip!\" });"
    ];
}
