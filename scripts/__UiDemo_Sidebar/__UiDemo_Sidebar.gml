function __ui_demo_render_sidebar() {
    var parent = global.UI_DEMO.SidebarItems;
    parent.destroyChildren(true);
    
    __ui_demo_sidebar_label(parent, "FOUNDATIONS");
    __ui_demo_sidebar_item(parent, "Colors");
    __ui_demo_sidebar_item(parent, "Typography");
    
    __ui_demo_sidebar_label(parent, "COMPONENTS", 20);
    var comps = ["Button", "Textbox", "Select", "Checkbox", "Radio", "Switch", "Badge", "Alert", "Card", "Tabs", "Tooltip", "Slider", "Accordion", "Sprite", "ContextMenu", "Modal", "Treeview"];
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
