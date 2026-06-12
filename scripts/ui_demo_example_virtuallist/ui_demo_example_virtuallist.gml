function ui_demo_example_virtuallist(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Standard - fixed height");
    PreviewCard.add(new UiText(
        "A UiVirtualList with 500 items of equal height. Only ~15 nodes exist in the flexpanel tree.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var dataFixed = [];
    for (var i = 0; i < 500; i++) {
        array_push(dataFixed, { label: "Fixed Item #" + string(i + 1), value: i });
    }

    var _renderFixed = method({ data: dataFixed }, function(index) {
        var node = new UiNode({ width: "100%", height: 40, paddingLeft: 12, justifyContent: "center" }, { pointerEvents: true });
        node.__label = self.data[index].label;
        node.onDraw = method({ node: node }, function() {
            if (self.node.hovered) {
                draw_set_color(global.UI_COL_HOVER);
                draw_roundrect_ext(self.node.x1, self.node.y1, self.node.x2, self.node.y2, 4, 4, false);
            }
            draw_set_color(global.UI_COL_TEXT_2);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(self.node.x1 + 12, ~~mean(self.node.y1, self.node.y2), self.node.__label);
        });
        node.onMouseEnter(function() { global.UI.requestRedraw(); });
        node.onMouseLeave(function() { global.UI.requestRedraw(); });
        return node;
    });
    var _bindFixed = method({ data: dataFixed }, function(index, node) {
        node.__label = self.data[index].label;
    });

    var listFixed = new UiVirtualList({ width: "100%", height: 320, marginBottom: 28, paddingLeft: 8, paddingRight: 8 }, {
        value: dataFixed,
        estimatedItemHeight: 40,
        renderItem: _renderFixed,
        onBind: _bindFixed
    });
    PreviewCard.add(listFixed);

    __ui_demo_preview_section(PreviewCard, "Variable height - 500 items");
    PreviewCard.add(new UiText(
        "Items cycle through 5 distinct heights (40-120 px). Each height group has a unique left accent colour. " +
        "The offset cache tracks measurements and binary search finds the visible window in O(log N).",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var dataVar = [];
    for (var i = 0; i < 500; i++) {
        var h = 40 + (i % 5) * 20;
        array_push(dataVar, { label: "Item #" + string(i + 1), height: h });
    }

    var ACCENT_COLORS = [ #4FC3F7, #81C784, #FFB74D, #E57373, #CE93D8 ];

    var _renderVar = method({ data: dataVar, colors: ACCENT_COLORS }, function(index) {
        var h = self.data[index].height;
        var accent = self.colors[index % 5];
        var node = new UiNode({ width: "100%", height: h, paddingLeft: 8, justifyContent: "center" }, { pointerEvents: true });
        node.__label = self.data[index].label;
        node.__accent = accent;
        node.__height = h;
        node.onDraw = method({ node: node }, function() {
            // Left accent bar
            draw_set_color(self.node.__accent);
            draw_rectangle(self.node.x1, self.node.y1 + 2, self.node.x1 + 4, self.node.y2 - 2, false);

            // Background tint
            var bg = merge_color(global.UI_COL_SURFACE_3, self.node.__accent, 0.12);
            draw_set_color(bg);
            draw_roundrect_ext(self.node.x1 + 4, self.node.y1, self.node.x2, self.node.y2, 4, 4, false);

            // Label
            draw_set_color(global.UI_COL_TEXT_1);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(self.node.x1 + 16, ~~mean(self.node.y1, self.node.y2), self.node.__label + " (" + string(self.node.__height) + "px)");
        });
        return node;
    });
    var _bindVar = method({ data: dataVar, colors: ACCENT_COLORS }, function(index, node) {
        node.__label = self.data[index].label;
        node.__height = self.data[index].height;
        node.__accent = self.colors[index % 5];
        node.setHeight(self.data[index].height);
    });

    var listVar = new UiVirtualList({ width: "100%", height: 320, marginBottom: 28, paddingLeft: 8, paddingRight: 8 }, {
        value: dataVar,
        estimatedItemHeight: 40,
        renderItem: _renderVar,
        onBind: _bindVar
    });
    PreviewCard.add(listVar);

    __ui_demo_preview_section(PreviewCard, "Scroll-to-index API");
    PreviewCard.add(new UiText(
        "Use scrollToIndex() to jump to a specific item.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var _listForJump = listFixed;
    var jumpRow = new UiNode({ flexDirection: "row", width: "100%", alignItems: "center", marginBottom: 12 });
    var jumpInput = new UiTextbox({ width: 100, height: 32, marginRight: 12 }, {
        placeholder: "Index (0–499)",
        value: "0"
    });
    jumpRow.add(jumpInput);
    var jumpBtn = new UiButton("Scroll", { height: 32 }, { variant: "primary" });
    jumpBtn.onClick(method({ list: _listForJump, input: jumpInput }, function() {
        var idx = real(self.input.value);
        self.list.scrollToIndex(idx);
    }));
    jumpRow.add(jumpBtn);
    PreviewCard.add(jumpRow);

    // Info line showing active pool vs total
    PreviewCard.add(new UiText(
        "flexpanel nodes: 2 (spacers) + " + string(listFixed.__poolSize) + " (pool) + 1 scrollbar = " +
        string(3 + listFixed.__poolSize) + " active nodes instead of 500.",
        { width: "100%", marginTop: 8 },
        { color: global.UI_COL_TEXT_2, font: global.UI_FONTS.small, wrap: true }
    ));

    return [
        "// UiVirtualList - virtual scrolling (fixed height)",
        "var data = [];",
        "for (var i = 0; i < 500; i++) {",
        "    array_push(data, { label: \"Item #\" + string(i+1) });",
        "}",
        "",
        "var list = new UiVirtualList({ width: \"100%\", height: 320 }, {",
        "    value: data,",
        "    estimatedItemHeight: 40,",
        "    renderItem: method({ data: data }, function(index) {",
        "        return new UiNode({ width: \"100%\", height: 40 });",
        "    }),",
        "    onBind: method({ data: data }, function(index, node) {",
        "        node.__label = self.data[index].label;",
        "    })",
        "});",
        "",
        "// API",
        "list.scrollToIndex(250);",
        "list.setValue(newData);",
    ];
}
