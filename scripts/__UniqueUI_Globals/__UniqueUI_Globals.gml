global.UI_VERSION = "3.2.0";

// UI Theme — Modern Premium Palette
global.UI_COL_PRIMARY          = #2563EB;
global.UI_COL_PRIMARY_HOVER    = #1D4ED8;
global.UI_COL_BG_SIDEBAR       = #0F172A;
global.UI_COL_BG_MAIN          = #F8FAFC;
global.UI_COL_BG_CARD          = #FFFFFF;
global.UI_COL_TEXT_MAIN        = #0F172A;
global.UI_COL_TEXT_DIM         = #64748B;
global.UI_COL_BORDER           = #E2E8F0;
global.UI_COL_SELECTED         = #2563EB;
global.UI_COL_SELECTED_HOVER   = #1D4ED8;
global.UI_COL_BTN_HOVER        = #F1F5F9;
global.UI_COL_BOX              = #FFFFFF;
global.UI_COL_INPUT_BG         = #F8FAFC;
global.UI_COL_BAR_BG           = #FFFFFF;
global.UI_COL_CHECKBOX_HOVER   = #F1F5F9;
global.UI_COL_DROPDOWN_LIST_BG = #1E293B;
global.UI_COL_INSPECTOR_BG     = #334155;
global.UI_COL_TREE_BG          = #0F172A;
global.UI_COL_SELECTION       = #3B82F6;
global.UI_COL_SUCCESS         = #22C55E;
global.UI_COL_WARNING         = #F59E0B;
global.UI_COL_DANGER          = #EF4444;

draw_set_circle_precision(64);

// Missing Asset Mocks (required for components to function without crashes)
#macro sprUiTreeviewArrowRight -1
#macro sprUiTreeviewArrowDown -1
#macro sprUiFolderCollapsed -1
#macro sprUiFolderExpanded -1
#macro sprUiCheckboxChecked -1
#macro sprUiCheckboxUnchecked -1
#macro sprUiDropdownArrow -1
#macro sprUiCheckTick -1

/// @desc Sets a scissor rect using GUI coordinates, automatically scaling them to real window/viewport space.
function uui_set_scissor(x, y, w, h) {
    var factor_x = window_get_width() / max(1, display_get_gui_width());
    var factor_y = window_get_height() / max(1, display_get_gui_height());
    gpu_set_scissor(x * factor_x, y * factor_y, w * factor_x, h * factor_y);
}

// ── Dynamic Theme Management ───────────────────────────────────────────────
global.UI_THEMES = {};

global.UI_THEMES.dark = {
    primary: #3B82F6,
    primaryHover: #2563EB,
    bgSidebar: #0B0F19,
    bgMain: #0F172A,
    bgCard: #1E293B,
    textMain: #F8FAFC,
    textDim: #CBD5E1,
    border: #334155,
    selected: #3B82F6,
    selectedHover: #2563EB,
    btnHover: #334155,
    box: #1E293B,
    inputBg: #0B0F19,
    barBg: #1E293B,
    checkboxHover: #334155,
    dropdownListBg: #1E293B,
    inspectorBg: #1E293B,
    treeBg: #0B0F19,
    selection: #3B82F6,
    success: #22C55E,
    warning: #F59E0B,
    danger: #EF4444
};

global.UI_THEMES.light = {
    primary: #2563EB,
    primaryHover: #1D4ED8,
    bgSidebar: #0F172A,
    bgMain: #F8FAFC,
    bgCard: #FFFFFF,
    textMain: #0F172A,
    textDim: #64748B,
    border: #E2E8F0,
    selected: #2563EB,
    selectedHover: #1D4ED8,
    btnHover: #F1F5F9,
    box: #FFFFFF,
    inputBg: #F8FAFC,
    barBg: #FFFFFF,
    checkboxHover: #F1F5F9,
    dropdownListBg: #FFFFFF,
    inspectorBg: #F1F5F9,
    treeBg: #F8FAFC,
    selection: #3B82F6,
    success: #22C55E,
    warning: #F59E0B,
    danger: #EF4444
};

/// @desc Sets the active UI theme by name and requests a full redraw.
function ui_set_theme(themeName) {
    var t = global.UI_THEMES[$ themeName];
    if (t == undefined) return;
    global.UI_COL_PRIMARY          = t.primary;
    global.UI_COL_PRIMARY_HOVER    = t.primaryHover;
    global.UI_COL_BG_SIDEBAR       = t.bgSidebar;
    global.UI_COL_BG_MAIN          = t.bgMain;
    global.UI_COL_BG_CARD          = t.bgCard;
    global.UI_COL_TEXT_MAIN        = t.textMain;
    global.UI_COL_TEXT_DIM         = t.textDim;
    global.UI_COL_BORDER           = t.border;
    global.UI_COL_SELECTED         = t.selected;
    global.UI_COL_SELECTED_HOVER   = t.selectedHover;
    global.UI_COL_BTN_HOVER        = t.btnHover;
    global.UI_COL_BOX              = t.box;
    global.UI_COL_INPUT_BG         = t.inputBg;
    global.UI_COL_BAR_BG           = t.barBg;
    global.UI_COL_CHECKBOX_HOVER   = t.checkboxHover;
    global.UI_COL_DROPDOWN_LIST_BG = t.dropdownListBg;
    global.UI_COL_INSPECTOR_BG     = t.inspectorBg;
    global.UI_COL_TREE_BG          = t.treeBg;
    global.UI_COL_SELECTION       = t.selection;
    global.UI_COL_SUCCESS         = t.success;
    global.UI_COL_WARNING         = t.warning;
    global.UI_COL_DANGER          = t.danger;
    
    if (global.UI != undefined) {
        global.UI.requestRedraw();
    }
}
