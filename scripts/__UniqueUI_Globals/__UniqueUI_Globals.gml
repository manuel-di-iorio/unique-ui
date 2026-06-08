global.UI_VERSION = "5.0.0";

/** Colors */

// Brand
global.UI_COL_PRIMARY         = #2F6FEF;
global.UI_COL_PRIMARY_HOVER         = #215CDA;

// Surface
global.UI_COL_SURFACE_0         = #FBFCFF;
global.UI_COL_SURFACE_1         = #F8FAFC;
global.UI_COL_SURFACE_2         = #EEF3FA;
global.UI_COL_SURFACE_3         = #FFFFFF;

// Text
global.UI_COL_TEXT_1            = #13213A;
global.UI_COL_TEXT_2            = #60708D;

// Border
global.UI_COL_BORDER_1          = #DDE5F0;

// States
global.UI_COL_HOVER             = #EDF3FF;
global.UI_COL_SELECTED          = #3B82F6;

// Floating Elements
global.UI_COL_FLOATING_BG       = #172338;

// Feedback
global.UI_COL_SUCCESS           = #23A75A;
global.UI_COL_WARNING           = #F59E0B;
global.UI_COL_ERROR             = #EF4444;

// Misc
global.UI_COL_SCROLLBAR         = #CBD5E1;

/// @desc Sets a scissor rect using GUI coordinates, automatically scaling them to real window/viewport space.
function __uui_set_scissor(x, y, w, h) {
    var factor_x = window_get_width() / max(1, display_get_gui_width());
    var factor_y = window_get_height() / max(1, display_get_gui_height());
    gpu_set_scissor(x * factor_x, y * factor_y, w * factor_x, h * factor_y);
}

// ── Dynamic Theme Management ───────────────────────────────────────────────
global.UI_THEMES = {};

global.UI_THEMES.dark = {
    primary: #3B82F6,
    primaryHover: #2563EB,
    surface0: #0F172A,
    surface1: #0B0F19,
    surface2: #1E293B,
    surface3: #1E293B,
    text1: #F8FAFC,
    text2: #CBD5E1,
    border1: #334155,
    hover: #334155,
    floatingBg: #1E293B,
    selected: #3B82F6,
    success: #22C55E,
    warning: #F59E0B,
    error: #EF4444,
    scrollbar: #475569
};

global.UI_THEMES.light = {
    primary: #2F6FEF,
    primaryHover: #215CDA,
    surface0: #FBFCFF,
    surface1: #F8FAFC,
    surface2: #EEF3FA,
    surface3: #FFFFFF,
    text1: #13213A,
    text2: #60708D,
    border1: #DDE5F0,
    hover: #EDF3FF,
    floatingBg: #172338,
    selected: #3B82F6,
    success: #23A75A,
    warning: #F59E0B,
    error: #EF4444,
    scrollbar: #CBD5E1
};

/// @desc Sets the active UI theme by name and requests a full redraw.
function ui_set_theme(themeName) {
    var t = global.UI_THEMES[$ themeName];
    if (t == undefined) return;
    global.UI_COL_PRIMARY         = t.primary;
    global.UI_COL_PRIMARY_HOVER         = t.primaryHover;
    global.UI_COL_SURFACE_0         = t.surface0;
    global.UI_COL_SURFACE_1         = t.surface1;
    global.UI_COL_SURFACE_2         = t.surface2;
    global.UI_COL_SURFACE_3         = t.surface3;
    global.UI_COL_TEXT_1            = t.text1;
    global.UI_COL_TEXT_2            = t.text2;
    global.UI_COL_BORDER_1          = t.border1;
    global.UI_COL_HOVER             = t.hover;
    global.UI_COL_SELECTED          = t.selected;
    global.UI_COL_FLOATING_BG       = t.floatingBg;
    global.UI_COL_SUCCESS           = t.success;
    global.UI_COL_WARNING           = t.warning;
    global.UI_COL_ERROR             = t.error;
    global.UI_COL_SCROLLBAR         = t.scrollbar;
    
    if (global.UI != undefined) {
        global.UI.requestRedraw();
    }
}

// ── Font Management & Zoom ─────────────────────────────────────────────────
global.UI_ZOOM = 1;

/// @desc Initializes UI_FONTS based on display resolution and sets UI_ZOOM.
function __uui_init_fonts() {
    var _w = display_get_width();
    var _h = display_get_height();

    if (_w >= 3840 || _h >= 2160) {
        global.UI_FONTS = {
            standard: fText_4K,
            big:     fTextBig_4K,
            small:   fTextSmall_4K,
            italic:  fTextItalic_4K
        };
        global.UI_ZOOM = 1.5;
    } else if (_w >= 2560 || _h >= 1440) {
        global.UI_FONTS = {
            standard: fText_2K,
            big:     fTextBig_2K,
            small:   fTextSmall_2K,
            italic:  fTextItalic_2K
        };
        global.UI_ZOOM = 1.25;
    } else {
        global.UI_FONTS = {
            standard: fText,
            big:     fTextBig,
            small:   fTextSmall,
            italic:  fTextItalic
        };
        global.UI_ZOOM = 1;
    }
}

__uui_init_fonts();

// Full browser size on GX export
if (os_type == os_gxgames) {
    window_set_size(browser_width, browser_height);
}
