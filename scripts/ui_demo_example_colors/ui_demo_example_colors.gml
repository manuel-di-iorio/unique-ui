function ui_demo_example_colors(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Theme Palette");
    var grid = new UiNode({ flexDirection: "row", flexWrap: "wrap", width: "100%" });
    PreviewCard.add(grid);
    
    var colors = [
        {name: "Primary", col: global.UI_COL_PRIMARY, hex: "#2F6FEF"},
        {name: "Primary Hover", col: global.UI_COL_PRIMARY_HOVER, hex: "#215CDA"},
        {name: "Success", col: global.UI_COL_SUCCESS, hex: "#23A75A"},
        {name: "Warning", col: global.UI_COL_WARNING, hex: "#F59E0B"},
        {name: "Error", col: global.UI_COL_ERROR, hex: "#EF4444"},
        {name: "Surface 0", col: global.UI_COL_SURFACE_0, hex: "#FBFCFF"},
        {name: "Surface 1", col: global.UI_COL_SURFACE_1, hex: "#F8FAFC"},
        {name: "Surface 2", col: global.UI_COL_SURFACE_2, hex: "#EEF3FA"},
        {name: "Surface 3", col: global.UI_COL_SURFACE_3, hex: "#FFFFFF"},
        {name: "Text 1", col: global.UI_COL_TEXT_1, hex: "#13213A"},
        {name: "Text 2", col: global.UI_COL_TEXT_2, hex: "#60708D"},
        {name: "Border 1", col: global.UI_COL_BORDER_1, hex: "#DDE5F0"},
        {name: "Hover", col: global.UI_COL_HOVER, hex: "#EDF3FF"},
        {name: "Selected", col: global.UI_COL_SELECTED, hex: "#3B82F6"},
        {name: "Floating BG", col: global.UI_COL_FLOATING_BG, hex: "#172338"},
        {name: "Scrollbar", col: global.UI_COL_SCROLLBAR, hex: "#CBD5E1"}
    ];
    
    for (var i = 0; i < array_length(colors); i++) {
        var c = colors[i];
        var box = new UiNode({ width: 140, height: 160, marginRight: 16, marginBottom: 16, flexDirection: "column" });
        box.__demoCol = c.col;
        box.onDraw = method(box, function() {
            draw_set_color(self.__demoCol); 
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y1 + 80, 8, 8, false);
            
            // Draw border for very light colors to make them visible
            if (self.__demoCol == #FFFFFF || self.__demoCol == #F8FAFC || self.__demoCol == #F1F5F9) {
                draw_set_color(global.UI_COL_BORDER_1);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y1 + 80, 8, 8, true);
            }
        });
        box.add(new UiText(c.name, { marginTop: 85, height: 20 }, { color: global.UI_COL_TEXT_1, font: global.UI_FONTS.small }));
        box.add(new UiText(c.hex, { height: 20 }, { color: global.UI_COL_TEXT_2, font: global.UI_FONTS.small }));
        grid.add(box);
    }
    
    __ui_demo_preview_section(PreviewCard, "Semantic Tokens", 40);
    var semGrid = new UiNode({ flexDirection: "column", width: "100%" });
    PreviewCard.add(semGrid);
    
    __ui_demo_doc_row(semGrid, "global.UI_COL_PRIMARY", "color", "Main brand color used for primary actions.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_PRIMARY_HOVER", "color", "Hover state for primary elements.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SUCCESS", "color", "Positive feedback and success states.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_WARNING", "color", "Cautionary feedback and warnings.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_ERROR", "color", "Negative feedback and error states.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SURFACE_0", "color", "Default main background.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SURFACE_1", "color", "Secondary surface (e.g., sidebar).");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SURFACE_2", "color", "Tertiary surface (e.g., inspector bg).");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SURFACE_3", "color", "Card/surface foreground.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_TEXT_1", "color", "Primary text color for maximum contrast.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_TEXT_2", "color", "Secondary text color for labels and hints.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_BORDER_1", "color", "Default border color for cards and inputs.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_HOVER", "color", "Hover state for interactive elements.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SELECTED", "color", "Selected state highlight.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_FLOATING_BG", "color", "Background for dropdowns and popovers.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SCROLLBAR", "color", "Scrollbar thumb color.");

    return [
        "// The library uses a set of global variables for easy skinning.",
        "// You can override these at any time to change the look and feel.",
        "",
        "global.UI_COL_PRIMARY   = #2F6FEF;",
        "global.UI_COL_SURFACE_0 = #FBFCFF;",
        "global.UI_COL_TEXT_1    = #13213A;",
        "global.UI_COL_BORDER_1  = #DDE5F0;"
    ];
}
