function ui_demo_example_colors(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Theme Palette");
    var grid = new UiNode({ flexDirection: "row", flexWrap: "wrap", width: "100%" });
    PreviewCard.add(grid);
    
    var colors = [
        {name: "Primary", col: global.UI_COL_PRIMARY, hex: "#2F6FEF"},
        {name: "Primary Hover", col: global.UI_COL_PRIMARY_HOVER, hex: "#215CDA"},
        {name: "Success", col: global.UI_COL_SUCCESS, hex: "#23A75A"},
        {name: "Warning", col: global.UI_COL_WARNING, hex: "#F59E0B"},
        {name: "Danger", col: global.UI_COL_DANGER, hex: "#EF4444"},
        {name: "Selected", col: global.UI_COL_SELECTED, hex: "#2F6FEF"},
        {name: "Selected Hover", col: global.UI_COL_SELECTED_HOVER, hex: "#215CDA"},
        {name: "BG Sidebar", col: global.UI_COL_BG_SIDEBAR, hex: "#F8FAFC"},
        {name: "BG Main", col: global.UI_COL_BG_MAIN, hex: "#FBFCFF"},
        {name: "BG Card", col: global.UI_COL_BG_CARD, hex: "#FFFFFF"},
        {name: "Text Main", col: global.UI_COL_TEXT_MAIN, hex: "#13213A"},
        {name: "Text Dim", col: global.UI_COL_TEXT_DIM, hex: "#60708D"},
        {name: "Border", col: global.UI_COL_BORDER, hex: "#DDE5F0"},
        {name: "Btn Hover", col: global.UI_COL_BTN_HOVER, hex: "#EDF3FF"},
        {name: "Box", col: global.UI_COL_BOX, hex: "#FFFFFF"},
        {name: "Input BG", col: global.UI_COL_INPUT_BG, hex: "#FFFFFF"},
        {name: "Checkbox Hover", col: global.UI_COL_CHECKBOX_HOVER, hex: "#EDF3FF"},
        {name: "Dropdown BG", col: global.UI_COL_DROPDOWN_LIST_BG, hex: "#172338"},
        {name: "Scrollbar Thumb", col: global.UI_COL_SCROLLBAR_THUMB, hex: "#CBD5E1"}
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
                draw_set_color(global.UI_COL_BORDER);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y1 + 80, 8, 8, true);
            }
        });
        box.add(new UiText(c.name, { marginTop: 85, height: 20 }, { color: global.UI_COL_TEXT_MAIN, font: fTextSmall }));
        box.add(new UiText(c.hex, { height: 20 }, { color: global.UI_COL_TEXT_DIM, font: fTextSmall }));
        grid.add(box);
    }
    
    __ui_demo_preview_section(PreviewCard, "Semantic Tokens", 40);
    var semGrid = new UiNode({ flexDirection: "column", width: "100%" });
    PreviewCard.add(semGrid);
    
    __ui_demo_doc_row(semGrid, "global.UI_COL_PRIMARY", "color", "Main brand color used for primary actions.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_SUCCESS", "color", "Positive feedback and success states.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_WARNING", "color", "Cautionary feedback and warnings.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_DANGER", "color", "Negative feedback and error states.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_BG_MAIN", "color", "Default workspace background.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_BG_SIDEBAR", "color", "Dark sidebar background.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_TEXT_MAIN", "color", "Primary text color for maximum contrast.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_TEXT_DIM", "color", "Secondary text color for labels and hints.");
    __ui_demo_doc_row(semGrid, "global.UI_COL_BORDER", "color", "Default border color for cards and inputs.");

    return [
        "// The library uses a set of global variables for easy skinning.",
        "// You can override these at any time to change the look and feel.",
        "",
        "global.UI_COL_PRIMARY = #2F6FEF;",
        "global.UI_COL_SUCCESS = #23A75A;",
        "global.UI_COL_DANGER  = #EF4444;",
        "global.UI_COL_BG_MAIN = #FBFCFF;"
    ];
}
