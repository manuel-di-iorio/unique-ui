function ui_demo_example_card(PreviewCard) {
    var card = new UiNode({ width: "100%", padding: 24, flexDirection: "column" });
    card.onDraw = method(card, function() {
        draw_set_color(c_white); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, false);
        draw_set_color(global.UI_COL_BORDER); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, true);
    });
    PreviewCard.add(card);
    card.add(new UiText("Titolo Card", { marginBottom: 8, height: 24 }, { color: #0F172A }));
    card.add(new UiText("Questo è un contenuto all'interno di una card moderna.", { height: 40 }, { color: #64748B }));
    return [
        "var card = new UiNode({ width: \"100%\", padding: 24, flexDirection: \"column\" });",
        "card.onDraw = function() {",
        "    draw_set_color(c_white);",
        "    draw_roundrect_ext(x1, y1, x2, y2, 12, 12, false);",
        "    draw_set_color(global.UI_COL_BORDER);",
        "    draw_roundrect_ext(x1, y1, x2, y2, 12, 12, true);",
        "};",
        "card.add(new UiText(\"Titolo Card\", { marginBottom: 8 }));",
        "card.add(new UiText(\"Contenuto della card...\", {}, { color: #64748B }));"
    ];
}
