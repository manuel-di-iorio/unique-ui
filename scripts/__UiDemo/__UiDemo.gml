function ui_demo_create() {
    var W = max(1, window_get_width());
    var H = max(1, window_get_height());
    display_reset(display_aa >= 8 ? 8 : (display_aa >= 4 ? 4 : (display_aa >= 2 ? 2 : 1)), true);
    display_set_gui_size(W, H);
    device_mouse_dbclick_enable(false);
    draw_enable_svg_aa(true);
    draw_set_svg_aa_level(.1);
    call_later(1, time_source_units_frames, function() {
        window_command_run(window_command_maximize);
    });
    
    global.UI_DEMO = {
        currentPage: "Introduction",
        currentTab: "Preview",
        currentTheme: "light",
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
        name: "Sidebar", width: 284, height: "100%", flexDirection: "column",
        paddingTop: 18, paddingLeft: 24, paddingRight: 20, paddingBottom: 18,
    });
    Sidebar.onDraw = method(Sidebar, function() {
        draw_set_color(global.UI_COL_SURFACE_1);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_line(self.x2, self.y1, self.x2, self.y2);
    });
    Main.add(Sidebar);

    // Logo
    global.UI_DEMO.LogoRowContainer = new UiNode({ marginBottom: 24 });
    Sidebar.add(global.UI_DEMO.LogoRowContainer);
    __ui_demo_render_logo();
    
    global.UI_DEMO.SearchQuery = "";
    
    // Search
    var SearchInput = new UiTextbox({ width: "100%", height: 40, marginBottom: 26 }, {
        placeholder: "Search components...",
        value: global.UI_DEMO.SearchQuery,
        iconLeft: sprUiIconSearch,
        onChange: function(val) {
            global.UI_DEMO.SearchQuery = string_lower(val);
            // In-place show/hide: no node creation/destruction, onChange stays lightweight
            // so keyboard_string-based OS key repeat works normally.
            __ui_demo_filter_sidebar();
        }
    });
    global.UI_DEMO.SearchInput = SearchInput;
    Sidebar.add(SearchInput);
    
    // Sidebar List
    var SidebarItems = new UiNode({ flex: 1, width: "100%", flexDirection: "column" });
    SidebarItems.enableScrollbar(function() { return global.UI_COL_SCROLLBAR; });
    Sidebar.add(SidebarItems);
    global.UI_DEMO.SidebarItems = SidebarItems;
    
    __ui_demo_render_sidebar();
    
    // === CONTENT AREA ===
    var Content = new UiNode({ name: "Content", flex: 1, height: "100%", flexDirection: "column" });
    Content.onDraw = method(Content, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
    });
    Main.add(Content);
    
    // Top Bar
    var TopBar = new UiNode({ width: "100%", height: 98, flexDirection: "row", alignItems: "center", paddingLeft: 46, paddingRight: 38 });
    TopBar.onDraw = method(TopBar, function() {
        draw_set_color(global.UI_COL_SURFACE_3);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_line(self.x1, self.y2, self.x2, self.y2);
    });
    Content.add(TopBar);
    
    var Breadcrumbs = new UiNode({ flexDirection: "row", flex: 1 });
    Breadcrumbs.add(new UiText("Components", { marginRight: 8 }, { color: "dim" }));
    Breadcrumbs.add(new UiText(">", { marginRight: 8 }, { color: "dim" }));
    global.UI_DEMO.BreadcrumbPage = new UiText("Introduction", {}, { color: "main" });
    Breadcrumbs.add(global.UI_DEMO.BreadcrumbPage);
    TopBar.add(Breadcrumbs);
    
    var DocLink = new UiText("Documentation", { marginRight: 14 }, { color: "dim", pointerEvents: true, handpoint: true });
    DocLink.onClick(function() {
        url_open("https://manuel-di-iorio.github.io/unique-ui");
    });
    TopBar.add(DocLink);

    var BookIcon = __ui_demo_icon_button(sprUiIconBook, 42);
    BookIcon.onClick(function() {
        url_open("https://manuel-di-iorio.github.io/unique-ui");
    });
    TopBar.add(BookIcon);

    var Divider = new UiNode({ width: 1, height: 34, marginLeft: 20, marginRight: 20 });
    Divider.onDraw = method(Divider, function() {
        draw_set_color(#E5EAF3);
        draw_line(self.x1, self.y1, self.x1, self.y2);
    });
    TopBar.add(Divider);
    
    // Dynamic Theme Toggler (Switch)
    global.UI_DEMO.currentTheme = "light";
    var ThemeToggle = __ui_demo_icon_button(sprUiIconSun, 42);
    ThemeToggle.onClick(function() {
            if (global.UI_DEMO.currentTheme == "light") {
                global.UI_DEMO.currentTheme = "dark";
                ui_set_theme("dark");
            } else {
                global.UI_DEMO.currentTheme = "light";
                ui_set_theme("light");
            }
            __ui_demo_render_logo();
            __ui_demo_render_sidebar();
            __ui_demo_refresh();
    });
    TopBar.add(ThemeToggle);
    
    // Scroll Area (Main Content)
    var ScrollArea = new UiNode({ flex: 1, width: "100%", flexDirection: "column", paddingLeft: 46, paddingRight: 38, paddingTop: 30, paddingBottom: 36 });
    Content.add(ScrollArea);
    global.UI_DEMO.ScrollArea = ScrollArea;
    
    __ui_demo_refresh();
}

