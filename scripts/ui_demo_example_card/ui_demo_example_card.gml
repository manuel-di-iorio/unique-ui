function ui_demo_example_card(PreviewCard) {
    var card = new UiNode({ width: "100%", padding: 24, flexDirection: "column" });
    card.onDraw = method(card, function() {
        draw_set_color(global.UI_COL_SURFACE_3); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, false);
        draw_set_color(global.UI_COL_BORDER_1); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, true);
    });
    PreviewCard.add(card);
    card.add(new UiText("Card Title", { marginBottom: 8 }, { color: global.UI_COL_TEXT_1 }));
    card.add(new UiText("This is content inside a modern card.", undefined, { color: global.UI_COL_TEXT_2 }));
    return [
        "var card = new UiNode({ width: \"100%\", padding: 24, flexDirection: \"column\" });",
        "card.onDraw = function() {",
        "    draw_set_color(c_white);",
        "    draw_roundrect_ext(x1, y1, x2, y2, 12, 12, false);",
        "    draw_set_color(global.UI_COL_BORDER_1);",
        "    draw_roundrect_ext(x1, y1, x2, y2, 12, 12, true);",
        "};",
        "card.add(new UiText(\"Card Title\", { marginBottom: 8 }));",
        "card.add(new UiText(\"Card content...\", {}, { color: #64748B }));"
    ];
}
