/// @desc UI Demo - AAA Showcase of all UniqueUI components
function ui_demo_create() {
    var W = display_get_gui_width();
    var H = display_get_gui_height();
    
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
        paddingTop: 32, paddingLeft: 8, paddingRight: 8, paddingBottom: 32,
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
    VersionBadge.add(new UiText("v1.0.0", {}, { color: #818CF8 }));
    LogoRow.add(VersionBadge);
    
    // Search
    var SearchInput = new UiTextbox({ width: "100%", height: 36, marginBottom: 32 }, { placeholder: "Cerca..." });
    SearchInput.onChange = function(val) {
        global.UI_DEMO.SearchQuery = string_lower(val);
        __ui_demo_render_sidebar();
    };
    Sidebar.add(SearchInput);
    
    // Sidebar List
    var SidebarItems = new UiNode({ flex: 1, width: "100%", flexDirection: "column" });
    SidebarItems.enableScrollbar(global.UI_COL_PRIMARY);
    Sidebar.add(SidebarItems);
    global.UI_DEMO.SidebarItems = SidebarItems;
    global.UI_DEMO.SearchQuery = "";
    
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
    ScrollArea.enableScrollbar(global.UI_COL_PRIMARY);
    ScrollArea.enableHorizontalScrollbar(global.UI_COL_PRIMARY);
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
    var comps = ["Button", "Input", "Select", "Checkbox", "Radio", "Switch", "Badge", "Alert", "Card", "Tabs", "Tooltip", "Slider", "Accordion", "Sprite", "ContextMenu"];
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
    
    var desc = "Esplora le potenzialità del componente " + global.UI_DEMO.currentPage;
    if (global.UI_DEMO.currentPage == "Button") desc = "Permette agli utenti di compiere un'azione con un singolo clic.";
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
        __ui_demo_render_anteprima(area);
    } else {
        __ui_demo_render_documentazione(area);
    }
    
    global.UI.requestUpdate();
}

function __ui_demo_render_documentazione(area) {
    var Doc = new UiNode({ width: "100%", flexDirection: "column" });
    area.add(Doc);
    
    Doc.add(new UiText("Uso", { marginBottom: 16, height: 28 }, { color: #0F172A }));
    Doc.add(new UiText("Il componente " + global.UI_DEMO.currentPage + " è progettato per essere altamente personalizzabile.", { marginBottom: 32 }, { color: #64748B }));
    
    Doc.add(new UiText("Proprietà", { marginBottom: 16, height: 28 }, { color: #0F172A }));
    var Table = new UiNode({ width: "100%", flexDirection: "column", padding: 16 });
    Table.onDraw = method(Table, function() {
        draw_set_color(#F8FAFC);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
    });
    Doc.add(Table);
    
    __ui_demo_doc_row(Table, "variant", "string", "Aspetto visivo");
    __ui_demo_doc_row(Table, "onClick", "function", "Callback al clic");
}

function __ui_demo_doc_row(parent, name, type, desc) {
    var Row = new UiNode({ flexDirection: "row", marginBottom: 12, width: "100%" });
    Row.add(new UiText(name, { width: 120 }, { color: #6366F1 }));
    Row.add(new UiText(type, { width: 120 }, { color: #94A3B8 }));
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
    var MainRow = new UiNode({ flexDirection: "row", width: "100%", alignItems: "flex-start" });
    area.add(MainRow);
    
    var PreviewCard = new UiNode({ flex: 1, marginRight: 24, padding: 32, flexDirection: "column" });
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
        case "Colori":
            __ui_demo_preview_section(PreviewCard, "Tavolozza");
            var grid = new UiNode({ flexDirection: "row", flexWrap: "wrap", width: "100%" });
            PreviewCard.add(grid);
            var colors = [
                {name: "Primary", col: global.UI_COL_PRIMARY, hex: "#6366F1"},
                {name: "Success", col: #22C55E, hex: "#22C55E"},
                {name: "Warning", col: #F59E0B, hex: "#F59E0B"},
                {name: "Danger", col: #EF4444, hex: "#EF4444"},
                {name: "Slate 900", col: #0F172A, hex: "#0F172A"},
                {name: "Slate 500", col: #64748B, hex: "#64748B"},
                {name: "Slate 300", col: #CBD5E1, hex: "#CBD5E1"},
                {name: "Slate 100", col: #F1F5F9, hex: "#F1F5F9"}
            ];
            for (var i = 0; i < array_length(colors); i++) {
                var c = colors[i];
                var box = new UiNode({ width: 120, height: 140, marginRight: 16, marginBottom: 16, flexDirection: "column" });
                box.__demoCol = c.col;
                box.onDraw = method(box, function() {
                    draw_set_color(self.__demoCol); 
                    draw_roundrect_ext(self.x1, self.y1, self.x2, self.y1 + 80, 8, 8, false);
                });
                box.add(new UiText(c.name, { marginTop: 85, height: 20 }, { color: #0F172A, font: fTextSmall }));
                box.add(new UiText(c.hex, { height: 20 }, { color: #64748B, font: fTextSmall }));
                grid.add(box);
            }
            
            __ui_demo_preview_section(PreviewCard, "Tokens Semantici", 40);
            var semGrid = new UiNode({ flexDirection: "column", width: "100%" });
            PreviewCard.add(semGrid);
            __ui_demo_doc_row(semGrid, "global.UI_COL_PRIMARY", "color", "Colore principale del brand");
            __ui_demo_doc_row(semGrid, "global.UI_COL_BG_MAIN", "color", "Sfondo dell'area di lavoro");
            __ui_demo_doc_row(semGrid, "global.UI_COL_TEXT_MAIN", "color", "Colore del testo principale");
            
            codeLines = ["global.UI_COL_PRIMARY = #6366F1;", "global.UI_COL_SUCCESS = #22C55E;", "global.UI_COL_DANGER = #EF4444;"];
            break;

        case "Tipografia":
            __ui_demo_preview_section(PreviewCard, "Headings");
            PreviewCard.add(new UiText("Heading 1", { marginBottom: 4, height: 42 }, { color: #0F172A, font: fText }));
            PreviewCard.add(new UiText("Heading 2", { marginBottom: 4, height: 32 }, { color: #1E293B, font: fText }));
            PreviewCard.add(new UiText("Heading 3", { marginBottom: 24, height: 24 }, { color: #334155, font: fTextSmall }));
            
            __ui_demo_preview_section(PreviewCard, "Body Text");
            PreviewCard.add(new UiText("Design is not just what it looks like and feels like. Design is how it works. - Steve Jobs", { width: "100%", height: 60, marginBottom: 12 }, { color: #64748B }));
            PreviewCard.add(new UiText("The quick brown fox jumps over the lazy dog.", { width: "100%", height: 20 }, { color: #94A3B8, font: fTextSmall }));
            
            __ui_demo_preview_section(PreviewCard, "Font Disponibili", 40);
            var fontGrid = new UiNode({ flexDirection: "column", width: "100%" });
            PreviewCard.add(fontGrid);
            __ui_demo_doc_row(fontGrid, "fText", "font", "Font standard (12pt)");
            __ui_demo_doc_row(fontGrid, "fTextSmall", "font", "Font piccolo (10pt)");
            __ui_demo_doc_row(fontGrid, "fTextItalic", "font", "Font corsivo");
            
            codeLines = ["new UiText(\"Heading\", { height: 42 });", "new UiText(\"Body\", { color: #64748B });"];
            break;

        case "Button":
            __ui_demo_preview_section(PreviewCard, "Varianti");
            var row1 = new UiNode({ flexDirection: "row", marginBottom: 32, flexWrap: "wrap" });
            PreviewCard.add(row1);
            row1.add(new UiButton("Primary", { marginRight: 12, marginBottom: 8 }, { variant: "primary" }));
            row1.add(new UiButton("Secondary", { marginRight: 12, marginBottom: 8 }, { variant: "secondary" }));
            row1.add(new UiButton("Outline", { marginRight: 12, marginBottom: 8 }, { variant: "outline" }));
            row1.add(new UiButton("Danger", { marginBottom: 8 }, { variant: "danger" }));
            
            __ui_demo_preview_section(PreviewCard, "Dimensioni");
            var row2 = new UiNode({ flexDirection: "row", alignItems: "center" });
            PreviewCard.add(row2);
            row2.add(new UiButton("Small", { height: 28, marginRight: 12 }, { variant: "outline" }));
            row2.add(new UiButton("Medium", { height: 36, marginRight: 12 }, { variant: "primary" }));
            row2.add(new UiButton("Large", { height: 44 }, { variant: "outline" }));
            
            codeLines = ["new UiButton(\"Primary\", { variant: \"primary\" });", "new UiButton(\"Small\", { height: 28 });"];
            break;
            
        case "Input":
            __ui_demo_preview_section(PreviewCard, "Standard");
            PreviewCard.add(new UiTextbox({ width: "100%", height: 36, marginBottom: 24 }, { placeholder: "Scrivi qualcosa..." }));
            PreviewCard.add(new UiTextbox({ width: "100%", height: 36 }, { label: "Email", placeholder: "mario@rossi.it" }));
            codeLines = ["new UiTextbox({ height: 36 }, { placeholder: \"...\" });"];
            break;

            
        case "Checkbox":
            PreviewCard.add(new UiCheckbox({ marginBottom: 12 }, { label: "Accetto i termini" }));
            PreviewCard.add(new UiCheckbox({}, { label: "Newsletter", value: true }));
            codeLines = ["new UiCheckbox({}, { label: \"Accetto i termini\" });"];
            break;

        case "Radio":
            PreviewCard.add(new UiText("Scegli un'opzione:", { marginBottom: 12, height: 20 }, { color: #0F172A }));
            PreviewCard.add(new UiCheckbox({ marginBottom: 12 }, { label: "Opzione A", variant: "radio", group: "demo_group" }));
            PreviewCard.add(new UiCheckbox({}, { label: "Opzione B", variant: "radio", value: true, group: "demo_group" }));
            codeLines = ["new UiCheckbox({}, { label: \"Opzione A\", variant: \"radio\", group: \"myGroup\" });"];
            break;
            
        case "Switch":
            PreviewCard.add(new UiSwitch({ marginBottom: 12 }, { label: "Notifiche Push" }));
            PreviewCard.add(new UiSwitch({}, { label: "Modalità Scura", value: true }));
            codeLines = ["new UiSwitch({}, { label: \"Notifiche Push\" });"];
            break;

        case "Select":
            PreviewCard.add(new UiDropdown({ width: "100%", height: 36 }, { 
                label: "Frutto", 
                items: [{label: "Mela", value: "mela"}, {label: "Pera", value: "pera"}] 
            }));
            codeLines = ["new UiDropdown({ height: 36 }, { label: \"Frutto\", ... });"];
            break;

        case "Badge":
            var brow = new UiNode({ flexDirection: "row", flexWrap: "wrap" });
            PreviewCard.add(brow);
            // Mocking Badge with UiButton ghost
            brow.add(new UiButton("Beta", { marginRight: 8, height: 24, paddingLeft: 8, paddingRight: 8 }, { variant: "outline" }));
            brow.add(new UiButton("Success", { marginRight: 8, height: 24, paddingLeft: 8, paddingRight: 8 }, { variant: "primary" }));
            brow.add(new UiButton("Error", { height: 24, paddingLeft: 8, paddingRight: 8 }, { variant: "danger" }));
            codeLines = ["// Badge mocked with small outline buttons", "new UiBadge(\"Beta\");"];
            break;

        case "Alert":
            var alert = new UiNode({ width: "100%", padding: 16, marginBottom: 16 });
            alert.onDraw = method(alert, function() {
                draw_set_color(#FEF2F2); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
                draw_set_color(#FECACA); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
            });
            alert.add(new UiText("Errore: La connessione al server è fallita.", {}, { color: #991B1B }));
            PreviewCard.add(alert);
            codeLines = ["new UiAlert(\"Messaggio\", { variant: \"error\" });"];
            break;

        case "Card":
            var card = new UiNode({ width: "100%", padding: 24, flexDirection: "column" });
            card.onDraw = method(card, function() {
                draw_set_color(c_white); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, false);
                draw_set_color(global.UI_COL_BORDER); draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, true);
            });
            PreviewCard.add(card);
            card.add(new UiText("Titolo Card", { marginBottom: 8, height: 24 }, { color: #0F172A }));
            card.add(new UiText("Questo è un contenuto all'interno di una card moderna.", { height: 40 }, { color: #64748B }));
            codeLines = ["new UiCard({ padding: 24 }, [ ... ]);"];
            break;


        case "Tabs":
            if (!variable_struct_exists(global.UI_DEMO, "tabSelected")) global.UI_DEMO.tabSelected = 0;
            var tabRow = new UiNode({ flexDirection: "row", marginBottom: 20 });
            PreviewCard.add(tabRow);
            
            var btnA = new UiButton("Tab A", { height: 32, marginRight: 4 }, { variant: global.UI_DEMO.tabSelected == 0 ? "primary" : "ghost" });
            btnA.onClick(function() { global.UI_DEMO.tabSelected = 0; __ui_demo_refresh(); });
            tabRow.add(btnA);
            
            var btnB = new UiButton("Tab B", { height: 32, marginRight: 4 }, { variant: global.UI_DEMO.tabSelected == 1 ? "primary" : "ghost" });
            btnB.onClick(function() { global.UI_DEMO.tabSelected = 1; __ui_demo_refresh(); });
            tabRow.add(btnB);
            
            var tabContent = (global.UI_DEMO.tabSelected == 0) ? "Contenuto della Tab A." : "Contenuto della Tab B.";
            PreviewCard.add(new UiText(tabContent, {}, { color: #64748B }));
            codeLines = ["new UiTabs([\"Tab A\", \"Tab B\"]);"];
            break;

        case "Accordion":
            var acc = new UiAccordion("Dettagli Tecnici", { width: "100%" });
            acc.add(new UiText("Questi sono i dettagli espandibili del componente accordion.", { height: 40 }, { color: #64748B }));
            PreviewCard.add(acc);
            codeLines = ["var acc = new UiAccordion(\"Titolo\");", "acc.add(new UiText(\"...\"));"];
            break;

        case "Slider":
            __ui_demo_preview_section(PreviewCard, "Volume");
            PreviewCard.add(new UiSlider({ width: "100%", height: 30 }, { min: 0, max: 100, value: 75 }));
            codeLines = ["new UiSlider({ height: 30 }, { min: 0, max: 100 });"];
            break;

        case "Sprite":
            __ui_demo_preview_section(PreviewCard, "Esempio");
            PreviewCard.add(new UiSprite(sprDemo, { width: 64, height: 64 }));
            codeLines = ["new UiSprite(sprDemo, { width: 64, height: 64 });"];
            break;
            
        case "ContextMenu":
            __ui_demo_preview_section(PreviewCard, "Esempio (Tasto Destro)");
            var zone = new UiNode({ width: "100%", height: 200, backgroundColor: #F1F5F9, borderRadius: 8, justifyContent: "center", alignItems: "center" });
            zone.pointerEvents = true;
            zone.add(new UiText("Clicca col tasto destro qui", {}, { color: #64748B }));
            PreviewCard.add(zone);
            
            zone.onContextMenu(function() {
                var menu = new UiContextMenu(global.UI.mouseX, global.UI.mouseY);
                menu.addItem("Azione 1", function() { show_message("Azione 1"); });
                menu.addItem("Azione 2", function() { show_message("Azione 2"); });
                menu.show();
            });
            
            codeLines = ["node.onContextMenu(function() { ... });"];
            break;

        case "Tooltip":
            PreviewCard.add(new UiButton("Passa il mouse", { width: 150 }, { tooltip: "Il mio fantastico tooltip!" }));
            codeLines = ["new UiButton(\"Text\", {}, { tooltip: \"...\" });"];
            break;
            
        default:
            PreviewCard.add(new UiText("Anteprima per " + global.UI_DEMO.currentPage + " in arrivo.", {}, { color: #64748B }));
            codeLines = ["// Esempio non disponibile"];
    }
    
    // Code Panel
    var CodePanel = new UiNode({ width: 450, height: 300, padding: 24, flexDirection: "column" });
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
