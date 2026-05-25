function __ui_demo_refresh(preserveScroll = false) {
    var area = global.UI_DEMO.ScrollArea;
    var _oldScroll = area.scrollTop;
    if (global.UI_DEMO.currentPage == "Overview") global.UI_DEMO.currentPage = "Button";
    area.destroyChildren(true);
    global.UI_DEMO.BreadcrumbPage.text = global.UI_DEMO.currentPage;
    
    // Title Section
    var Hero = new UiNode({ width: "100%", flexDirection: "column", marginBottom: 22 });
    area.add(Hero);
    Hero.add(new UiText(global.UI_DEMO.currentPage, { marginBottom: 8, height: 36 }, { color: global.UI_COL_TEXT_MAIN, font: fTextBig })); 
    
    var metadata = __ui_demo_get_component_metadata();
    var componentData = metadata[$ global.UI_DEMO.currentPage];
    var desc = (componentData != undefined ? componentData.desc : "Explore the capabilities of the component " + global.UI_DEMO.currentPage);
    Hero.add(new UiText(desc, {}, { color: global.UI_COL_TEXT_DIM }));
    
    // Tabs — Documentation tab is hidden for foundation pages (Colors, Typography)
    var _isFoundation = (global.UI_DEMO.currentPage == "Colors" || global.UI_DEMO.currentPage == "Typography");

    // If a foundation page lands on Documentation tab, redirect to Preview
    if (_isFoundation && global.UI_DEMO.currentTab == "Documentation") {
        global.UI_DEMO.currentTab = "Preview";
    }

    var PreviewPanel = new UiNode({ width: "100%", height: "100%", flexDirection: "column" });
    __ui_demo_render_anteprima(PreviewPanel);

    var tabsItems = [
        { label: "Preview", content: PreviewPanel }
    ];

    if (!_isFoundation) {
        var DocsPanel = new UiNode({ width: "100%", height: "100%", flexDirection: "column" });
        DocsPanel.enableScrollbar(function() { return global.UI_COL_SCROLLBAR_THUMB; });
        __ui_demo_render_documentazione(DocsPanel);
        array_push(tabsItems, { label: "Documentation", content: DocsPanel });
    }

    var _selectedIndex = (global.UI_DEMO.currentTab == "Documentation" && !_isFoundation) ? 1 : 0;
    var DemoTabs = new UiTabs(tabsItems, { width: "100%", flex: 1, marginBottom: 0 }, {
        selectedIndex: _selectedIndex,
        variant: "underline",
        onChange: function(index, label) {
            global.UI_DEMO.currentTab = label;
        }
    });
    area.add(DemoTabs);
    
    if (preserveScroll) area.scrollTop = _oldScroll; else area.scrollTop = 0;
    
    global.UI.requestUpdate();
}

function __ui_demo_render_documentazione(area) {
    var metadata = __ui_demo_get_component_metadata();
    var componentData = metadata[$ global.UI_DEMO.currentPage];
    
    var Doc = new UiNode({ width: "100%", flexDirection: "column" });
    area.add(Doc);
    
    Doc.add(new UiText("Usage", { marginBottom: 16, height: 28 }, { color: global.UI_COL_TEXT_MAIN }));
    Doc.add(new UiText("The " + global.UI_DEMO.currentPage + " component is designed to be highly customizable.", { marginBottom: 32 }, { color: global.UI_COL_TEXT_DIM }));
    
    if (componentData != undefined && variable_struct_exists(componentData, "props")) {
        Doc.add(new UiText("Properties", { marginBottom: 16, height: 28 }, { color: global.UI_COL_TEXT_MAIN }));
        var Table = new UiNode({ width: "100%", flexDirection: "column", padding: 16 });
        Table.onDraw = method(Table, function() {
            draw_set_color(global.UI_COL_INPUT_BG);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        });
        Doc.add(Table);
        
        var props = componentData.props;
        for (var i = 0; i < array_length(props); i++) {
            var p = props[i];
            __ui_demo_doc_row(Table, p.name, p.type, p.desc);
        }
    } else {
        Doc.add(new UiText("No specific properties documented for this component.", { marginBottom: 32 }, { color: global.UI_COL_TEXT_DIM }));
    }
}

