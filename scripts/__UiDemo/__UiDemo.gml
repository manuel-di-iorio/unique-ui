/// @desc UI Demo - AAA Showcase of all UniqueUI components
function ui_demo_create() {
    var W = display_get_gui_width();
    var H = display_get_gui_height();
    display_reset(8, true); // Enable 8x MSAA for smoother primitive edges
    
    global.UI_DEMO = {
        currentPage: "Button",
        currentTab: "Preview",
        ScrollArea: undefined,
        BreadcrumbPage: undefined,
        SidebarItems: undefined
    };
    
    // Setup root
    global.UI.setSize(W, H);
    
    // Overlay node
    global.UI.Overlay = new UiNode({ name: "Overlay", position: "absolute", left: 0, top: 0, width: "100%", height: "100%" });
    global.UI.Tooltip = new UiTooltip();
    global.UI.Overlay.add(global.UI.Tooltip);
    
    // ============================================================
    // MAIN LAYOUT
    // ============================================================
    var Main = new UiNode({ name: "Main", width: "100%", height: "100%", flexDirection: "row" });
    global.UI.add(Main);
    
    // === SIDEBAR ===
    var Sidebar = new UiNode({
        name: "Sidebar", width: 260, height: "100%", flexDirection: "column",
        paddingTop: 16, paddingLeft: 8, paddingRight: 8, paddingBottom: 16,
    });
    Sidebar.onDraw = method(Sidebar, function() {
        draw_set_color(global.UI_COL_BG_SIDEBAR);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
        draw_set_color(#1E293B);
        draw_line(self.x2, self.y1, self.x2, self.y2);
    });
    Main.add(Sidebar);
    
    // Logo
    var LogoRow = new UiNode({ flexDirection: "row", alignItems: "center", marginBottom: 32, paddingLeft: 12 });
    Sidebar.add(LogoRow);
    LogoRow.add(new UiText("UniqueUI", { marginRight: 8 }, { color: c_white }));
    var VersionBadge = new UiNode({ padding: 4 });
    VersionBadge.onDraw = method(VersionBadge, function() {
        draw_set_color(#312E81);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 4, 4, false);
    });
    VersionBadge.add(new UiText(global.UI_VERSION, {}, { color: #818CF8 }));
    LogoRow.add(VersionBadge);
    
    global.UI_DEMO.SearchQuery = "";
    
    // Search
    var SearchInput = new UiTextbox({ width: "100%", height: 36, marginBottom: 32 }, {
        placeholder: "Search...",
        value: global.UI_DEMO.SearchQuery,
        onChange: function(val) {
            global.UI_DEMO.SearchQuery = string_lower(val);
            __ui_demo_render_sidebar();
        }
    });
    global.UI_DEMO.SearchInput = SearchInput;
    SearchInput.onMouseDown(method(SearchInput, function() {
        self.Input.focus();
    }));
    Sidebar.add(SearchInput);
    
    // Sidebar List
    var SidebarItems = new UiNode({ flex: 1, width: "100%", flexDirection: "column" });
    SidebarItems.enableScrollbar(global.UI_COL_PRIMARY);
    Sidebar.add(SidebarItems);
    global.UI_DEMO.SidebarItems = SidebarItems;
    
    __ui_demo_render_sidebar();
    
    // === CONTENT AREA ===
    var Content = new UiNode({ name: "Content", flex: 1, height: "100%", flexDirection: "column" });
    Content.onDraw = method(Content, function() {
        draw_set_color(global.UI_COL_BG_MAIN);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
    });
    Main.add(Content);
    
    // Top Bar
    var TopBar = new UiNode({ width: "100%", height: 64, flexDirection: "row", alignItems: "center", paddingLeft: 40, paddingRight: 40 });
    TopBar.onDraw = method(TopBar, function() {
        draw_set_color(c_white);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_line(self.x1, self.y2, self.x2, self.y2);
    });
    Content.add(TopBar);
    
    var Breadcrumbs = new UiNode({ flexDirection: "row", flex: 1 });
    Breadcrumbs.add(new UiText("Components", { marginRight: 8 }, { color: #64748B }));
    Breadcrumbs.add(new UiText(">", { marginRight: 8 }, { color: #CBD5E1 }));
    global.UI_DEMO.BreadcrumbPage = new UiText("Button", {}, { color: #0F172A });
    Breadcrumbs.add(global.UI_DEMO.BreadcrumbPage);
    TopBar.add(Breadcrumbs);
    
    var DocLink = new UiText("Documentation", { marginRight: 24 }, { color: #64748B, pointerEvents: true, handpoint: true });
    DocLink.onClick(function() {
        url_open("https://manuel-di-iorio.github.io/unique-ui");
    });
    TopBar.add(DocLink);
    
    // Scroll Area (Main Content)
    var ScrollArea = new UiNode({ flex: 1, width: "100%", flexDirection: "column", padding: 40 });
    Content.add(ScrollArea);
    global.UI_DEMO.ScrollArea = ScrollArea;
    
    __ui_demo_refresh();
    
    global.UI.add(global.UI.Overlay);
}

function __ui_demo_render_sidebar() {
    var parent = global.UI_DEMO.SidebarItems;
    parent.destroyChildren(true);
    
    __ui_demo_sidebar_label(parent, "FOUNDATIONS");
    __ui_demo_sidebar_item(parent, "Colors");
    __ui_demo_sidebar_item(parent, "Typography");
    
    __ui_demo_sidebar_label(parent, "COMPONENTS", 20);
    var comps = ["Button", "Input", "Select", "Checkbox", "Radio", "Switch", "Badge", "Alert", "Card", "Tabs", "Tooltip", "Slider", "Accordion", "Sprite", "ContextMenu", "Treeview"];
    for (var i = 0; i < array_length(comps); i++) {
        var name = comps[i];
        if (global.UI_DEMO.SearchQuery != "" && string_pos(global.UI_DEMO.SearchQuery, string_lower(name)) == 0) continue;
        __ui_demo_sidebar_item(parent, name);
    }
}

function __ui_demo_sidebar_item(parent, text) {
    var isSelected = (text == global.UI_DEMO.currentPage);
    var btn = new UiButton(text, { width: "100%", height: 36, marginBottom: 2, paddingLeft: 12 }, { 
        halign: fa_left, variant: isSelected ? "primary" : "ghost" 
    });
    btn.onClick(method({ text }, function() {
        global.UI_DEMO.currentPage = text;
        global.UI_DEMO.currentTab = "Preview";
        __ui_demo_render_sidebar();
        __ui_demo_refresh();
    }));
    parent.add(btn);
}

function __ui_demo_sidebar_label(parent, text, mt = 0) {
    parent.add(new UiText(text, { marginTop: mt, marginBottom: 12, marginLeft: 12 }, { color: #475569 }));
}

function __ui_demo_refresh() {
    var area = global.UI_DEMO.ScrollArea;
    area.destroyChildren(true);
    area.scrollTop = 0;
    global.UI_DEMO.BreadcrumbPage.text = global.UI_DEMO.currentPage;
    
    // Title Section
    var Hero = new UiNode({ width: "100%", flexDirection: "column", marginBottom: 32 });
    area.add(Hero);
    Hero.add(new UiText(global.UI_DEMO.currentPage, { marginBottom: 8, height: 40 }, { color: #0F172A, font: fText })); 
    
    var metadata = __ui_demo_get_component_metadata();
    var componentData = metadata[$ global.UI_DEMO.currentPage];
    var desc = componentData != undefined ? componentData.desc : "Explore the capabilities of the component " + global.UI_DEMO.currentPage;
    Hero.add(new UiText(desc, {}, { color: #64748B }));
    
    // Tabs
    var TabRow = new UiNode({ flexDirection: "row", width: "100%", marginBottom: 32 });
    TabRow.onDraw = method(TabRow, function() {
        draw_set_color(global.UI_COL_BORDER);
        draw_line(self.x1, self.y2, self.x2, self.y2);
    });
    area.add(TabRow);
    __ui_demo_tab_item(TabRow, "Preview");
    __ui_demo_tab_item(TabRow, "Documentation");
    __ui_demo_tab_item(TabRow, "Performance");
    
    if (global.UI_DEMO.currentTab == "Preview") {
        area.disableScrollbar();
        __ui_demo_render_anteprima(area);
    } else if (global.UI_DEMO.currentTab == "Documentation") {
        area.enableScrollbar(global.UI_COL_PRIMARY);
        __ui_demo_render_documentazione(area);
    } else {
        area.enableScrollbar(global.UI_COL_PRIMARY);
        __ui_demo_render_performance(area);
    }
    
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
    Row.add(new UiText(name, { width: 220 }, { color: #6366F1 }));
    Row.add(new UiText(type, { width: 90 }, { color: #94A3B8 }));
    Row.add(new UiText(desc, { flex: 1 }, { color: #64748B }));
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
    var codeLines = [];
    switch (page) {
        case "Colori":      codeLines = ui_demo_example_colors(parent); break;
        case "Tipografia":  codeLines = ui_demo_example_typography(parent); break;
        case "Button":      codeLines = ui_demo_example_button(parent); break;
        case "Input":       codeLines = ui_demo_example_input(parent); break;
        case "Checkbox":    codeLines = ui_demo_example_checkbox(parent); break;
        case "Radio":       codeLines = ui_demo_example_radio(parent); break;
        case "Switch":      codeLines = ui_demo_example_switch(parent); break;
        case "Select":      codeLines = ui_demo_example_dropdown(parent); break;
        case "Badge":       codeLines = ui_demo_example_badge(parent); break;
        case "Alert":       codeLines = ui_demo_example_alert(parent); break;
        case "Card":        codeLines = ui_demo_example_card(parent); break;
        case "Tabs":        codeLines = ui_demo_example_tabs(parent); break;
        case "Accordion":   codeLines = ui_demo_example_accordion(parent); break;
        case "Slider":      codeLines = ui_demo_example_slider(parent); break;
        case "Sprite":      codeLines = ui_demo_example_sprite(parent); break;
        case "ContextMenu": codeLines = ui_demo_example_contextmenu(parent); break;
        case "Tooltip":     codeLines = ui_demo_example_tooltip(parent); break;
        case "Treeview":    codeLines = ui_demo_example_treeview(parent); break;
        
        default:
            parent.add(new UiText("Preview for " + page + " coming soon.", {}, { color: #64748B }));
            codeLines = ["// Example not available"];
    }
    return codeLines;
}

function __ui_demo_get_component_metadata() {
    return {
        "Button": {
            desc: "Allows users to perform an action with a single click.",
            props: [
                { name: "variant", type: "string", desc: "Visual appearance: 'primary', 'secondary', 'outline', 'ghost', 'danger'" },
                { name: "halign", type: "constant", desc: "Horizontal alignment: fa_left, fa_center, fa_right" },
                { name: "outline", type: "boolean", desc: "Shows a thin border" },
                { name: "enableRipple", type: "boolean", desc: "Enables ripple effect on click" },
                { name: "label", type: "string", desc: "Text to show next to the sprite" },
                { name: "autoResize", type: "boolean", desc: "Automatically resizes based on content" }
            ]
        },
        "Input": {
            desc: "Text field for user data entry.",
            props: [
                { name: "label", type: "string", desc: "Descriptive label above the field" },
                { name: "value", type: "string", desc: "Current value of the field" },
                { name: "placeholder", type: "string", desc: "Placeholder text when the field is empty" },
                { name: "maxLength", type: "number", desc: "Maximum number of characters allowed" },
                { name: "format", type: "string", desc: "Data type: 'string', 'float', 'integer'" },
                { name: "onChange", type: "function", desc: "Callback called when the value changes" },
                { name: "iconLeft", type: "sprite", desc: "Sprite to show on the left" },
                { name: "iconRight", type: "sprite", desc: "Sprite to show on the right" }
            ]
        },
        "Checkbox": {
            desc: "Allows selecting one or more options from a set.",
            props: [
                { name: "value", type: "boolean", desc: "Selection state (true/false)" },
                { name: "label", type: "string", desc: "Descriptive text next to the checkbox" },
                { name: "onChange", type: "function", desc: "Callback called on state change" },
                { name: "variant", type: "string", desc: "Input type: 'checkbox' or 'radio'" }
            ]
        },
        "Radio": {
            desc: "Allows selecting a single option from a group.",
            props: [
                { name: "value", type: "boolean", desc: "Selection state" },
                { name: "label", type: "string", desc: "Descriptive text" },
                { name: "group", type: "string", desc: "Group name for mutual selection" },
                { name: "onChange", type: "function", desc: "Callback called on state change" }
            ]
        },
        "Switch": {
            desc: "Binary toggle to enable or disable a setting.",
            props: [
                { name: "value", type: "boolean", desc: "Switch state" },
                { name: "label", type: "string", desc: "Descriptive text" },
                { name: "onChange", type: "function", desc: "Callback called on state change" }
            ]
        },
        "Select": {
            desc: "Dropdown menu to select an option from a list.",
            props: [
                { name: "value", type: "any", desc: "Selected value" },
                { name: "items", type: "array", desc: "Array of structs {label, value}" },
                { name: "label", type: "string", desc: "Selector label" },
                { name: "search", type: "string", desc: "Placeholder for the internal search bar" },
                { name: "onChange", type: "function", desc: "Callback called on selection" }
            ]
        },
        "Badge": {
            desc: "Small status indicators or counters.",
            props: [
                { name: "variant", type: "string", desc: "Badge style (uses UiButton with variants)" }
            ]
        },
        "Alert": {
            desc: "Contextual feedback messages for the user.",
            props: [
                { name: "type", type: "string", desc: "Alert type: 'info', 'success', 'warning', 'error'" },
                { name: "title", type: "string", desc: "Message title" }
            ]
        },
        "Card": {
            desc: "Flexible container to group related content.",
            props: [
                { name: "padding", type: "number", desc: "Internal spacing" },
                { name: "border", type: "boolean", desc: "Shows the outer border" }
            ]
        },
        "Tabs": {
            desc: "Organizes content into different navigable views.",
            props: [
                { name: "items", type: "array", desc: "List of tabs" },
                { name: "onChange", type: "function", desc: "Callback on tab change" }
            ]
        },
        "Tooltip": {
            desc: "Additional information that appears on hover.",
            props: [
                { name: "tooltip", type: "string", desc: "Tooltip text (UiNode property)" },
                { name: "tooltipDelay", type: "number", desc: "Delay in ms before appearing" }
            ]
        },
        "Slider": {
            desc: "Allows selecting a value from a numeric range.",
            props: [
                { name: "value", type: "number", desc: "Current value" },
                { name: "min", type: "number", desc: "Minimum value" },
                { name: "max", type: "number", desc: "Maximum value" },
                { name: "step", type: "number", desc: "Minimum increment" },
                { name: "onChange", type: "function", desc: "Callback on value change" }
            ]
        },
        "Accordion": {
            desc: "Content sections that can be expanded or collapsed.",
            props: [
                { name: "text", type: "string", desc: "Header text" },
                { name: "collapsed", type: "boolean", desc: "Initial state (collapsed/expanded)" },
                { name: "spriteCollapsed", type: "sprite", desc: "Icon when collapsed" },
                { name: "spriteExpanded", type: "sprite", desc: "Icon when expanded" }
            ]
        },
        "Sprite": {
            desc: "Displays a GameMaker sprite resource.",
            props: [
                { name: "sprite", type: "sprite", desc: "Index of the sprite to display" },
                { name: "width", type: "number/string", desc: "Desired width" },
                { name: "height", type: "number/string", desc: "Desired height" }
            ]
        },
        "ContextMenu": {
            desc: "Popup menu activated by right-click.",
            props: [
                { name: "x", type: "number", desc: "Initial X position" },
                { name: "y", type: "number", desc: "Initial Y position" },
                { name: "addItem", type: "function", desc: "Method to add menu items" }
            ]
        },
        "Treeview": {
            desc: "Displays a hierarchical structure of expandable items.",
            props: [
                { name: "onItemSelected", type: "function", desc: "Callback on item selection" },
                { name: "onAssetDrop", type: "function", desc: "Handles drag & drop between items" },
                { name: "filter", type: "function", desc: "Filters items by name" }
            ]
        }
    };
}

function __ui_demo_get_performance_metadata() {
    var _default = {
        impact: "Medium",
        dominantCost: "Draw calls and dynamic UI allocations",
        bottlenecks: [
            "Complete node reconstruction when state changes frequently",
            "Intensive use of custom onDraw with primitives for each element",
            "Global layout updates even for micro-variations"
        ],
        optimizations: [
            "Reduce repeated destroy/create with node reuse and property updates",
            "Minimize global requestUpdate, preferring local updates when possible",
            "Group redraws and reduce text/primitives in loops"
        ],
        measurements: [
            "Measure average FPS and 1% low during rapid interactions",
            "Count total/rendered nodes (countAll + visible) per scene",
            "Compare frame time before/after optimizations with same dataset"
        ]
    };
    
    return {
        "__default": _default,
        "Colors": {
            impact: "Low-Medium",
            dominantCost: "Drawing many static cards with roundrect",
            bottlenecks: [
                "Many draw primitives in sequence",
                "Layout wrapping with many cards can increase recalculations"
            ],
            optimizations: [
                "Cache static blocks on surfaces when they don't change",
                "Reduce unnecessary redraws in static screens"
            ],
            measurements: [
                "Compare frame time with/without surface cache",
                "Verify number of redraws during hover/scroll"
            ]
        },
        "Typography": {
            impact: "Low",
            dominantCost: "Text rendering and font metrics",
            bottlenecks: [
                "Many UiText can cost on non-cached fonts",
                "Inconsistent heights can increase layout passes"
            ],
            optimizations: [
                "Standardize styles and fonts to improve renderer cache",
                "Avoid layout updates when only static content changes"
            ],
            measurements: [
                "Measure draw_text per frame in long views",
                "Verify tab opening time with many texts"
            ]
        },
        "Input": {
            impact: "Medium-High",
            dominantCost: "Step for caret management, selection, undo/redo, key repeat",
            bottlenecks: [
                "Character parsing every frame while focused",
                "String width calculation in cursor/selection operations",
                "Frequent RequestRedraw during editing"
            ],
            optimizations: [
                "Reduce string_width calls with incremental caching",
                "Separate input logic from redraw when value doesn't change",
                "Limit scissor/selection updates to necessary frames only"
            ],
            measurements: [
                "Profile frame time holding a key for 5s",
                "Count redraws per character inserted"
            ]
        },
        "Select": {
            impact: "Medium",
            dominantCost: "List opening, search filtering, and item recreation",
            bottlenecks: [
                "destroyChildren/createItems on every filter",
                "Many visible items increase draw + layout"
            ],
            optimizations: [
                "Virtualize list for large datasets",
                "Debounce search to reduce reconstructions"
            ],
            measurements: [
                "Measure dropdown opening time with 50/200/1000 items",
                "Track frame drops while typing in the filter"
            ]
        },
        "Treeview": {
            impact: "High",
            dominantCost: "Recursive traversing + drag/drop + hierarchical filtering",
            bottlenecks: [
                "Recursive filter on deep trees",
                "Node expansion with many children",
                "Visual update during drag"
            ],
            optimizations: [
                "Index names for fast filtering",
                "Lazy render of non-visible branches",
                "Batch update during mass operations"
            ],
            measurements: [
                "Filter time on 1k/5k node trees",
                "Frame time during continuous drag"
            ]
        },
        "Slider": {
            impact: "Low-Medium",
            dominantCost: "Continuous redraw during drag",
            bottlenecks: [
                "Animated onDraw every frame",
                "High-frequency value update"
            ],
            optimizations: [
                "Throttle onChange when used for expensive logic",
                "Reduce animation when value difference is minimal"
            ],
            measurements: [
                "Frame time during rapid 3s drag",
                "Number of onChange callbacks per second"
            ]
        }
    };
}
