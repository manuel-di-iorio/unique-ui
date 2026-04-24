function UiButton(textOrImage, style = {}, props = {}): UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "UiButton");
    self.text = undefined;
    self.sprite = undefined;
    self.label = props[$ "label"]; // Text label to show alongside sprite
    self.autoResize = props[$ "autoResize"] ?? (style[$ "width"] == undefined && style[$ "height"] == undefined) ?? true;
    self.outline = props[$ "outline"] ?? false;
    self.pointerEvents = true;
    self.halign = props[$ "halign"] ?? fa_center;
    self.handpoint = true;
    self.selected = false;
    self.enableRipple = props[$ "enableRipple"] ?? true;
    self.variant = props[$ "variant"] ?? "secondary";
    
    self.onMouseEnter(function() {
        global.UI.requestRedraw();
    });
    
    self.onMouseLeave(function() {
        global.UI.requestRedraw();
    });
    
    self.ripples = [];
    
    self.onClick(function() {
        if (!self.enableRipple) return;
        
        var mx = window_mouse_get_x();
        var my = window_mouse_get_y();
        
        var w = self.x2 - self.x1;
        var h = self.y2 - self.y1;
        var maxR = sqrt(w*w + h*h) * 1.2;
        
        array_push(self.ripples, {
            x: mx,
            y: my,
            radius: 0,
            alpha: 0.4,
            maxRadius: maxR
        });
        global.UI.requestRedraw();
    });
    
    function resize() {
        var _w, _h;
        if (self.text != undefined) {
            draw_set_font(fText)
            _w = string_width(self.text) + 10;
            _h = string_height(self.text) + 5;
        } else if (self.sprite != undefined && self.label != undefined) {
            // Sprite + label
            draw_set_font(fText);
            _w = sprite_get_width(self.sprite) + string_width(self.label) + 20;
            _h = max(sprite_get_height(self.sprite), string_height(self.label)) + 10;
        } else if (self.sprite != undefined) {
            _w = sprite_get_width(self.sprite);
            _h = sprite_get_height(self.sprite);
        } else {
            _w = 32;
            _h = 32;
        }
        setSize(_w, _h);
    }
    
    function setText(text) {
        self.text = text;
        self.resize();
    }
    
    function setSprite(sprite) {
        self.sprite = sprite;
        self.resize();
    }
    
    function onDraw() {
        var radius = 6;
        
        var bg_color = global.UI_COL_BOX;
        var hover_color = global.UI_COL_BTN_HOVER;
        
        if (self.variant == "primary") {
            bg_color = global.UI_COL_SELECTED;
            hover_color = global.UI_COL_SELECTED_HOVER;
        }
        
        // Background
        if (self.selected && self.hovered) {
            draw_set_color(hover_color);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
        } else if (self.selected) {
            draw_set_color(bg_color);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
        }
        else if (self.hovered) {
            draw_set_color(hover_color);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
        } else if (!self.outline) {
            draw_set_color(bg_color);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
        }
        
        // Ripples
        if (array_length(self.ripples) > 0) {
            var _scissor = gpu_get_scissor();
            gpu_set_scissor(self.x1, self.y1, self.x2 - self.x1, self.y2 - self.y1);
            
            for (var i = array_length(self.ripples) - 1; i >= 0; i--) {
                var r = self.ripples[i];
                r.radius += 3;
                r.alpha -= 0.015;
                
                draw_set_alpha(r.alpha);
                draw_set_color(c_white);
                draw_circle(r.x, r.y, r.radius, false);
                
                if (r.alpha <= 0) {
                    array_delete(self.ripples, i, 1);
                }
            }
            
            gpu_set_scissor(_scissor);
            draw_set_alpha(1);
            
            if (array_length(self.ripples) > 0) {
                global.UI.requestRedraw();
            }
        }
        
        // Border / Outline
        if (self.outline) {
            draw_set_color(global.UI_COL_BORDER);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, true);
        } else {
            // Subtle top highlight for depth
            draw_set_color(c_white);
            draw_set_alpha(0.04);
            draw_line(self.x1 + radius, self.y1, self.x2 - radius, self.y1);
            draw_set_alpha(1);
            
            // Outer subtle border
            draw_set_color(#101014);
            draw_set_alpha(0.3);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, true);
            draw_set_alpha(1);
        }

        var xm;
        switch (self.halign) {
            case fa_left: xm = self.x1 + self.layout.paddingLeft; break;
            case fa_center: xm = ~~mean(self.x1, self.x2); break;
            case fa_right: xm = self.x2 - self.layout.paddingRight; break;
        } 
        
        var ym = ~~mean(self.y1, self.y2);
        
        if (self.text != undefined) {
            // Draw text only
            draw_set_font(fText); draw_set_color(c_white); draw_set_halign(self.halign); draw_set_valign(fa_middle);
            draw_text(xm, ym, self.text);
        } else if (self.sprite != undefined && self.label != undefined) {
            // Draw sprite + label
            var spriteWidth = sprite_get_width(self.sprite);
            var totalWidth = spriteWidth + string_width(self.label) + 8;
            var startX = self.x1 + (self.x2 - self.x1 - totalWidth) / 2;
            
            draw_sprite(self.sprite, self.hovered ? 1 : 0, startX + spriteWidth / 2, ym);
            
            draw_set_font(fText); draw_set_color(c_white); draw_set_halign(fa_left); draw_set_valign(fa_middle);
            draw_text(startX + spriteWidth + 8, ym, self.label);
        } else if (self.sprite) {
            // Draw sprite only
            draw_sprite(self.sprite, self.hovered ? 1 : 0, xm, ym);
        }
    }
    
    // Set the text/sprite and resize the button if specified
    if (textOrImage != undefined) {
        if (is_string(textOrImage)) {
            self.text = textOrImage;
        } else {
            self.sprite = textOrImage;
        }
        
        if (autoResize) self.resize();
    }
}
