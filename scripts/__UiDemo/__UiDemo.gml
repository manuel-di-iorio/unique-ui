/// @desc UI Demo - AAA Showcase of all UniqueUI components
function ui_demo_create() {
    var W = display_get_gui_width();
    var H = display_get_gui_height();
    
    // Setup root
    global.UI.setSize(W, H);
    
    // Overlay node (needed for dropdowns/context menus)
    global.UI.Overlay = new UiNode({ name: "Overlay", position: "absolute", left: 0, top: 0, width: W, height: H });
    global.UI.add(global.UI.Overlay);
    
    // Tooltip
    global.UI.Tooltip = new UiTooltip();
    global.UI.Overlay.add(global.UI.Tooltip);
    
    // ============================================================
    // MAIN LAYOUT
    // ============================================================
    var Main = new UiNode({
        name: "Main",
        width: W, height: H,
        flexDirection: "row",
    });
    global.UI.add(Main);
    
    // === SIDEBAR ===
    var Sidebar = new UiNode({
        name: "Sidebar",
        width: 240,
        height: H,
        flexDirection: "column",
        paddingTop: 24,
        paddingLeft: 20,
        paddingRight: 20,
    });
    Sidebar.onDraw = method(Sidebar, function() {
        // Dark sidebar bg
        draw_set_color(#0D0E14);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
        // Right edge glow
        draw_set_alpha(0.3);
        draw_set_color(#1166FF);
        draw_rectangle(self.x2 - 1, self.y1, self.x2, self.y2, false);
        draw_set_alpha(0.1);
        draw_rectangle(self.x2 - 3, self.y1, self.x2 - 1, self.y2, false);
        draw_set_alpha(1);
    });
    Main.add(Sidebar);
    
    // Logo
    var Logo = new UiText("Unique UI", { marginBottom: 2 }, { color: #7AA2F7 });
    Sidebar.add(Logo);
    var Version = new UiText("v2.1.0", { marginBottom: 30, height: 14 }, { color: #565F89 });
    Sidebar.add(Version);
    
    // Divider
    var sideDiv = new UiNode({ width: "100%", height: 1, marginBottom: 16 });
    sideDiv.onDraw = method(sideDiv, function() {
        draw_set_color(#1A1B2E);
        draw_line(self.x1, self.y1, self.x2, self.y1);
    });
    Sidebar.add(sideDiv);
    
    // Section nav label
    var navLabel = new UiText("COMPONENTS", { marginBottom: 10, height: 12 }, { color: #3B3E52 });
    Sidebar.add(navLabel);

    // Nav buttons
    var sections = ["Buttons", "Text", "Textbox", "Checkbox", "Switch", "Slider", "Dropdown", "Accordion", "Scrollbar", "Tooltips"];
    global.__demo_sections = [];
    
    for (var i = 0; i < array_length(sections); i++) {
        var navBtn = new UiButton(sections[i], { 
            width: 200, height: 30, marginBottom: 2
        }, { halign: fa_left, outline: true, enableRipple: true });
        navBtn.onClick(method({ idx: i }, function() {
            if (idx < array_length(global.__demo_sections)) {
                var target = global.__demo_sections[idx];
                var scrollParent = target.scrollableParent;
                if (scrollParent != undefined) {
                    scrollParent.scrollTop = max(0, target.layout.top - scrollParent.layout.top - 10);
                    global.UI.requestUpdate();
                    global.UI.requestRedraw();
                }
            }
        }));
        Sidebar.add(navBtn);
    }
    
    // === CONTENT AREA ===
    var Content = new UiNode({
        name: "Content",
        flex: 1,
        height: H,
        flexDirection: "column",
        paddingTop: 24,
        paddingLeft: 36,
        paddingRight: 36,
        paddingBottom: 40,
    });
    Content.onDraw = method(Content, function() {
        draw_set_color(#11121A);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
    });
    Main.add(Content);
    Content.enableScrollbar(#7AA2F7);
    
    // === HEADER BANNER ===
    var Header = new UiNode({ width: "100%", height: 70, marginBottom: 24 });
    Header.onDraw = method(Header, function() {
        // Gradient background
        var steps = 20;
        var h = self.y2 - self.y1;
        for (var i = 0; i < steps; i++) {
            var t = i / steps;
            var r = lerp(colour_get_red(#1A1B3A), colour_get_red(#0D1020), t);
            var g = lerp(colour_get_green(#1A1B3A), colour_get_green(#0D1020), t);
            var b = lerp(colour_get_blue(#1A1B3A), colour_get_blue(#0D1020), t);
            draw_set_color(make_colour_rgb(r, g, b));
            var yy1 = self.y1 + (h * i / steps);
            var yy2 = self.y1 + (h * (i + 1) / steps);
            draw_rectangle(self.x1, yy1, self.x2, yy2, false);
        }
        // Border
        draw_set_color(#24263A);
        draw_roundrect(self.x1, self.y1, self.x2, self.y2, true);
        // Blue accent line at top
        draw_set_color(#7AA2F7);
        draw_rectangle(self.x1, self.y1, self.x2, self.y1 + 2, false);
        // Title
        draw_set_font(fText); draw_set_color(#C0CAF5);
        draw_set_halign(fa_left); draw_set_valign(fa_middle);
        draw_text(self.x1 + 24, ~~mean(self.y1, self.y2), "Component Showcase");
        // Subtitle
        draw_set_color(#565F89);
        var tw = string_width("Component Showcase");
        draw_text(self.x1 + 24 + tw + 16, ~~mean(self.y1, self.y2), "Interactive Demo");
    });
    Content.add(Header);
    
    // ============================================================
    // SECTION: Buttons
    // ============================================================
    var secButtons = __ui_demo_section(Content, "Buttons", "Click, hover with ripple effects, and selection state");
    array_push(global.__demo_sections, secButtons);
    
    // Row of buttons
    var btnRow = new UiNode({ flexDirection: "row", marginBottom: 12 });
    secButtons.add(btnRow);
    
    var btn1 = new UiButton("Primary", { marginRight: 10 });
    var btn2 = new UiButton("Secondary", { marginRight: 10 });
    var btn3 = new UiButton("Outline", { marginRight: 10 }, { outline: true });
    var btn4 = new UiButton("No Ripple", {}, { enableRipple: false });
    btnRow.add(btn1, btn2, btn3, btn4);
    
    // Status text
    var btnStatus = new UiText("Click any button to see events in action", { marginTop: 6, height: 16 }, { color: #565F89 });
    secButtons.add(btnStatus);
    
    btn1.onClick(method({ btnStatus }, function() { btnStatus.text = "> Primary button clicked"; btnStatus.color = #7AA2F7; btnStatus.computeSize(); }));
    btn2.onClick(method({ btnStatus }, function() { btnStatus.text = "> Secondary button clicked"; btnStatus.color = #9ECE6A; btnStatus.computeSize(); }));
    btn3.onClick(method({ btnStatus }, function() { btnStatus.text = "> Outline button clicked"; btnStatus.color = #E0AF68; btnStatus.computeSize(); }));
    btn4.onClick(method({ btnStatus }, function() { btnStatus.text = "> No Ripple button clicked"; btnStatus.color = #F7768E; btnStatus.computeSize(); }));
    
    // Selected toggle
    var btnRow2 = new UiNode({ flexDirection: "row", marginTop: 12 });
    secButtons.add(btnRow2);
    var selBtn = new UiButton("Toggle Selected State", {});
    selBtn.onClick(method({ selBtn }, function() { selBtn.selected = !selBtn.selected; }));
    btnRow2.add(selBtn);
    
    // ============================================================
    // SECTION: Text
    // ============================================================
    var secText = __ui_demo_section(Content, "Text", "Static labels, colored text, and dynamic value getters");
    array_push(global.__demo_sections, secText);
    
    var txt1 = new UiText("Standard text with default styling", { marginBottom: 4 }, { color: #C0CAF5 });
    var txt2 = new UiText("Accent colored text", { marginBottom: 4 }, { color: #7AA2F7 });
    var txt3 = new UiText("Success colored text", { marginBottom: 4 }, { color: #9ECE6A });
    var txt4 = new UiText("Warning colored text", { marginBottom: 4 }, { color: #E0AF68 });
    var txt5 = new UiText("Error colored text", { marginBottom: 8 }, { color: #F7768E });
    secText.add(txt1, txt2, txt3, txt4, txt5);
    
    // Dynamic text
    var dynText = new UiText("", { height: 16 }, {
        color: #565F89,
        valueGetter: function() {
            return "Dynamic value: " + string(current_time div 1000) + "s elapsed";
        }
    });
    secText.add(dynText);
    
    // ============================================================
    // SECTION: Textbox
    // ============================================================
    var secTextbox = __ui_demo_section(Content, "Textbox", "Editable fields with format validation, undo/redo, and selection");
    array_push(global.__demo_sections, secTextbox);
    
    var tb1 = new UiTextbox({ height: 28, width: 350, marginBottom: 10 }, {
        label: "Name",
        placeholder: "Type something here...",
        value: "",
    });
    secTextbox.add(tb1);
    
    var tb2 = new UiTextbox({ height: 28, width: 350, marginBottom: 10 }, {
        label: "Integer",
        placeholder: "Numbers only",
        format: "integer",
        value: "42",
    });
    secTextbox.add(tb2);
    
    var tb3 = new UiTextbox({ height: 28, width: 350 }, {
        label: "Float",
        placeholder: "e.g. 3.14",
        format: "float",
        value: "3.14",
        negative: true,
    });
    secTextbox.add(tb3);
    
    // ============================================================
    // SECTION: Checkbox
    // ============================================================
    var secCheckbox = __ui_demo_section(Content, "Checkbox", "Toggle boolean values with visual feedback");
    array_push(global.__demo_sections, secCheckbox);
    
    var cbCol = new UiNode({ flexDirection: "column" });
    secCheckbox.add(cbCol);
    
    var cb1 = new UiCheckbox({ height: 22, marginBottom: 6 }, { label: "Enable feature A", value: false });
    var cb2 = new UiCheckbox({ height: 22, marginBottom: 6 }, { label: "Enable feature B", value: false });
    var cb3 = new UiCheckbox({ height: 22, marginBottom: 6 }, { label: "Dark mode", value: false });
    cbCol.add(cb1, cb2, cb3);
    
    var cbStatus = new UiText("", { marginTop: 6, height: 16 }, { 
        color: #565F89,
        valueGetter: method({ cb1, cb2, cb3 }, function() {
            return "State:  A=" + (cb1.value ? "ON" : "off") 
                 + "   B=" + (cb2.value ? "ON" : "off") 
                 + "   Dark=" + (cb3.value ? "ON" : "off");
        })
    });
    secCheckbox.add(cbStatus);
    
    // ============================================================
    // SECTION: Switch
    // ============================================================
    var secSwitch = __ui_demo_section(Content, "Switch", "Modern toggle controls with smooth animation");
    array_push(global.__demo_sections, secSwitch);
    
    var swRow = new UiNode({ flexDirection: "row", marginBottom: 12 });
    secSwitch.add(swRow);
    
    var sw1 = new UiSwitch({ marginRight: 20 }, { label: "Wi-Fi", value: true });
    var sw2 = new UiSwitch({ marginRight: 20 }, { label: "Bluetooth", value: false });
    var sw3 = new UiSwitch({}, { label: "Airplane Mode", value: false });
    swRow.add(sw1, sw2, sw3);
    
    // ============================================================
    // SECTION: Slider
    // ============================================================
    var secSlider = __ui_demo_section(Content, "Slider", "Select a value from a continuous range");
    array_push(global.__demo_sections, secSlider);
    
    var sl1 = new UiSlider({ width: 300, height: 30, marginBottom: 4 }, { min: 0, max: 100, value: 50, step: 1 });
    secSlider.add(sl1);
    
    var slText1 = new UiText("", { marginTop: 4, marginBottom: 10 }, { 
        color: #565F89, 
        valueGetter: method({sl1}, function() { return "Volume: " + string(sl1.value) + "%"; }) 
    });
    secSlider.add(slText1);
    
    var sl2 = new UiSlider({ width: 300, height: 30 }, { min: 0, max: 1, value: 0.5, step: 0.05 });
    secSlider.add(sl2);
    
    // ============================================================
    // SECTION: Dropdown
    // ============================================================
    var secDropdown = __ui_demo_section(Content, "Dropdown", "Select from a list with keyboard and mouse support");
    array_push(global.__demo_sections, secDropdown);
    
    var dd1 = new UiDropdown({ height: 28, width: 380, marginBottom: 12 }, {
        label: "Theme",
        items: [
            { label: "Tokyo Night", value: "tokyo" },
            { label: "Dracula", value: "dracula" },
            { label: "Monokai Pro", value: "monokai" },
            { label: "One Dark", value: "onedark" },
            { label: "Catppuccin", value: "catppuccin" },
        ],
        value: "tokyo",
    });
    secDropdown.add(dd1);
    
    var dd2 = new UiDropdown({ height: 28, width: 380 }, {
        label: "Font Size",
        items: [
            { label: "Small (10px)", value: 10 },
            { label: "Medium (14px)", value: 14 },
            { label: "Large (18px)", value: 18 },
            { label: "Extra Large (24px)", value: 24 },
        ],
        value: 14,
    });
    secDropdown.add(dd2);
    
    // ============================================================
    // SECTION: Accordion
    // ============================================================
    var secAccordion = __ui_demo_section(Content, "Accordion", "Collapsible sections to organize content");
    array_push(global.__demo_sections, secAccordion);
    
    var acc1 = new UiAccordion("General Settings", { marginBottom: 4 });
    acc1.add(new UiText("Configure basic application settings.", { marginTop: 6 }, { color: #787C99 }));
    acc1.add(new UiCheckbox({ height: 22, marginTop: 6 }, { label: "Auto-save", value: false }));
    acc1.add(new UiCheckbox({ height: 22, marginTop: 4 }, { label: "Notifications", value: false }));
    secAccordion.add(acc1);
    
    var acc2 = new UiAccordion("Advanced Settings", { marginBottom: 4 }, { collapsed: true });
    acc2.add(new UiText("Fine-tune performance parameters.", { marginTop: 6 }, { color: #787C99 }));
    acc2.add(new UiTextbox({ height: 25, width: 300, marginTop: 6 }, { 
        label: "Max FPS", format: "integer", value: "60" 
    }));
    secAccordion.add(acc2);
    
    var acc3 = new UiAccordion("About", { marginBottom: 4 }, { collapsed: true });
    acc3.add(new UiText("UniqueUI v2.1.0", { marginTop: 6 }, { color: #787C99 }));
    acc3.add(new UiText("A flexible, retained-mode UI library for GameMaker.", { marginTop: 2 }, { color: #565F89 }));
    secAccordion.add(acc3);
    
    // ============================================================
    // SECTION: Scrollbar
    // ============================================================
    var secScroll = __ui_demo_section(Content, "Scrollbar", "Scrollable containers with mouse wheel and drag support");
    array_push(global.__demo_sections, secScroll);
    
    var scrollBox = new UiNode({
        width: "100%", height: 160,
        flexDirection: "column",
    }, { border: true, pointerEvents: true });
    scrollBox.onDraw = method(scrollBox, function() {
        draw_set_color(#15161E);
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
    });
    scrollBox.enableScrollbar(#7AA2F7);
    
    for (var i = 0; i < 25; i++) {
        var lineNode = new UiNode({ width: "100%", height: 26, paddingLeft: 12 });
        lineNode.__lineIdx = i;
        lineNode.onDraw = method(lineNode, function() {
            // Alternate row color
            if (self.__lineIdx % 2 == 0) {
                draw_set_color(#1A1B2E);
                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
            }
        });
        var lineText = new UiText("Item #" + string(i + 1) + "  —  Scrollable content row", { marginTop: 5 }, { color: #787C99 });
        lineNode.add(lineText);
        scrollBox.add(lineNode);
    }
    secScroll.add(scrollBox);
    
    // ============================================================
    // SECTION: Tooltips
    // ============================================================
    var secTooltips = __ui_demo_section(Content, "Tooltips", "Hover over elements to reveal contextual information");
    array_push(global.__demo_sections, secTooltips);
    
    var tipRow = new UiNode({ flexDirection: "row" });
    secTooltips.add(tipRow);
    
    var tipBtn1 = new UiButton("Hover me", { marginRight: 10 });
    tipBtn1.tooltip = "Primary tooltip — instant feedback";
    tipBtn1.tooltipDelay = 300;
    tipRow.add(tipBtn1);
    
    var tipBtn2 = new UiButton("Me too", { marginRight: 10 });
    tipBtn2.tooltip = "Another tooltip with details";
    tipBtn2.tooltipDelay = 300;
    tipRow.add(tipBtn2);
    
    var tipBtn3 = new UiButton("Slow tooltip", {});
    tipBtn3.tooltip = "This appears after 1 second delay";
    tipBtn3.tooltipDelay = 1000;
    tipRow.add(tipBtn3);
    
    // Bottom spacer
    Content.add(new UiNode({ height: 50 }));
}

/// @desc Helper: Create a styled section card
function __ui_demo_section(parent, title, subtitle) {
    var sec = new UiNode({
        name: "Section_" + title,
        width: "100%",
        flexDirection: "column",
        paddingLeft: 20,
        paddingTop: 16,
        paddingRight: 20,
        paddingBottom: 20,
        marginBottom: 20,
    });
    sec.onDraw = method(sec, function() {
        var radius = 8;
        
        // Soft drop shadow
        draw_set_color(#000000);
        draw_set_alpha(0.2);
        draw_roundrect_ext(self.x1 + 4, self.y1 + 4, self.x2 + 4, self.y2 + 4, radius, radius, false);
        draw_set_alpha(1);
        
        // Card bg
        draw_set_color(#1A1B2E);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
        
        // Inner highlight
        draw_set_color(#ffffff);
        draw_set_alpha(0.02);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
        draw_set_alpha(1);
        
        // Border
        draw_set_color(#24263A);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, true);
        
        // Left accent bar
        draw_set_color(#7AA2F7);
        draw_roundrect_ext(self.x1, self.y1 + 14, self.x1 + 4, self.y1 + 34, 2, 2, false);
    });
    
    // Title
    var titleNode = new UiText(title, { marginBottom: 2 }, { color: #C0CAF5 });
    sec.add(titleNode);
    
    // Subtitle
    var subNode = new UiText(subtitle, { marginBottom: 14, height: 14 }, { color: #565F89 });
    sec.add(subNode);
    
    // Separator
    var sep = new UiNode({ width: "100%", height: 1, marginBottom: 14 });
    sep.onDraw = method(sep, function() {
        draw_set_color(#24263A);
        draw_line(self.x1, self.y1, self.x2, self.y1);
    });
    sec.add(sep);
    
    parent.add(sec);
    return sec;
}
