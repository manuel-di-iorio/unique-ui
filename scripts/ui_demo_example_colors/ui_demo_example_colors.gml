function ui_demo_example_colors(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Theme Palette");
    var grid = new UiNode({ flexDirection: "row", flexWrap: "wrap", width: "100%" });
    PreviewCard.add(grid);
    
    var colors = [
        {name: "Primary", col: global.UI_COL_PRIMARY, hex: "#2563EB"},
        {name: "Primary Hover", col: global.UI_COL_PRIMARY_HOVER, hex: "#1D4ED8"},
        {name: "Success", col: global.UI_COL_SUCCESS, hex: "#22C55E"},
        {name: "Warning", col: global.UI_COL_WARNING, hex: "#F59E0B"},
        {name: "Danger", col: global.UI_COL_DANGER, hex: "#EF4444"},
        {name: "Selection", col: global.UI_COL_SELECTION, hex: "#3B82F6"},
        {name: "Selected", col: global.UI_COL_SELECTED, hex: "#2563EB"},
        {name: "Selected Hover", col: global.UI_COL_SELECTED_HOVER, hex: "#1D4ED8"},
        {name: "BG Sidebar", col: global.UI_COL_BG_SIDEBAR, hex: "#0F172A"},
        {name: "BG Main", col: global.UI_COL_BG_MAIN, hex: "#F8FAFC"},
        {name: "BG Card", col: global.UI_COL_BG_CARD, hex: "#FFFFFF"},
        {name: "Text Main", col: global.UI_COL_TEXT_MAIN, hex: "#0F172A"},
        {name: "Text Dim", col: global.UI_COL_TEXT_DIM, hex: "#64748B"},
        {name: "Border", col: global.UI_COL_BORDER, hex: "#E2E8F0"},
        {name: "Btn Hover", col: global.UI_COL_BTN_HOVER, hex: "#F1F5F9"},
        {name: "Box", col: global.UI_COL_BOX, hex: "#FFFFFF"},
        {name: "Input BG", col: global.UI_COL_INPUT_BG, hex: "#F8FAFC"},
        {name: "Bar BG", col: global.UI_COL_BAR_BG, hex: "#FFFFFF"},
        {name: "Checkbox Hover", col: global.UI_COL_CHECKBOX_HOVER, hex: "#F1F5F9"},
        {name: "Dropdown BG", col: global.UI_COL_DROPDOWN_LIST_BG, hex: "#1E293B"},
        {name: "Inspector BG", col: global.UI_COL_INSPECTOR_BG, hex: "#334155"},
        {name: "Tree BG", col: global.UI_COL_TREE_BG, hex: "#0F172A"}
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
        "global.UI_COL_PRIMARY = #2563EB;",
        "global.UI_COL_SUCCESS = #22C55E;",
        "global.UI_COL_DANGER  = #EF4444;",
        "global.UI_COL_BG_MAIN = #F8FAFC;"
    ];
}
