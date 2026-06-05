function ui_demo_example_colorpicker(PreviewCard) {
    PreviewCard.add(new UiColorPicker({ marginBottom: 16, width: "100%", height: 32 }, {
        label: "Accent color",
        value: global.UI_COL_PRIMARY
    }));

    var _state = { hex: __uui_color_to_hex(global.UI_COL_SUCCESS) };
    PreviewCard.add(new UiColorPicker({ marginBottom: 24, width: "100%", height: 32 }, {
        label: "With onChange (live preview)",
        value: global.UI_COL_SUCCESS,
        onChange: method(_state, function(_col) {
            hex = __uui_color_to_hex(_col);
        })
    }));

    PreviewCard.add(new UiNode({ width: "100%", height: 1, marginBottom: 12 }, { backgroundColor: global.UI_COL_BORDER }));
    PreviewCard.add(new UiText("", {}, {
        color: global.UI_COL_TEXT_DIM,
        valueGetter: method(_state, function() { return "Selected: " + hex; })
    }));

    return [
        "new UiColorPicker({ width: \"100%\", height: 32 }, {",
        "  label: \"Accent color\",",
        "  value: global.UI_COL_PRIMARY",
        "});",
        "",
        "new UiColorPicker({ width: \"100%\", height: 32 }, {",
        "  label: \"With onChange (live preview)\",",
        "  value: #23A75A,",
        "  onChange: function(col, picker) {",
        "    show_debug_message(__uui_color_to_hex(col));",
        "  }",
        "});"
    ];
}
