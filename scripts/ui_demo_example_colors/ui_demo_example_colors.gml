function ui_demo_example_colors(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Palette");
    var grid = new UiNode({ flexDirection: "row", flexWrap: "wrap", width: "100%" });
    PreviewCard.add(grid);
    var colors = [
        {name: "Primary", col: global.UI_COL_PRIMARY, hex: "#6366F1"},
        {name: "Success", col: #22C55E, hex: "#22C55E"},
        {name: "Warning", col: #F59E0B, hex: "#F59E0B"},
        {name: "Danger", col: #EF4444, hex: "#EF4444"},
        {name: "Slate 900", col: #0F172A, hex: "#0F172A"},
        {name: "Slate 500", col: #64748B, hex: "#64748B"},
        {name: "Slate 300", col: #CBD5E1, hex: "#CBD5E1"},
        {name: "Slate 100", col: #F1F5F9, hex: "#F1F5F9"}
    ];
    for (var i = 0; i < array_length(colors); i++) {
        var c = colors[i];
        var box = new UiNode({ width: 120, height: 140, marginRight: 16, marginBottom: 16, flexDirection: "column" });
        box.__demoCol = c.col;
        box.onDraw = method(box, function() {
            draw_set_color(self.__demoCol); 
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y1 + 80, 8, 8, false);
        });
        box.add(new UiText(c.name, { marginTop: 85, height: 20 }, { color: #0F172A, font: fTextSmall }));
        box.add(new UiText(c.hex, { height: 20 }, { color: #64748B, font: fTextSmall }));
        grid.add(box);
    }
    
    __ui_demo_preview_section(PreviewCard, "Semantic Tokens", 40);
    var semGrid = new UiNode({ flexDirection: "column", width: "100%" });
    PreviewCard.add(semGrid);
    __ui_demo_doc_row(semGrid, "global.UI_COL_PRIMARY", "color", "Main brand color");
    __ui_demo_doc_row(semGrid, "global.UI_COL_BG_MAIN", "color", "Workspace background color");
    __ui_demo_doc_row(semGrid, "global.UI_COL_TEXT_MAIN", "color", "Main text color");
    
    return [
        "global.UI_COL_PRIMARY = #6366F1;",
        "global.UI_COL_SUCCESS = #22C55E;",
        "global.UI_COL_WARNING = #F59E0B;",
        "global.UI_COL_DANGER  = #EF4444;",
        "global.UI_COL_BG_MAIN = #F8FAFC;"
    ];
}
