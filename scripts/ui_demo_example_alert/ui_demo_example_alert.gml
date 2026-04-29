function ui_demo_example_alert(PreviewCard) {
    var alert = new UiNode({ width: "100%", padding: 16, marginBottom: 16 });
    alert.onDraw = method(alert, function() {
        draw_set_color(#FEF2F2); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(#FECACA); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    alert.add(new UiText("Error: Connection to the server failed.", {}, { color: #991B1B }));
    PreviewCard.add(alert);
    return [
        "var alert = new UiNode({ width: \"100%\", padding: 16 });",
        "alert.onDraw = function() {",
        "    draw_set_color(#FEF2F2); // Light red background",
        "    draw_roundrect_ext(x1, y1, x2, y2, 8, 8, false);",
        "    draw_set_color(#FECACA); // Red border",
        "    draw_roundrect_ext(x1, y1, x2, y2, 8, 8, true);",
        "};",
        "alert.add(new UiText(\"Error message\", {}, { color: #991B1B }));"
    ];
}
