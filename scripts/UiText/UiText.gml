function UiText(text = "", style = {}, props = {}): UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "UiText");
    self.value = text;
    self.style = style;
    self.autoResize = props[$ "autoResize"] ?? (style[$ "width"] == undefined && style[$ "height"] == undefined) ?? true;
    self.halign = fa_left;
    self.valign = fa_top;
    self.icon = props[$ "icon"];
    self.color = props[$ "color"] ?? c_white;
    self.font = props[$ "font"] ?? global.UI_FONTS.standard;
    self.wrap = props[$ "wrap"] ?? (style[$ "width"] != undefined);
    self.sep = props[$ "sep"] ?? -1;
    self.__lastWrapWidth = 0;
    
    function computeSize() {
        draw_set_font(self.font);
        var _w = 0;
        var _h = 0;
        
        var _fixedWidth = style[$ "width"];
        if (self.wrap && is_numeric(_fixedWidth)) {
            _w = _fixedWidth;
            _h = string_height_ext(self.value, self.sep, _w);
        } else {
            _w = string_width(self.value);
            if (self.icon != undefined) _w += sprite_get_width(self.icon) + 10;
            _h = string_height(self.value);
        }
        
        if (self.autoResize || self.style[$ "width"] == undefined) {
            self.setWidth(_w);
        }
        if (self.autoResize || self.style[$ "height"] == undefined) {
            self.setHeight(_h);
        }
    }
    
    self.onStep(function() {
        if (self.wrap) {
            var _currentWidth = self.x2 - self.x1;
            if (self.icon) _currentWidth -= 23;
            
            if (_currentWidth > 0 && _currentWidth != self.__lastWrapWidth) {
                self.__lastWrapWidth = _currentWidth;
                draw_set_font(self.font);
                var _h = string_height_ext(self.value, self.sep, _currentWidth);
                if (abs(_h - (self.y2 - self.y1)) > 1) {
                    self.setHeight(_h);
                }
            }
        }
    });
    
    function onDraw() {
        var _x = self.x1;
        var _y = self.y1;
        
        if (self.icon) {
            draw_sprite(self.icon, 0, _x + 7, ~~mean(self.y1, self.y2));
            _x += 23;
        }
        
        var textCol = self.color;
        if (textCol == "main" || textCol == #0F172A || textCol == #F8FAFC || textCol == global.UI_COL_TEXT_1 || textCol == c_white || textCol == undefined) {
            textCol = global.UI_COL_TEXT_1;
        } else if (textCol == "dim" || textCol == #64748B || textCol == #CBD5E1 || textCol == global.UI_COL_TEXT_2) {
            textCol = global.UI_COL_TEXT_2;
        } else if (typeof(textCol) == "method") {
            textCol = textCol();
        }
        
        draw_set_font(self.font); draw_set_color(textCol); draw_set_halign(self.halign); draw_set_valign(self.valign);
        
        if (self.wrap) {
            var _w = self.x2 - _x;
            draw_text_ext(_x, _y, self.value, self.sep, _w);
        } else {
            draw_text(_x, _y, self.value);
        }
    }
    
    // Set the size of the button
    if (self.autoResize) {
        computeSize();
    }
}
