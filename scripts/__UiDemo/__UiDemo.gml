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
    
    if (global.UI_DEMO.currentTab == "Anteprima") {
        area.disableScrollbar();
        __ui_demo_render_anteprima(area);
    } else {
        area.enableScrollbar(global.UI_COL_PRIMARY);
        __ui_demo_render_documentazione(area);
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
    
    var codeLines = [];
    switch (global.UI_DEMO.currentPage) {
        case "Colori":      codeLines = ui_demo_example_colori(PreviewCard); break;
        case "Tipografia":  codeLines = ui_demo_example_tipografia(PreviewCard); break;
        case "Button":      codeLines = ui_demo_example_button(PreviewCard); break;
        case "Input":       codeLines = ui_demo_example_input(PreviewCard); break;
        case "Checkbox":    codeLines = ui_demo_example_checkbox(PreviewCard); break;
        case "Radio":       codeLines = ui_demo_example_radio(PreviewCard); break;
        case "Switch":      codeLines = ui_demo_example_switch(PreviewCard); break;
        case "Select":      codeLines = ui_demo_example_dropdown(PreviewCard); break;
        case "Badge":       codeLines = ui_demo_example_badge(PreviewCard); break;
        case "Alert":       codeLines = ui_demo_example_alert(PreviewCard); break;
        case "Card":        codeLines = ui_demo_example_card(PreviewCard); break;
        case "Tabs":        codeLines = ui_demo_example_tabs(PreviewCard); break;
        case "Accordion":   codeLines = ui_demo_example_accordion(PreviewCard); break;
        case "Slider":      codeLines = ui_demo_example_slider(PreviewCard); break;
        case "Sprite":      codeLines = ui_demo_example_sprite(PreviewCard); break;
        case "ContextMenu": codeLines = ui_demo_example_contextmenu(PreviewCard); break;
        case "Tooltip":     codeLines = ui_demo_example_tooltip(PreviewCard); break;
        case "Treeview":    codeLines = ui_demo_example_treeview(PreviewCard); break;
        
        default:
            PreviewCard.add(new UiText("Anteprima per " + global.UI_DEMO.currentPage + " in arrivo.", {}, { color: #64748B }));
            codeLines = ["// Esempio non disponibile"];
    }
    
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
