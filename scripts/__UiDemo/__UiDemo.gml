function ui_demo_create() {
    var W = display_get_gui_width();
    var H = display_get_gui_height();
    display_reset(4, true); // Enable MSAA for smoother primitive edges
    
    global.UI_DEMO = {
        currentPage: "Button",
        currentTab: "Preview",
        ScrollArea: undefined,
        BreadcrumbPage: undefined,
        SidebarItems: undefined
    };
    
    // Setup root
    global.UI.setSize(W, H);
    
    // Get overlay and tooltip from root (lazy initialized automatically)
    global.UI.getOverlay();
    global.UI.getTooltip();
    
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
        draw_set_color(global.UI_COL_BOX);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_line(self.x1, self.y2, self.x2, self.y2);
    });
    Content.add(TopBar);
    
    var Breadcrumbs = new UiNode({ flexDirection: "row", flex: 1 });
    Breadcrumbs.add(new UiText("Components", { marginRight: 8 }, { color: "dim" }));
    Breadcrumbs.add(new UiText(">", { marginRight: 8 }, { color: "dim" }));
    global.UI_DEMO.BreadcrumbPage = new UiText("Button", {}, { color: "main" });
    Breadcrumbs.add(global.UI_DEMO.BreadcrumbPage);
    TopBar.add(Breadcrumbs);
    
    var DocLink = new UiText("Documentation", { marginRight: 24 }, { color: "dim", pointerEvents: true, handpoint: true });
    DocLink.onClick(function() {
        url_open("https://manuel-di-iorio.github.io/unique-ui");
    });
    TopBar.add(DocLink);
    
    // Dynamic Theme Toggler (Switch)
    global.UI_DEMO.currentTheme = "light";
    var ThemeToggle = new UiSwitch({ marginRight: 8 }, {
        label: "Dark Mode",
        value: false,
        onChange: function(val) {
            if (val) {
                global.UI_DEMO.currentTheme = "dark";
                ui_set_theme("dark");
            } else {
                global.UI_DEMO.currentTheme = "light";
                ui_set_theme("light");
            }
            __ui_demo_render_sidebar();
            __ui_demo_refresh();
        }
    });
    TopBar.add(ThemeToggle);
    
    // Scroll Area (Main Content)
    var ScrollArea = new UiNode({ flex: 1, width: "100%", flexDirection: "column", padding: 40 });
    Content.add(ScrollArea);
    global.UI_DEMO.ScrollArea = ScrollArea;
    
    __ui_demo_refresh();
    
    // Overlay layer is added automatically by UiRoot
}
