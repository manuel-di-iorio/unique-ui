function ui_demo_example_colorpicker(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Standard");
    PreviewCard.add(new UiColorPicker({ marginBottom: 24 }, {
        label: "Accent color",
        value: global.UI_COL_PRIMARY
    }));

    __ui_demo_preview_section(PreviewCard, "With onChange");
    var _state = { hex: uui_color_to_hex(global.UI_COL_SUCCESS) };
    var _picker = new UiColorPicker({ marginBottom: 8 }, {
        value: global.UI_COL_SUCCESS,
        onChange: method(_state, function(_col) {
            hex = uui_color_to_hex(_col);
        })
    });
    PreviewCard.add(_picker);
    PreviewCard.add(new UiText("Selected: " + _state.hex, {}, { color: global.UI_COL_TEXT_DIM }));

    return [
        "new UiColorPicker({}, {",
        "  label: \"Accent color\",",
        "  value: global.UI_COL_PRIMARY",
        "});",
        "",
        "new UiColorPicker({}, {",
        "  value: #23A75A,",
        "  onChange: function(col, picker) {",
        "    show_debug_message(uui_color_to_hex(col));",
        "  }",
        "});"
    ];
}