function __ui_demo_render_logo() {
    var container = global.UI_DEMO.LogoRowContainer;
    container.destroyChildren(true);
    var LogoRow = new UiNode({ flexDirection: "row", alignItems: "center" });
    var _theme = variable_struct_exists(global.UI_DEMO, "currentTheme") ? global.UI_DEMO.currentTheme : "light";
    var _logoSprite = (_theme == "dark") ? sprLogoWhite : sprLogo;
    container.add(LogoRow);
    //LogoRow.add(new UiText("Unique UI", { marginRight: 10 }, { color: "main" }));
    LogoRow.add(new UiSprite(_logoSprite, { marginRight: 10 }));
    
    var VersionBadge = new UiNode({ paddingLeft: 7, paddingRight: 7, height: 24, justifyContent: "center" });
    VersionBadge.onDraw = method(VersionBadge, function() {
        draw_set_color(#E8F0FF);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
    });
    VersionBadge.add(new UiText(global.UI_VERSION, {}, { color: global.UI_COL_PRIMARY }));
    LogoRow.add(VersionBadge);
}

function __ui_demo_icon_button(iconName, size = 36) {
    var btn = new UiNode({ width: size, height: size, justifyContent: "center", alignItems: "center" }, { pointerEvents: true, handpoint: true });
    btn.__iconName = iconName;
    btn.onMouseEnter(function() { global.UI.requestRedraw(); });
    btn.onMouseLeave(function() { global.UI.requestRedraw(); });
    btn.onDraw = method(btn, function() {
        if (self.hovered) {
            draw_set_color(global.UI_COL_HOVER);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        }
        var icon_color = (global.UI_DEMO.currentTheme == "dark") ? c_white : global.UI_COL_TEXT_1;
        __ui_demo_draw_icon(self.__iconName, ~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), icon_color, 1.1);
    });
    return btn;
}

function __ui_demo_draw_icon(spr, cx, cy, col, scale = 1) {
    var target_size = 24 * scale * global.UI_ZOOM;
    var spr_w = sprite_get_width(spr);
    var spr_h = sprite_get_height(spr);
    var factor_x = target_size / spr_w;
    var factor_y = target_size / spr_h;
    var offset_x = (spr_w / 2 - sprite_get_xoffset(spr)) * factor_x;
    var offset_y = (spr_h / 2 - sprite_get_yoffset(spr)) * factor_y;
    draw_sprite_ext(spr, 0, cx - offset_x, cy - offset_y, factor_x, factor_y, 0, col, 1);
}
