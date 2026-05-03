function __ui_demo_refresh(preserveScroll = false) {
    var area = global.UI_DEMO.ScrollArea;
    var _oldScroll = area.scrollTop;
    area.destroyChildren(true);
    global.UI_DEMO.BreadcrumbPage.text = global.UI_DEMO.currentPage;
    
    // Title Section
    var Hero = new UiNode({ width: "100%", flexDirection: "column", marginBottom: 32 });
    area.add(Hero);
    Hero.add(new UiText(global.UI_DEMO.currentPage, { marginBottom: 8, height: 40 }, { color: #0F172A, font: fText })); 
    
    var metadata = __ui_demo_get_component_metadata();
    var componentData = metadata[$ global.UI_DEMO.currentPage];
    var desc = componentData != undefined ? componentData.desc : "Explore the capabilities of the component " + global.UI_DEMO.currentPage;
    Hero.add(new UiText(desc, {}, { color: #64748B }));
    
    // Tabs — Documentation tab is hidden for foundation pages (Colors, Typography)
    var _isFoundation = (global.UI_DEMO.currentPage == "Colors" || global.UI_DEMO.currentPage == "Typography");
    var TabRow = new UiNode({ flexDirection: "row", width: "100%", marginBottom: 32 });
    TabRow.onDraw = method(TabRow, function() {
        draw_set_color(global.UI_COL_BORDER);
        draw_line(self.x1, self.y2, self.x2, self.y2);
    });
    area.add(TabRow);
    __ui_demo_tab_item(TabRow, "Preview");
    if (!_isFoundation) __ui_demo_tab_item(TabRow, "Documentation");
    __ui_demo_tab_item(TabRow, "Performance");
    
    // If a foundation page lands on Documentation tab, redirect to Preview
    if (_isFoundation && global.UI_DEMO.currentTab == "Documentation") {
        global.UI_DEMO.currentTab = "Preview";
    }
    
    if (global.UI_DEMO.currentTab == "Preview") {
        area.enableScrollbar(global.UI_COL_PRIMARY);
        __ui_demo_render_anteprima(area);
    } else if (global.UI_DEMO.currentTab == "Documentation") {
        area.enableScrollbar(global.UI_COL_PRIMARY);
        __ui_demo_render_documentazione(area);
    } else {
        area.enableScrollbar(global.UI_COL_PRIMARY);
        __ui_demo_render_performance(area);
    }
    
    global.UI.update();
    if (preserveScroll) area.scrollTop = _oldScroll; else area.scrollTop = 0;
    
    global.UI.requestUpdate();
}

function __ui_demo_render_documentazione(area) {
    var metadata = __ui_demo_get_component_metadata();
    var componentData = metadata[$ global.UI_DEMO.currentPage];
    
    var Doc = new UiNode({ width: "100%", flexDirection: "column" });
    area.add(Doc);
    
    Doc.add(new UiText("Usage", { marginBottom: 16, height: 28 }, { color: #0F172A }));
    Doc.add(new UiText("The " + global.UI_DEMO.currentPage + " component is designed to be highly customizable.", { marginBottom: 32 }, { color: #64748B }));
    
    if (componentData != undefined && variable_struct_exists(componentData, "props")) {
        Doc.add(new UiText("Properties", { marginBottom: 16, height: 28 }, { color: #0F172A }));
        var Table = new UiNode({ width: "100%", flexDirection: "column", padding: 16 });
        Table.onDraw = method(Table, function() {
            draw_set_color(#F8FAFC);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        });
        Doc.add(Table);
        
        var props = componentData.props;
        for (var i = 0; i < array_length(props); i++) {
            var p = props[i];
            __ui_demo_doc_row(Table, p.name, p.type, p.desc);
        }
    } else {
        Doc.add(new UiText("No specific properties documented for this component.", { marginBottom: 32 }, { color: #64748B }));
    }
}

function __ui_demo_doc_row(parent, name, type, desc) {
    var Row = new UiNode({ flexDirection: "row", marginBottom: 12, width: "100%" });
    Row.add(new UiText(name, { width: 220 }, { color: global.UI_COL_PRIMARY }));
    Row.add(new UiText(type, { width: 90 }, { color: #94A3B8 }));
    Row.add(new UiText(desc, { flex: 1 }, { color: #64748B, wrap: true }));
    parent.add(Row);
}

function __ui_demo_render_performance(area) {
    var Perf = new UiNode({ width: "100%", flexDirection: "column" });
    area.add(Perf);
    
    Perf.add(new UiText("Live Performance", { marginBottom: 8, height: 28 }, { color: #0F172A }));
    Perf.add(new UiText("Real-time runtime metrics of the current component. Interact with the sandbox to stress input, rendering, and layout.", { marginBottom: 20 }, { color: #64748B }));
    
    global.UI_DEMO.PerfLive = {
        lastTime: current_time,
        frameMs: 0,
        fps: 0,
        fpsAvg: 0,
        fpsLow: 0,
        sampleCount: 0,
        redrawFrames: 0,
        updateFrames: 0,
        totalNodes: 0,
        visibleNodes: 0,
        interactiveNodes: 0,
        sandboxNodes: 0
    };
    
    var Health = new UiNode({ width: "100%", padding: 16, marginBottom: 20, flexDirection: "column" });
    Health.onDraw = method(Health, function() {
        draw_set_color(#F8FAFC);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
    });
    Perf.add(Health);
    Health.add(new UiText("", { marginBottom: 8 }, { color: #0F172A, valueGetter: function() {
        var p = global.UI_DEMO.PerfLive;
        return "FPS: " + string_format(p.fps, 1, 1) + "   Avg: " + string_format(p.fpsAvg, 1, 1) + "   1% Low~: " + string_format(p.fpsLow, 1, 1);
    }}));
    Health.add(new UiText("", { marginBottom: 8 }, { color: #64748B, valueGetter: function() {
        var p = global.UI_DEMO.PerfLive;
        return "Frame: " + string_format(p.frameMs, 1, 2) + " ms   UpdateFrames: " + string(p.updateFrames) + "   RedrawFrames: " + string(p.redrawFrames);
    }}));
    Health.add(new UiText("", {}, { color: #64748B, valueGetter: function() {
        var p = global.UI_DEMO.PerfLive;
        return "Nodes -> total: " + string(p.totalNodes) + " | visible: " + string(p.visibleNodes) + " | interactive: " + string(p.interactiveNodes) + " | sandbox: " + string(p.sandboxNodes);
    }}));
    
    Perf.add(new UiText("Component Sandbox", { marginBottom: 10, height: 28 }, { color: #0F172A }));
    
    var Box = new UiNode({ width: "100%", height: 320, padding: 18, marginBottom: 16, flexDirection: "column" });
    Box.onDraw = method(Box, function() {
        draw_set_color(c_white);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    Box.enableScrollbar(global.UI_COL_PRIMARY);
    Box.enableHorizontalScrollbar(global.UI_COL_PRIMARY);
    Perf.add(Box);
    __ui_demo_render_component_example(global.UI_DEMO.currentPage, Box);
    
    Perf.onStep(method({ boxRef: Box }, function() {
        var p = global.UI_DEMO.PerfLive;
        if (p == undefined) return;
        
        var now = current_time;
        var delta = max(1, now - p.lastTime);
        p.lastTime = now;
        p.frameMs = delta;
        p.fps = 1000 / delta;
        
        p.sampleCount += 1;
        if (p.sampleCount == 1) {
            p.fpsAvg = p.fps;
            p.fpsLow = p.fps;
        } else {
            p.fpsAvg = lerp(p.fpsAvg, p.fps, 0.08);
            p.fpsLow = min(p.fpsLow * 0.995 + p.fps * 0.005, p.fps);
        }
        
        if (global.UI.needsUpdate) p.updateFrames += 1;
        if (global.UI.needsRedraw) p.redrawFrames += 1;
        
        p.totalNodes = global.UI.countAll();
        p.sandboxNodes = boxRef.countAll();
        
        var counters = { visible: 0, interactive: 0 };
        global.UI.traverse(method(counters, function(node) {
            if (node.isVisible()) self.visible += 1;
            if (node.pointerEvents) self.interactive += 1;
        }), true);
        
        p.visibleNodes = counters.visible;
        p.interactiveNodes = counters.interactive;
    }));
}

function __ui_demo_tab_item(parent, text) {
    var isActive = (text == global.UI_DEMO.currentTab);
    var tab = new UiNode({ paddingLeft: 16, paddingRight: 16, height: 40, justifyContent: "center" });
    tab.pointerEvents = true; tab.handpoint = true;
    tab.__isActive = isActive;
    tab.onDraw = method(tab, function() {
        if (self.__isActive) {
            draw_set_color(global.UI_COL_PRIMARY);
            draw_line_width(self.x1, self.y2, self.x2, self.y2, 2);
        }
    });
    tab.add(new UiText(text, {}, { color: isActive ? global.UI_COL_PRIMARY : #64748B }));
    tab.onClick(method({ text }, function() {
        global.UI_DEMO.currentTab = text;
        __ui_demo_refresh();
    }));
    parent.add(tab);
}

function __ui_demo_render_anteprima(area) {
    var MainRow = new UiNode({ 
        flexDirection: "row", 
        width: "100%",
        flex: 1
    });
    area.add(MainRow);
    
    var PreviewCard = new UiNode({
        width: "60%", 
        padding: 30,
        marginRight: 20,
        flexDirection: "column"
    });
    PreviewCard.enableScrollbar(global.UI_COL_PRIMARY);
    PreviewCard.enableHorizontalScrollbar(global.UI_COL_PRIMARY);
    PreviewCard.onDraw = method(PreviewCard, function() {
        draw_set_color(c_white);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, true);
    });
    MainRow.add(PreviewCard);
    
    var codeLines = __ui_demo_render_component_example(global.UI_DEMO.currentPage, PreviewCard);
    
    // Code Panel
    var CodePanel = new UiNode({ flex: 1, padding: 24, flexDirection: "column" });
    CodePanel.onDraw = method(CodePanel, function() {
        draw_set_color(#1E293B);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, false);
    });
    CodePanel.enableScrollbar(#818CF8);
    CodePanel.enableHorizontalScrollbar(#818CF8);
    MainRow.add(CodePanel);
    
    for (var i = 0; i < array_length(codeLines); i++) {
        CodePanel.add(new UiText(codeLines[i], { marginBottom: 12, width: 800, height: 24 }, { color: #818CF8, font: fTextSmall }));
    }
}

function __ui_demo_preview_section(parent, title, mt = 0) {
    parent.add(new UiText(title, { marginTop: mt, marginBottom: 16, height: 28 }, { color: #0F172A }));
}

function __ui_demo_render_component_example(page, parent) {
    var examples = __ui_demo_get_examples_map();
    var exampleFunc = examples[$ page];
    
    if (exampleFunc != undefined) {
        return exampleFunc(parent);
    }
    
    parent.add(new UiText("Preview for " + page + " coming soon.", {}, { color: #64748B }));
    return ["// Example not available"];
}

function __ui_demo_get_examples_map() {
    static _map = {
        "Colors":      ui_demo_example_colors,
        "Typography":  ui_demo_example_typography,
        "Button":      ui_demo_example_button,
        "Textbox":     ui_demo_example_textbox,
        "Checkbox":    ui_demo_example_checkbox,
        "Radio":       ui_demo_example_radio,
        "Switch":      ui_demo_example_switch,
        "Select":      ui_demo_example_dropdown,
        "Badge":       ui_demo_example_badge,
        "Alert":       ui_demo_example_alert,
        "Card":        ui_demo_example_card,
        "Tabs":        ui_demo_example_tabs,
        "Accordion":   ui_demo_example_accordion,
        "Slider":      ui_demo_example_slider,
        "Sprite":      ui_demo_example_sprite,
        "ContextMenu": ui_demo_example_contextmenu,
        "Tooltip":     ui_demo_example_tooltip,
        "Treeview":    ui_demo_example_treeview
    };
    return _map;
}
