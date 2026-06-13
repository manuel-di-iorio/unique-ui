function __ui_demo_render_sidebar() {
    var parent = global.UI_DEMO.SidebarItems;
    parent.destroyChildren(true);
    
    __ui_demo_sidebar_label(parent, "FOUNDATIONS");
    __ui_demo_sidebar_item(parent, "Introduction");
    __ui_demo_sidebar_item(parent, "Colors");
    __ui_demo_sidebar_item(parent, "Typography");
    __ui_demo_sidebar_item(parent, "Store");
    
    __ui_demo_sidebar_label(parent, "COMPONENTS", 20);
    var comps = ["Button", "Textbox", "Textarea", "Select", "ColorPicker", "Checkbox", "Radio", "Switch", "Badge", "Alert", "Toast", "Card", "Tabs", "Tooltip", "Slider", "Accordion", "Sprite", "ContextMenu", "MenuBar", "Modal", "Treeview", "Scrollbar", "VirtualList", "VirtualGrid", "VirtualTreeview"];
    array_sort(comps, true);
    for (var i = 0; i < array_length(comps); i++) {
        __ui_demo_sidebar_item(parent, comps[i]);
    }
    
    // Re-apply current search filter without rebuilding
    __ui_demo_filter_sidebar();
}

function __ui_demo_filter_sidebar() {
    var q = global.UI_DEMO.SearchQuery;
    var _items = global.UI_DEMO.SidebarItems.children;
    var _len = array_length(_items);
    for (var i = 0; i < _len; i++) {
        var _item = _items[i];
        if (!variable_struct_exists(_item, "__text")) continue; // skip labels (UiText)
        var _shouldShow = (q == "" || string_pos(q, string_lower(_item.__text)) > 0);
        if (_shouldShow != _item.display) {
            if (_shouldShow) _item.show(); else _item.hide();
        }
    }
}

function __ui_demo_sidebar_item(parent, text) {
    var isSelected = (text == global.UI_DEMO.currentPage);
    var item = new UiNode({ width: "100%", height: 36, marginBottom: 2, paddingLeft: 12 }, { pointerEvents: true, handpoint: true });
    item.__text = text;
    item.__selected = isSelected;
    item.__icon = __ui_demo_sidebar_icon_name(text);
    item.onMouseEnter(function() { global.UI.requestRedraw(); });
    item.onMouseLeave(function() { global.UI.requestRedraw(); });
    item.onDraw = method(item, function() {
        if (self.__selected) {
            draw_set_color(#EAF1FF);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 7, 7, false);
        } else if (self.hovered) {
            draw_set_color(global.UI_COL_HOVER);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 7, 7, false);
        }
        
        var col = self.__selected ? global.UI_COL_PRIMARY : global.UI_COL_TEXT_1;
        __ui_demo_draw_icon(self.__icon, self.x1 + 18, ~~mean(self.y1, self.y2), col, 0.78);
        draw_set_font(global.UI_FONTS.standard);
        draw_set_color(col);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(self.x1 + 40, ~~mean(self.y1, self.y2), self.__text);
    });
    item.onClick(method({ text }, function() {
        global.UI_DEMO.currentPage = text;
        global.UI_DEMO.currentTab = "Preview";
        __ui_demo_render_sidebar();
        __ui_demo_refresh();
    }));
    parent.add(item);
}

function __ui_demo_sidebar_label(parent, text, mt = 0) {
    parent.add(new UiText(text, { marginTop: mt, marginBottom: 12, marginLeft: 12 }, { color: global.UI_COL_TEXT_2, font: global.UI_FONTS.small }));
}

function __ui_demo_sidebar_icon_name(text) {
    switch (string_lower(text)) {
        case "introduction": return sprUiIconBook;
        case "colors": return sprUiIconPalette;
        case "typography": return sprUiIconTypography;
        case "store": return sprUiIconState;
        case "textbox": return sprUiIconTextbox;
        case "textarea": return sprUiIconTextarea;
        case "select": return sprUiIconSelect;
        case "colorpicker": return sprUiIconPicker;
        case "checkbox": return sprUiIconCheckbox;
        case "radio": return sprUiIconRadio;
        case "switch": return sprUiIconSwitchOn;
        case "badge": return sprUiIconBadge;
        case "alert": return sprUiIconAlert;
        case "toast": return sprUiIconToast;
        case "card": return sprUiIconCard;
        case "tabs": return sprUiIconTabs;
        case "tooltip": return sprUiIconTooltip;
        case "slider": return sprUiIconSlider;
        case "accordion": return sprUiIconAccordion;
        case "sprite": return sprUiIconSprite;
        case "contextmenu": return sprUiIconMenu;
        case "menubar": return sprUiIconMenuBar;
        case "modal": return sprUiIconModal;
        case "treeview": return sprUiIconTreeview;
        case "scrollbar": return sprUiIconScrollbar;
        case "virtuallist": return sprUiIconVirtualList;
        case "virtualgrid": return sprUiIconVirtualGrid;
        case "virtualtreeview": return sprUiIconTreeview;
        default: return sprUiIconButton;
    }
}
