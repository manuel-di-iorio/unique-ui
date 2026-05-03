function ui_demo_example_dropdown(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Standard");
    PreviewCard.add(new UiDropdown({ width: "100%", height: 36, marginBottom: 24 }, { 
        label: "Fruit", 
        items: [{label: "Apple", value: "apple"}, {label: "Pear", value: "pear"}, {label: "Banana", value: "banana"}] 
    }));

    __ui_demo_preview_section(PreviewCard, "Searchable (Filter)");
    PreviewCard.add(new UiDropdown({ width: "100%", height: 36 }, { 
        label: "Search..", 
        search: "Filter items...",
        items: [
            {label: "Grapes", value: "grapes"}, 
            {label: "Orange", value: "orange"}, 
            {label: "Pineapple", value: "pineapple"},
            {label: "Strawberry", value: "strawberry"},
            {label: "Watermelon", value: "watermelon"}
        ] 
    }));

    return [
        "new UiDropdown({ height: 36 }, { ",
        "  label: \"Fruit\", ",
        "  items: [...] ",
        "});",
        "",
        "// Searchable variant",
        "new UiDropdown({ height: 36 }, { ",
        "  label: \"Search\", ",
        "  search: \"Filter items...\",",
        "  items: [...] ",
        "});"
    ];
}
