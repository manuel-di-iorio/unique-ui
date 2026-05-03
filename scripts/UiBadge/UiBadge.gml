/// @desc UiBadge — small status indicator with colored background and label.
/// Variants: "default", "primary", "success", "warning", "danger", "info"
function UiBadge(text, style = {}, props = {}): UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "UiBadge");
    self.text    = text;
    self.variant = props[$ "variant"] ?? "default";
    self.dot     = props[$ "dot"]     ?? false; // Show as a dot (no text)
    
    // Size defaults if not specified
    if (style[$ "height"] == undefined) self.setHeight(22);
    if (!self.dot && style[$ "width"] == undefined) {
        draw_set_font(fText);
        self.setWidth(string_width(text) + 18);
    } else if (self.dot) {
        self.setWidth(10);
        self.setHeight(10);
    }
    
    function __badge_colors() {
        switch (self.variant) {
            case "primary": return { bg: global.UI_COL_PRIMARY, text: c_white };
            case "success": return { bg: #16A34A, text: c_white };
            case "warning": return { bg: #D97706, text: c_white };
            case "danger":  return { bg: #DC2626, text: c_white };
            case "info":    return { bg: #0EA5E9, text: c_white };
            default:        return { bg: #E2E8F0, text: #475569 };
        }
    }
    
    self.onDraw = function() {
        var cols = __badge_colors();
        var r    = self.dot ? min(self.width, self.height) / 2 : 11;
        
        draw_set_color(cols.bg);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, r, r, false);
        
        if (!self.dot && self.text != undefined && self.text != "") {
            draw_set_font(fText);
            draw_set_color(cols.text);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(floor(mean(self.x1, self.x2)), floor(mean(self.y1, self.y2)), self.text);
        }
    };
    
    /// @desc Updates the badge text and resizes.
    function setText(_text) {
        self.text = _text;
        if (!self.dot) {
            draw_set_font(fText);
            self.setWidth(string_width(_text) + 18);
        }
        global.UI.requestRedraw();
    }
    
    /// @desc Changes the badge variant.
    function setVariant(_variant) {
        self.variant = _variant;
        global.UI.requestRedraw();
    }
}
