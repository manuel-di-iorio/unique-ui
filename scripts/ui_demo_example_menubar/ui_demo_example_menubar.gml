function ui_demo_example_menubar(PreviewCard) {

    // --- Intro ---
    PreviewCard.add(new UiText(
        "UiMenuBar renders a horizontal application-style menu bar. Each top-level label opens " +
        "a dropdown panel with items, separators, shortcuts, and disabled states. " +
        "When a dropdown is open, hovering over another label immediately switches to it.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    // --- Live demo ---
    __ui_demo_preview_section(PreviewCard, "Interactive Demo");

    // Status text to show last action
    var statusNode = new UiNode({
        width: "100%",
        height: 28,
        marginBottom: 16,
        justifyContent: "center",
        alignItems: "center"
    });
    statusNode.__msg = "Click a menu item to see it here";
    statusNode.setMsg = function(msg) {
        self.__msg = msg;
        global.UI.requestRedraw();
    };
    statusNode.onDraw = method(statusNode, function() {
        draw_set_color(global.UI_COL_SURFACE_2);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, true);
        draw_set_font(global.UI_FONTS.small);
        draw_set_color(global.UI_COL_TEXT_2);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.__msg);
    });

    var menuBar = new UiMenuBar([
        {
            label: "File",
            items: [
                { label: "New File",    onClick: method(statusNode, function() { self.setMsg("File → New File"); }),    shortcut: "Ctrl+N" },
                { label: "Open...",       onClick: method(statusNode, function() { self.setMsg("File → Open…"); }),       shortcut: "Ctrl+O" },
                { label: "Save",        onClick: method(statusNode, function() { self.setMsg("File → Save"); }),        shortcut: "Ctrl+S" },
                { label: "Save As...",    onClick: method(statusNode, function() { self.setMsg("File → Save As…"); }),   shortcut: "Ctrl+Shift+S" },
                { separator: true },
                { label: "Export",      onClick: method(statusNode, function() { self.setMsg("File → Export"); }) },
                { separator: true },
                { label: "Exit",        onClick: method(statusNode, function() { self.setMsg("File → Exit"); }),       shortcut: "Alt+F4", disabled: false }
            ]
        },
        {
            label: "Edit",
            items: [
                { label: "Undo",   onClick: method(statusNode, function() { self.setMsg("Edit → Undo"); }),   shortcut: "Ctrl+Z" },
                { label: "Redo",   onClick: method(statusNode, function() { self.setMsg("Edit → Redo"); }),   shortcut: "Ctrl+Y" },
                { separator: true },
                { label: "Cut",    onClick: method(statusNode, function() { self.setMsg("Edit → Cut"); }),    shortcut: "Ctrl+X" },
                { label: "Copy",   onClick: method(statusNode, function() { self.setMsg("Edit → Copy"); }),   shortcut: "Ctrl+C" },
                { label: "Paste",  onClick: method(statusNode, function() { self.setMsg("Edit → Paste"); }),  shortcut: "Ctrl+V" },
                { separator: true },
                { label: "Select All", onClick: method(statusNode, function() { self.setMsg("Edit → Select All"); }), shortcut: "Ctrl+A" }
            ]
        },
        {
            label: "View",
            items: [
                { label: "Zoom In",     onClick: method(statusNode, function() { self.setMsg("View → Zoom In"); }),   shortcut: "Ctrl+=" },
                { label: "Zoom Out",    onClick: method(statusNode, function() { self.setMsg("View → Zoom Out"); }),  shortcut: "Ctrl+-" },
                { label: "Reset Zoom",  onClick: method(statusNode, function() { self.setMsg("View → Reset Zoom"); }),shortcut: "Ctrl+0" },
                { separator: true },
                { label: "Fullscreen",  onClick: method(statusNode, function() { self.setMsg("View → Fullscreen"); }), shortcut: "F11" },
                { label: "Inspector (Unavailable)", onClick: undefined, disabled: true }
            ]
        },
        {
            label: "Help",
            items: [
                { label: "Documentation", onClick: method(statusNode, function() { self.setMsg("Help → Documentation"); }) },
                { label: "Release Notes", onClick: method(statusNode, function() { self.setMsg("Help → Release Notes"); }) },
                { separator: true },
                { label: "About UniqueUI", onClick: method(statusNode, function() { self.setMsg("Help → About UniqueUI"); }) }
            ]
        }
    ], { width: "100%", height: 34 }, {});

    // Window chrome: menu bar + content
    var demoCard = new UiNode({
        width: "100%",
        flexDirection: "column",
        marginBottom: 28
    });
    demoCard.onDraw = method(demoCard, function() {
        draw_set_color(global.UI_COL_SURFACE_3);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });

    demoCard.add(menuBar);

    var demoBody = new UiNode({ width: "100%", padding: 16, flexDirection: "column" });
    demoBody.add(statusNode);

    // Fake "window content" area
    var contentArea = new UiNode({ width: "100%", height: 80, justifyContent: "center", alignItems: "center" });
    contentArea.onDraw = method(contentArea, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, true);
        draw_set_font(global.UI_FONTS.small);
        draw_set_color(global.UI_COL_TEXT_2);
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2),
            "Application content area");
    });
    demoBody.add(contentArea);
    demoCard.add(demoBody);
    PreviewCard.add(demoCard);

    // --- Disabled items ---
    __ui_demo_preview_section(PreviewCard, "Disabled Items", 4);
    PreviewCard.add(new UiText(
        "Set disabled: true on any item to make it non-interactive. It renders at reduced opacity " +
        "and ignores clicks. In the View menu above, try 'Inspector (Unavailable)'.",
        { width: "100%", marginBottom: 28 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    return [
        "var menuBar = new UiMenuBar([",
        "  {",
        "    label: \"File\",",
        "    items: [",
        "      { label: \"New\",  onClick: function() { ... }, shortcut: \"Ctrl+N\" },",
        "      { label: \"Open\", onClick: function() { ... }, shortcut: \"Ctrl+O\" },",
        "      { separator: true },",
        "      { label: \"Exit\", onClick: function() { ... }, disabled: true }",
        "    ]",
        "  },",
        "  {",
        "    label: \"Edit\",",
        "    items: [",
        "      { label: \"Undo\", onClick: function() { ... }, shortcut: \"Ctrl+Z\" },",
        "      { label: \"Redo\", onClick: function() { ... }, shortcut: \"Ctrl+Y\" }",
        "    ]",
        "  }",
        "], { width: \"100%\", height: 30 }, {});",
        "",
        "// Hover over another top-level label while",
        "// a dropdown is open to switch immediately.",
        "",
        "// Close programmatically:",
        "menuBar.closeAll();"
    ];
}