function __ui_demo_doc_row(parent, name, type, desc) {
    var Row = new UiNode({ flexDirection: "row", marginBottom: 12, width: "100%" });
    Row.add(new UiText(name, { width: 220 }, { color: global.UI_COL_PRIMARY }));
    Row.add(new UiText(type, { width: 120 }, { color: global.UI_COL_TEXT_DIM }));
    Row.add(new UiText(desc, { flex: 1 }, { color: global.UI_COL_TEXT_DIM, wrap: true }));
    parent.add(Row);
}



function __ui_demo_render_anteprima(area) {
    var MainRow = new UiNode({ 
        flexDirection: "row", 
        width: "100%",
        height: "100%"
    });
    area.add(MainRow);
    
    var PreviewCard = new UiNode({
        width: "60%", 
        height: "100%",
        padding: 30,
        marginRight: 20,
        flexDirection: "column"
    });
    PreviewCard.enableScrollbar(function() { return global.UI_COL_SCROLLBAR_THUMB; });
    PreviewCard.enableHorizontalScrollbar(function() { return global.UI_COL_SCROLLBAR_THUMB; });
    PreviewCard.onDraw = method(PreviewCard, function() {
        draw_set_color(global.UI_COL_BG_CARD);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    MainRow.add(PreviewCard);
    
    var codeLines = __ui_demo_render_component_example(global.UI_DEMO.currentPage, PreviewCard);
    
    // Code Panel
    var CodePanel = new UiNode({ flexGrow: 1, height: "100%", padding: 24, flexDirection: "column" });
    CodePanel.onDraw = method(CodePanel, function() {
        draw_set_color(#142033);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
    });
    CodePanel.enableScrollbar(#818CF8);
    CodePanel.enableHorizontalScrollbar(#818CF8);
    MainRow.add(CodePanel);

    __ui_demo_add_code_lines(CodePanel, codeLines);
}

function __ui_demo_preview_section(parent, title, mt = 0) {
    parent.add(new UiText(title, { marginTop: mt, marginBottom: 8, height: 28 }, { color: global.UI_COL_TEXT_MAIN }));
}

function __ui_demo_render_component_example(page, parent) {
    var examples = __ui_demo_get_examples_map();
    var exampleFunc = examples[$ page];
    
    if (exampleFunc != undefined) {
        return exampleFunc(parent);
    }
    
    parent.add(new UiText("Preview for " + page + " coming soon.", {}, { color: global.UI_COL_TEXT_DIM }));
    return ["// Example not available"];
}

function __ui_demo_get_examples_map() {
    static _map = {
        "Colors":      ui_demo_example_colors,
        "Typography":  ui_demo_example_typography,
        "Button":      ui_demo_example_button,
        "Textbox":     ui_demo_example_textbox,
        "Textarea":    ui_demo_example_textarea,
        "Checkbox":    ui_demo_example_checkbox,
        "Radio":       ui_demo_example_radio,
        "Switch":      ui_demo_example_switch,
        "Select":      ui_demo_example_dropdown,
        "ColorPicker": ui_demo_example_colorpicker,
        "Badge":       ui_demo_example_badge,
        "Alert":       ui_demo_example_alert,
        "Card":        ui_demo_example_card,
        "Tabs":        ui_demo_example_tabs,
        "Accordion":   ui_demo_example_accordion,
        "Slider":      ui_demo_example_slider,
        "Sprite":      ui_demo_example_sprite,
        "ContextMenu": ui_demo_example_contextmenu,
        "Tooltip":     ui_demo_example_tooltip,
        "Treeview":    ui_demo_example_treeview,
        "Modal":       ui_demo_example_modal
    };
    return _map;
}

function __ui_demo_render_overview(area) {
    var Body = new UiNode({ flexDirection: "row", width: "100%", alignItems: "flex-start" });
    area.add(Body);
    
    var Grid = new UiNode({ flex: 1, flexDirection: "column", marginRight: 24 });
    Body.add(Grid);
    
    var Row1 = new UiNode({ width: "100%", flexDirection: "row", marginBottom: 14 });
    Grid.add(Row1);
    var ButtonsCard = __ui_demo_overview_card(Row1, "Buttons", { flexGrow: 2, marginRight: 14 });
    __ui_demo_overview_buttons(ButtonsCard);
    var SwitchCard = __ui_demo_overview_card(Row1, "Switch", { flexGrow: 1 });
    __ui_demo_overview_switches(SwitchCard);
    
    var Row2 = new UiNode({ width: "100%", flexDirection: "row", marginBottom: 14 });
    Grid.add(Row2);
    var RadioCard = __ui_demo_overview_card(Row2, "Radio", { flexGrow: 2, marginRight: 14 });
    __ui_demo_overview_radio(RadioCard);
    var CheckCard = __ui_demo_overview_card(Row2, "Checkbox", { flexGrow: 1 });
    __ui_demo_overview_checkbox(CheckCard);
    
    var Row3 = new UiNode({ width: "100%", flexDirection: "row", marginBottom: 14 });
    Grid.add(Row3);
    var SelectCard = __ui_demo_overview_card(Row3, "Select", { flexGrow: 1, marginRight: 14 });
    __ui_demo_overview_select(SelectCard);
    var BadgeCard = __ui_demo_overview_card(Row3, "Badge", { flexGrow: 1 });
    __ui_demo_overview_badges(BadgeCard);
    
    var Row4 = new UiNode({ width: "100%", flexDirection: "row", marginBottom: 14 });
    Grid.add(Row4);
    var AlertCard = __ui_demo_overview_card(Row4, "Alert", { flexGrow: 1, marginRight: 14 });
    __ui_demo_overview_alerts(AlertCard);
    var TextareaCard = __ui_demo_overview_card(Row4, "Textarea", { flexGrow: 1 });
    TextareaCard.add(new UiTextarea({ width: "100%", height: 120 }, { placeholder: "Enter your message..." }));
    
    var TabsCard = __ui_demo_overview_card(Grid, "Tabs", { width: "100%" });
    var TabOneContent = new UiNode({ width: "100%" });
    TabOneContent.add(new UiText("This is the content for Tab One.", { width: "100%" }, { color: "main", wrap: true }));
    var TabTwoContent = new UiNode({ width: "100%" });
    TabTwoContent.add(new UiText("Content for Tab Two.", { width: "100%" }, { color: "main", wrap: true }));
    var TabThreeContent = new UiNode({ width: "100%" });
    TabThreeContent.add(new UiText("Content for Tab Three.", { width: "100%" }, { color: "main", wrap: true }));
    TabsCard.add(new UiTabs([
        { label: "Tab One", content: TabOneContent },
        { label: "Tab Two", content: TabTwoContent },
        { label: "Tab Three", content: TabThreeContent }
    ], { width: "100%" }, { selectedIndex: 0 }));
    
    var CodePanel = __ui_demo_code_panel("Example Code", 704, 372);
    Body.add(CodePanel);
    __ui_demo_add_code_lines(CodePanel, [
        "new UiButton(\"Primary\", {}, { variant: \"primary\" });",
        "new UiButton(\"Secondary\", {}, { variant: \"secondary\" });",
        "new UiButton(\"Outline\", {}, { variant: \"outline\" });",
        "",
        "new UiSwitch(true);",
        "new UiCheckbox(\"Option A\", true);",
        "new UiCheckbox(\"Option B\", false);",
        "new UiRadio({",
        "  label: \"Option A\",",
        "  group: \"group1\"",
        "});",
        "",
        "new UiSelect({",
        "  placeholder: \"Choose an option\",",
        "  items: [\"Option 1\", \"Option 2\", \"Option 3\"]",
        "});",
        "",
        "new UiBadge(\"Success\", { variant: \"success\" });",
        "new UiAlert(\"This is an informational alert.\", {",
        "  variant: \"info\"",
        "});",
        "new UiTextarea({ placeholder: \"Enter your message...\" });",
        "",
        "new UiTabs([",
        "    { label: \"Tab One\", content: \"This is the content for Tab One.\" },",
        "    { label: \"Tab Two\", content: \"Content for Tab Two.\" },",
        "    { label: \"Tab Three\", content: \"Content for Tab Three.\" }",
        "], {}, { selectedIndex: 0 });"
    ]);
}

function __ui_demo_overview_card(parent, title, layout = {}) {
    var _style = {
        marginRight: layout[$ "marginRight"] ?? 0,
        paddingLeft: layout[$ "paddingLeft"] ?? 16,
        paddingRight: layout[$ "paddingRight"] ?? 16,
        paddingTop: layout[$ "paddingTop"] ?? 15,
        paddingBottom: layout[$ "paddingBottom"] ?? 16,
        flexDirection: "column"
    };
    if (layout[$ "width"] != undefined) _style.width = layout[$ "width"];
    if (layout[$ "height"] != undefined) _style.height = layout[$ "height"];
    if (layout[$ "flex"] != undefined) _style.flex = layout[$ "flex"];
    if (layout[$ "flexGrow"] != undefined) _style.flexGrow = layout[$ "flexGrow"];
    if (layout[$ "flexShrink"] != undefined) _style.flexShrink = layout[$ "flexShrink"];
    
    var Card = new UiNode(_style);
    Card.onDraw = method(Card, function() {
        draw_set_color(global.UI_COL_BG_CARD);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    parent.add(Card);
    Card.add(new UiText(title, { height: 22, marginBottom: 12 }, { color: "main" }));
    return Card;
}

function __ui_demo_overview_buttons(parent) {
    var row1 = new UiNode({ flexDirection: "row", marginBottom: 12, flexWrap: "wrap" });
    parent.add(row1);
    row1.add(new UiButton("Primary", { height: 30, marginRight: 10, marginBottom: 8 }, { variant: "primary" }));
    row1.add(new UiButton("Secondary", { height: 30, marginRight: 10, marginBottom: 8 }, { variant: "secondary" }));
    row1.add(new UiButton("Outline", { height: 30, marginRight: 10, marginBottom: 8 }, { variant: "outline" }));
    row1.add(new UiButton("Ghost", { height: 30, marginRight: 10, marginBottom: 8 }, { variant: "ghost" }));
    row1.add(new UiButton("Danger", { height: 30, marginBottom: 8 }, { variant: "danger" }));
    
    var row2 = new UiNode({ flexDirection: "row" });
    parent.add(row2);
    row2.add(new UiButton("Small", { height: 28, marginRight: 12 }, { variant: "outline" }));
    row2.add(new UiButton("Medium", { height: 32, marginRight: 12 }, { variant: "primary" }));
    row2.add(new UiButton("Large", { height: 36 }, { variant: "outline" }));
}

function __ui_demo_overview_switches(parent) {
    parent.add(new UiSwitch({ marginBottom: 16 }, { label: "Enabled", value: true }));
    parent.add(new UiSwitch({}, { label: "Disabled", value: false }));
}

function __ui_demo_overview_radio(parent) {
    parent.add(new UiText("Pick an option:", { marginBottom: 12 }, { color: "main" }));
    parent.add(new UiRadio({ marginBottom: 12 }, { label: "Option A", group: "overview", value: true }));
    parent.add(new UiRadio({}, { label: "Option B", group: "overview", value: false }));
}

function __ui_demo_overview_checkbox(parent) {
    parent.add(new UiCheckbox({ marginBottom: 16 }, { label: "Option A", value: true }));
    parent.add(new UiCheckbox({}, { label: "Option B", value: false }));
}

function __ui_demo_overview_select(parent) {
    parent.add(new UiDropdown({ width: "100%", height: 36 }, {
        value: "one",
        placeholder: "Choose an option",
        items: [
            { label: "Option 1", value: "one" },
            { label: "Option 2", value: "two" },
            { label: "Option 3", value: "three" }
        ]
    }));
}

function __ui_demo_overview_badges(parent) {
    var row = new UiNode({ flexDirection: "row", flexWrap: "wrap" });
    parent.add(row);
    row.add(new UiBadge("Default", { marginRight: 10, marginBottom: 8 }, { variant: "default" }));
    row.add(new UiBadge("Success", { marginRight: 10, marginBottom: 8 }, { variant: "success" }));
    row.add(new UiBadge("Warning", { marginRight: 10, marginBottom: 8 }, { variant: "warning" }));
    row.add(new UiBadge("Error", { marginBottom: 8 }, { variant: "danger" }));
}

function __ui_demo_overview_alerts(parent) {
    __ui_demo_overview_alert_row(parent, "This is an informational alert.", #EAF2FF, #BAD3FF, #2F6FEF, #1E40AF, 6);
    __ui_demo_overview_alert_row(parent, "This is a success alert.", #EAF8EF, #BDECCF, #23A75A, #166534, 6);
    __ui_demo_overview_alert_row(parent, "This is a warning alert.", #FFF4E5, #FFD8A5, #D97706, #92400E, 0);
}

function __ui_demo_overview_alert_row(parent, text, bg, border, icon, textCol, mb) {
    var row = new UiNode({ width: "100%", height: 36, marginBottom: mb, paddingLeft: 36, justifyContent: "center" });
    row.__text = text;
    row.__bg = bg;
    row.__border = border;
    row.__icon = icon;
    row.__textCol = textCol;
    row.onDraw = method(row, function() {
        draw_set_color(self.__bg);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 5, 5, false);
        draw_set_color(self.__border);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 5, 5, true);
        
        var iconCX = self.x1 + 18;
        var iconCY = ~~mean(self.y1, self.y2);
        var col = self.__icon;
        
        // Draw vector-like shapes matching Screen 1 mockup
        if (string_pos("informational", self.__text) > 0) {
            // Globe icon for info
            draw_set_color(col);
            draw_circle(iconCX, iconCY, 6, true);
            draw_ellipse(iconCX - 3, iconCY - 6, iconCX + 3, iconCY + 6, true);
            draw_line(iconCX - 6, iconCY, iconCX + 6, iconCY);
        } else if (string_pos("success", self.__text) > 0) {
            // Check circle for success
            draw_set_color(col);
            draw_circle(iconCX, iconCY, 6, true);
            draw_line_width(iconCX - 3, iconCY, iconCX - 1, iconCY + 2, 1.5);
            draw_line_width(iconCX - 1, iconCY + 2, iconCX + 3, iconCY - 2, 1.5);
        } else if (string_pos("warning", self.__text) > 0) {
            // Warning triangle for warning
            if (sprite_exists(sprUiIconAlert)) {
                var target_size = 14;
                var spr_w = sprite_get_width(sprUiIconAlert);
                var spr_h = sprite_get_height(sprUiIconAlert);
                draw_sprite_ext(sprUiIconAlert, 0, iconCX, iconCY, target_size / spr_w, target_size / spr_h, 0, col, 1);
            } else {
                draw_set_color(col);
                draw_circle(iconCX, iconCY, 6, true);
            }
        }
        
        draw_set_font(fTextSmall);
        draw_set_color(self.__textCol);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(self.x1 + 36, ~~mean(self.y1, self.y2), self.__text);
    });
    parent.add(row);
}

function __ui_demo_code_panel(title, height, width = undefined) {
    var _style = { height: height, padding: 18, flexDirection: "column", flexShrink: 0 };
    if (width != undefined) {
        _style.width = width;
    } else {
        _style.flex = 1;
    }
    
    var Panel = new UiNode(_style);
    Panel.__copyText = "";
    Panel.onDraw = method(Panel, function() {
        draw_set_color(#142033);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
    });
    Panel.enableScrollbar(#5166A6);
    Panel.enableHorizontalScrollbar(#5166A6);
    var Header = new UiNode({ width: "100%", height: 34, flexDirection: "row", alignItems: "center", marginBottom: 12 });
    Panel.add(Header);
    Header.add(new UiText(title, { flex: 1 }, { color: function() { return #FFFFFF; } }));
    var Copy = new UiNode({ width: 74, height: 28 }, { pointerEvents: true, handpoint: true });
    Copy.onMouseEnter(function() { global.UI.requestRedraw(); });
    Copy.onMouseLeave(function() { global.UI.requestRedraw(); });
    Copy.onDraw = method(Copy, function() {
        draw_set_color(self.hovered ? #253650 : #1B2A42);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
        draw_set_color(#334966);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, true);
        draw_set_color(#DDE7F7);
        draw_rectangle(self.x1 + 13, self.y1 + 8, self.x1 + 21, self.y1 + 18, true);
        draw_rectangle(self.x1 + 16, self.y1 + 6, self.x1 + 24, self.y1 + 16, true);
        draw_set_font(fTextSmall);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(self.x1 + 32, ~~mean(self.y1, self.y2), "Copy");
    });
    Copy.onClick(method(Copy, function() {
        var _panel = self.parent.parent;
        clipboard_set_text(_panel.__copyText ?? "");
    }));
    Header.add(Copy);
    return Panel;
}

function __ui_demo_add_code_lines(parent, lines) {
    parent.__copyText = "";
    for (var i = 0; i < array_length(lines); i++) {
        if (i > 0) parent.__copyText += "\n";
        parent.__copyText += lines[i];

        if (lines[i] == "") {
            parent.add(new UiNode({ width: "100%", height: 10, marginBottom: 4 }));
            continue;
        }

        var col = #8AB4FF;
        if (string_pos("//", lines[i]) == 1) col = #6B7C99;
        parent.add(new UiText(lines[i], { marginBottom: 7, width: "100%" }, { color: col, font: fTextSmall, wrap: true }));
    }
}
