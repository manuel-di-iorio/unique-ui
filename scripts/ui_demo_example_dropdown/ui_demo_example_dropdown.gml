function ui_demo_example_dropdown(PreviewCard) {
    PreviewCard.add(new UiDropdown({ width: "100%", height: 36 }, { 
        label: "Fruit", 
        items: [{label: "Apple", value: "apple"}, {label: "Pear", value: "pear"}] 
    }));
    return [
        "new UiDropdown({ height: 36 }, { ",
        "  label: \"Fruit\", ",
        "  items: [{label: \"Apple\", value: \"apple\"}, {label: \"Pear\", value: \"pear\"}] ",
        "});"
    ];
}
