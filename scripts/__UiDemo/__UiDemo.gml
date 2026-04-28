/// @desc UI Demo - AAA Showcase of all UniqueUI components
function ui_demo_create() {
    var W = display_get_gui_width();
    var H = display_get_gui_height();
    display_reset(8, true); // Enable 8x MSAA for smoother primitive edges
    
    global.UI_DEMO = {
        currentPage: "Button",
        currentTab: "Anteprima",
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
        placeholder: "Cerca...",
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
    Breadcrumbs.add(new UiText("Componenti", { marginRight: 8 }, { color: #64748B }));
    Breadcrumbs.add(new UiText(">", { marginRight: 8 }, { color: #CBD5E1 }));
    global.UI_DEMO.BreadcrumbPage = new UiText("Button", {}, { color: #0F172A });
    Breadcrumbs.add(global.UI_DEMO.BreadcrumbPage);
    TopBar.add(Breadcrumbs);
    
    var DocLink = new UiText("Documentazione", { marginRight: 24 }, { color: #64748B, pointerEvents: true, handpoint: true });
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
    
    __ui_demo_sidebar_label(parent, "FONDAMENTI");
    __ui_demo_sidebar_item(parent, "Colori");
    __ui_demo_sidebar_item(parent, "Tipografia");
    
    __ui_demo_sidebar_label(parent, "COMPONENTI", 20);
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
        global.UI_DEMO.currentTab = "Anteprima";
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
    var desc = componentData != undefined ? componentData.desc : "Esplora le potenzialità del componente " + global.UI_DEMO.currentPage;
    Hero.add(new UiText(desc, {}, { color: #64748B }));
    
    // Tabs
    var TabRow = new UiNode({ flexDirection: "row", width: "100%", marginBottom: 32 });
    TabRow.onDraw = method(TabRow, function() {
        draw_set_color(global.UI_COL_BORDER);
        draw_line(self.x1, self.y2, self.x2, self.y2);
    });
    area.add(TabRow);
    __ui_demo_tab_item(TabRow, "Anteprima");
    __ui_demo_tab_item(TabRow, "Documentazione");
    __ui_demo_tab_item(TabRow, "Performance");
    
    if (global.UI_DEMO.currentTab == "Anteprima") {
        area.disableScrollbar();
        __ui_demo_render_anteprima(area);
    } else if (global.UI_DEMO.currentTab == "Documentazione") {
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
    
    Doc.add(new UiText("Uso", { marginBottom: 16, height: 28 }, { color: #0F172A }));
    Doc.add(new UiText("Il componente " + global.UI_DEMO.currentPage + " è progettato per essere altamente personalizzabile.", { marginBottom: 32 }, { color: #64748B }));
    
    if (componentData != undefined && variable_struct_exists(componentData, "props")) {
        Doc.add(new UiText("Proprietà", { marginBottom: 16, height: 28 }, { color: #0F172A }));
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
        Doc.add(new UiText("Nessuna proprietà specifica documentata per questo componente.", { marginBottom: 32 }, { color: #64748B }));
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
    
    Perf.add(new UiText("Performance Live", { marginBottom: 8, height: 28 }, { color: #0F172A }));
    Perf.add(new UiText("Metriche runtime in tempo reale del componente corrente. Interagisci con la sandbox per stressare input, rendering e layout.", { marginBottom: 20 }, { color: #64748B }));
    
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
        return "Nodes -> total: " + string(p.totalNodes) + " | visibili: " + string(p.visibleNodes) + " | interattivi: " + string(p.interactiveNodes) + " | sandbox: " + string(p.sandboxNodes);
    }}));
    
    Perf.add(new UiText("Sandbox componente", { marginBottom: 10, height: 28 }, { color: #0F172A }));
    
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
        case "Colori":      codeLines = ui_demo_example_colori(parent); break;
        case "Tipografia":  codeLines = ui_demo_example_tipografia(parent); break;
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
            parent.add(new UiText("Anteprima per " + page + " in arrivo.", {}, { color: #64748B }));
            codeLines = ["// Esempio non disponibile"];
    }
    return codeLines;
}

function __ui_demo_get_component_metadata() {
    return {
        "Button": {
            desc: "Permette agli utenti di compiere un'azione con un singolo clic.",
            props: [
                { name: "variant", type: "string", desc: "Aspetto visivo: 'primary', 'secondary', 'outline', 'ghost', 'danger'" },
                { name: "halign", type: "constant", desc: "Allineamento orizzontale: fa_left, fa_center, fa_right" },
                { name: "outline", type: "boolean", desc: "Mostra un bordo sottile" },
                { name: "enableRipple", type: "boolean", desc: "Abilita l'effetto ripple al clic" },
                { name: "label", type: "string", desc: "Testo da mostrare accanto allo sprite" },
                { name: "autoResize", type: "boolean", desc: "Ridimensiona automaticamente in base al contenuto" }
            ]
        },
        "Input": {
            desc: "Campo di testo per l'inserimento di dati da parte dell'utente.",
            props: [
                { name: "label", type: "string", desc: "Etichetta descrittiva sopra il campo" },
                { name: "value", type: "string", desc: "Valore corrente del campo" },
                { name: "placeholder", type: "string", desc: "Testo segnaposto quando il campo è vuoto" },
                { name: "maxLength", type: "number", desc: "Numero massimo di caratteri consentiti" },
                { name: "format", type: "string", desc: "Tipo di dato: 'string', 'float', 'integer'" },
                { name: "onChange", type: "function", desc: "Callback chiamata quando il valore cambia" },
                { name: "iconLeft", type: "sprite", desc: "Sprite da mostrare a sinistra" },
                { name: "iconRight", type: "sprite", desc: "Sprite da mostrare a destra" }
            ]
        },
        "Checkbox": {
            desc: "Permette di selezionare una o più opzioni da un set.",
            props: [
                { name: "value", type: "boolean", desc: "Stato di selezione (true/false)" },
                { name: "label", type: "string", desc: "Testo descrittivo accanto al checkbox" },
                { name: "onChange", type: "function", desc: "Callback chiamata al cambio di stato" },
                { name: "variant", type: "string", desc: "Tipo di input: 'checkbox' o 'radio'" }
            ]
        },
        "Radio": {
            desc: "Permette di selezionare una singola opzione da un gruppo.",
            props: [
                { name: "value", type: "boolean", desc: "Stato di selezione" },
                { name: "label", type: "string", desc: "Testo descrittivo" },
                { name: "group", type: "string", desc: "Nome del gruppo per la selezione mutua" },
                { name: "onChange", type: "function", desc: "Callback chiamata al cambio di stato" }
            ]
        },
        "Switch": {
            desc: "Interruttore binario per attivare o disattivare un'impostazione.",
            props: [
                { name: "value", type: "boolean", desc: "Stato dell'interruttore" },
                { name: "label", type: "string", desc: "Testo descrittivo" },
                { name: "onChange", type: "function", desc: "Callback chiamata al cambio di stato" }
            ]
        },
        "Select": {
            desc: "Menu a discesa per selezionare un'opzione da una lista.",
            props: [
                { name: "value", type: "any", desc: "Valore selezionato" },
                { name: "items", type: "array", desc: "Array di struct {label, value}" },
                { name: "label", type: "string", desc: "Etichetta del selettore" },
                { name: "search", type: "string", desc: "Placeholder per la barra di ricerca interna" },
                { name: "onChange", type: "function", desc: "Callback chiamata alla selezione" }
            ]
        },
        "Badge": {
            desc: "Piccoli indicatori di stato o contatori.",
            props: [
                { name: "variant", type: "string", desc: "Stile del badge (usa UiButton con varianti)" }
            ]
        },
        "Alert": {
            desc: "Messaggi di feedback contestuali per l'utente.",
            props: [
                { name: "type", type: "string", desc: "Tipo di alert: 'info', 'success', 'warning', 'error'" },
                { name: "title", type: "string", desc: "Titolo del messaggio" }
            ]
        },
        "Card": {
            desc: "Contenitore flessibile per raggruppare contenuti correlati.",
            props: [
                { name: "padding", type: "number", desc: "Spaziatura interna" },
                { name: "border", type: "boolean", desc: "Mostra il bordo esterno" }
            ]
        },
        "Tabs": {
            desc: "Organizza i contenuti in diverse viste navigabili.",
            props: [
                { name: "items", type: "array", desc: "Lista dei tab" },
                { name: "onChange", type: "function", desc: "Callback al cambio di tab" }
            ]
        },
        "Tooltip": {
            desc: "Informazioni aggiuntive che appaiono al passaggio del mouse.",
            props: [
                { name: "tooltip", type: "string", desc: "Testo del tooltip (prop di UiNode)" },
                { name: "tooltipDelay", type: "number", desc: "Ritardo in ms prima della comparsa" }
            ]
        },
        "Slider": {
            desc: "Permette di selezionare un valore da un intervallo numerico.",
            props: [
                { name: "value", type: "number", desc: "Valore corrente" },
                { name: "min", type: "number", desc: "Valore minimo" },
                { name: "max", type: "number", desc: "Valore massimo" },
                { name: "step", type: "number", desc: "Incremento minimo" },
                { name: "onChange", type: "function", desc: "Callback al cambio di valore" }
            ]
        },
        "Accordion": {
            desc: "Sezioni di contenuto che possono essere espanse o compresse.",
            props: [
                { name: "text", type: "string", desc: "Testo dell'intestazione" },
                { name: "collapsed", type: "boolean", desc: "Stato iniziale (compresso/espanso)" },
                { name: "spriteCollapsed", type: "sprite", desc: "Icona quando è compresso" },
                { name: "spriteExpanded", type: "sprite", desc: "Icona quando è espanso" }
            ]
        },
        "Sprite": {
            desc: "Visualizza una risorsa sprite di GameMaker.",
            props: [
                { name: "sprite", type: "sprite", desc: "Indice dello sprite da visualizzare" },
                { name: "width", type: "number/string", desc: "Larghezza desiderata" },
                { name: "height", type: "number/string", desc: "Altezza desiderata" }
            ]
        },
        "ContextMenu": {
            desc: "Menu a comparsa attivato dal tasto destro del mouse.",
            props: [
                { name: "x", type: "number", desc: "Posizione X iniziale" },
                { name: "y", type: "number", desc: "Posizione Y iniziale" },
                { name: "addItem", type: "function", desc: "Metodo per aggiungere voci al menu" }
            ]
        },
        "Treeview": {
            desc: "Visualizza una struttura gerarchica di elementi espandibili.",
            props: [
                { name: "onItemSelected", type: "function", desc: "Callback alla selezione di un elemento" },
                { name: "onAssetDrop", type: "function", desc: "Gestisce il drag & drop tra elementi" },
                { name: "filter", type: "function", desc: "Filtra gli elementi per nome" }
            ]
        }
    };
}

function __ui_demo_get_performance_metadata() {
    var _default = {
        impact: "Medio",
        dominantCost: "Draw calls e allocazioni UI dinamiche",
        bottlenecks: [
            "Ricostruzione completa dei nodi quando cambia stato frequentemente",
            "Uso intensivo di onDraw custom con primitive per ogni elemento",
            "Aggiornamenti layout globali anche per micro-variazioni"
        ],
        optimizations: [
            "Ridurre destroy/create ripetuti con riuso nodi e aggiornamento proprietà",
            "Minimizzare requestUpdate globali, preferendo update locali quando possibile",
            "Raggruppare ridisegni e ridurre testo/primitive nei loop"
        ],
        measurements: [
            "Misura FPS medio e 1% low durante interazioni rapide",
            "Conta nodi totali/renderizzati (countAll + visibili) per scena",
            "Confronta frame time prima/dopo ottimizzazioni con stesso dataset"
        ]
    };
    
    return {
        "__default": _default,
        "Colori": {
            impact: "Basso-Medio",
            dominantCost: "Disegno di molte card statiche con roundrect",
            bottlenecks: [
                "Molte draw primitive in sequenza",
                "Layout wrapping con molte card può aumentare i recalcoli"
            ],
            optimizations: [
                "Cache dei blocchi statici su surface quando non cambiano",
                "Ridurre redraw non necessari in schermate statiche"
            ],
            measurements: [
                "Confronta frame time con/without cache surface",
                "Verifica numero redraw durante hover/scroll"
            ]
        },
        "Tipografia": {
            impact: "Basso",
            dominantCost: "Rendering testo e metriche font",
            bottlenecks: [
                "Molti UiText possono costare su font non cached",
                "Altezze non coerenti possono aumentare pass layout"
            ],
            optimizations: [
                "Uniformare stili e font per migliorare cache del renderer",
                "Evitare update layout quando cambia solo contenuto statico"
            ],
            measurements: [
                "Misura draw_text per frame nelle viste lunghe",
                "Verifica tempo di apertura tab con molti testi"
            ]
        },
        "Input": {
            impact: "Medio-Alto",
            dominantCost: "Step per gestione caret, selezione, undo/redo, key repeat",
            bottlenecks: [
                "Parsing caratteri ad ogni frame mentre focused",
                "Calcolo larghezze stringa in operazioni cursor/selection",
                "RequestRedraw frequenti durante editing"
            ],
            optimizations: [
                "Ridurre chiamate a string_width con caching incrementale",
                "Separare logica di input da redraw quando il valore non cambia",
                "Limitare update scissor/selection ai soli frame necessari"
            ],
            measurements: [
                "Profila frame time tenendo premuto un tasto 5s",
                "Conta redraw per carattere inserito"
            ]
        },
        "Select": {
            impact: "Medio",
            dominantCost: "Apertura lista, filtro ricerca e ricreazione item",
            bottlenecks: [
                "destroyChildren/createItems su ogni filtro",
                "Molti item visibili aumentano draw + layout"
            ],
            optimizations: [
                "Virtualizzare lista per dataset grandi",
                "Debounce della ricerca per ridurre ricostruzioni"
            ],
            measurements: [
                "Misura tempo apertura dropdown con 50/200/1000 items",
                "Traccia frame drops durante typing nel filtro"
            ]
        },
        "Treeview": {
            impact: "Alto",
            dominantCost: "Traversing ricorsivo + drag/drop + filtro gerarchico",
            bottlenecks: [
                "Filter ricorsivo su alberi profondi",
                "Espansione nodi con molti figli",
                "Aggiornamento visuale durante drag"
            ],
            optimizations: [
                "Indicizzare nomi per filtro veloce",
                "Lazy render dei rami non visibili",
                "Batch update durante operazioni di massa"
            ],
            measurements: [
                "Tempo filtro su alberi 1k/5k nodi",
                "Frame time durante drag continuo"
            ]
        },
        "Slider": {
            impact: "Basso-Medio",
            dominantCost: "Redraw continuo durante drag",
            bottlenecks: [
                "onDraw animato ad ogni frame",
                "Aggiornamento valore con alta frequenza"
            ],
            optimizations: [
                "Throttle onChange quando usato per logiche costose",
                "Ridurre animazione quando differenza valore minima"
            ],
            measurements: [
                "Frame time durante trascinamento rapido 3s",
                "Numero callback onChange per secondo"
            ]
        }
    };
}
