function ui_demo_example_slider(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Volume");
    PreviewCard.add(new UiSlider({ width: "100%", height: 30 }, { min: 0, max: 100, value: 75 }));
    return [
        "new UiSlider({ width: \"100%\", height: 30 }, { min: 0, max: 100, value: 75 });"
    ];
}
