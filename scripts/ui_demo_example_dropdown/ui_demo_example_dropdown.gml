function ui_demo_example_dropdown(PreviewCard) {
    PreviewCard.add(new UiDropdown({ width: "100%", height: 36 }, { 
        label: "Frutto", 
        items: [{label: "Mela", value: "mela"}, {label: "Pera", value: "pera"}] 
    }));
    return [
        "new UiDropdown({ height: 36 }, { ",
        "  label: \"Frutto\", ",
        "  items: [{label: \"Mela\", value: \"mela\"}, {label: \"Pera\", value: \"pera\"}] ",
        "});"
    ];
}
