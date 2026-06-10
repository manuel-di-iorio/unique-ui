function ui_demo_example_colorpicker(PreviewCard) {
    PreviewCard.add(new UiColorPicker({ marginBottom: 16, height: 32 }, {
        value: global.UI_COL_PRIMARY
    }));

    var colorLabel = new UiText("Selected: " + __uui_color_to_hex(global.UI_COL_SUCCESS), {}, {
        color: global.UI_COL_TEXT_2
    });
    PreviewCard.add(new UiColorPicker({ marginBottom: 24, height: 32 }, {
        value: global.UI_COL_SUCCESS,
        onChange: method(colorLabel, function(_col) {
            self.setValue("Selected: " + __uui_color_to_hex(_col));
        })
    }));

    PreviewCard.add(new UiNode({ width: "100%", height: 1, marginBottom: 12 }, { backgroundColor: global.UI_COL_BORDER_1 }));
    PreviewCard.add(colorLabel);

    return [
        "new UiColorPicker({ width: \"100%\", height: 32 }, {",
        "  value: global.UI_COL_PRIMARY",
        "});",
        "",
        "new UiColorPicker({ width: \"100%\", height: 32 }, {",
        "  value: #23A75A,",
        "  onChange: function(col, picker) {",
        "    show_debug_message(__uui_color_to_hex(col));",
        "  }",
        "});"
    ];
}
