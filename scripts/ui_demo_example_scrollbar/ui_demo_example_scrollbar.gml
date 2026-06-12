function ui_demo_example_scrollbar(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Vertical scrollbar");
    PreviewCard.add(new UiText(
        "A tall container with a custom scrollbar. The thumb size is proportional to the visible / total ratio.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var tallContainer = new UiNode({ width: "100%", height: 240, flexDirection: "column" }, { pointerEvents: true });
    tallContainer.enableScrollbar(function() { return global.UI_COL_SCROLLBAR; });
    for (var i = 0; i < 50; i++) {
        var label = "Row #" + string(i + 1);
        var row = new UiNode({ width: "100%", height: 40, paddingLeft: 16, justifyContent: "center" }, { pointerEvents: true });
        row.__label = label;
        row.onDraw = method(row, function() {
            if (self.hovered) {
                draw_set_color(global.UI_COL_HOVER);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 4, 4, false);
            }
            draw_set_color(global.UI_COL_TEXT_2);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(self.x1 + 16, ~~mean(self.y1, self.y2), self.__label);
        });
        row.onMouseEnter(function() { global.UI.requestRedraw(); });
        row.onMouseLeave(function() { global.UI.requestRedraw(); });
        tallContainer.add(row);
    }
    PreviewCard.add(tallContainer);

    PreviewCard.add(new UiNode({ height: 24 }));

    __ui_demo_preview_section(PreviewCard, "Horizontal scrollbar");
    PreviewCard.add(new UiText(
        "A container with wide content and a horizontal scrollbar.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var wideContainer = new UiNode({ width: "100%", height: 120, flexDirection: "row" }, { pointerEvents: true });
    wideContainer.enableHorizontalScrollbar(function() { return global.UI_COL_SCROLLBAR; });
    var colors = [ #4FC3F7, #81C784, #FFB74D, #E57373, #CE93D8, #64B5F6, #A1887F, #90A4AE ];
    for (var i = 0; i < 20; i++) {
        var block = new UiNode({ width: 120, height: "100%", flexShrink: 0, justifyContent: "center", alignItems: "center" });
        block.__col = colors[i % array_length(colors)];
        block.__label = "Col " + string(i + 1);
        block.onDraw = method(block, function() {
            draw_set_color(self.__col);
            draw_roundrect_ext(self.x1 + 4, self.y1 + 4, self.x2 - 4, self.y2 - 4, 6, 6, false);
            draw_set_color(#FFFFFF);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.__label);
        });
        wideContainer.add(block);
    }
    PreviewCard.add(wideContainer);

    PreviewCard.add(new UiNode({ height: 24 }));

    __ui_demo_preview_section(PreviewCard, "Both axes");
    PreviewCard.add(new UiText(
        "Content that overflows in both directions with vertical + horizontal scrollbars.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var bothContainer = new UiNode({ width: "100%", height: 200, flexDirection: "column", paddingRight: 8 }, { pointerEvents: true });
    bothContainer.enableScrollbar(#818CF8);
    bothContainer.enableHorizontalScrollbar(#818CF8);
    for (var r = 0; r < 30; r++) {
        var row2 = new UiNode({ flexDirection: "row", flexShrink: 0, height: 44, width: 1200 });
        for (var c = 0; c < 12; c++) {
            var cell = new UiNode({ width: 100, height: "100%", flexShrink: 0, justifyContent: "center", alignItems: "center" });
            cell.__label = "(" + string(r + 1) + "," + string(c + 1) + ")";
            cell.__bg = (r + c) % 2 == 0 ? global.UI_COL_SURFACE_3 : global.UI_COL_SURFACE_2;
            cell.onDraw = method(cell, function() {
                draw_set_color(self.__bg);
                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
                draw_set_color(global.UI_COL_TEXT_2);
                draw_set_font(global.UI_FONTS.small);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.__label);
            });
            row2.add(cell);
        }
        bothContainer.add(row2);
    }
    PreviewCard.add(bothContainer);

    return [
        "// Vertical scrollbar",
        "var container = new UiNode({ width: \"100%\", height: 240 }, { pointerEvents: true });",
        "container.enableScrollbar(#818CF8);",
        "for (var i = 0; i < 50; i++) {",
        "    container.add(new UiNode({ width: \"100%\", height: 40 }));",
        "}",
        "",
        "// Horizontal scrollbar",
        "container.enableHorizontalScrollbar(#818CF8);",
        "",
        "// Both axes",
        "container.enableScrollbar(thumbsColor);",
        "container.enableHorizontalScrollbar(thumbsColor);",
    ];
}
