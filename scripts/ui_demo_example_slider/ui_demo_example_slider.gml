function ui_demo_example_slider(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Volume");
    PreviewCard.add(new UiSlider({ width: "100%", height: 30 }, { min: 0, max: 100, value: 75 }));
    
    __ui_demo_preview_section(PreviewCard, "Price Range", 24);
    PreviewCard.add(new UiSlider({ width: "100%", height: 30 }, { min: 0, max: 1000, valueStart: 200, valueEnd: 800, step: 50 }));
    
    return [
        "new UiSlider({ width: \"100%\", height: 30 }, { min: 0, max: 100, value: 75 });",
        "",
        "// Range slider (dual thumb)",
        "new UiSlider({ width: \"100%\", height: 30 }, { min: 0, max: 1000, valueStart: 200, valueEnd: 800, step: 50 });"
    ];
}
