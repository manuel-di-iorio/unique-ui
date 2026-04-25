function UiCheckbox(style = {}, props = {}) : UiNode(style, props) constructor {
    setName(props[$ "name"] ?? "UiCheckbox");
    self.value = props[$ "value"] ?? false;
    self.label = props[$ "label"] ?? undefined;
    self.onChange = props[$ "onChange"] ?? function(value, input) {};
    self.valueGetter = props[$ "valueGetter"] ?? undefined;
    
    var _marginLeft = self.label == undefined ? 0 : 3 + string_width(self.label) + 20;
    
    self.Input = new UiNode({
        name: "UiCheckbox.Input", 
        marginLeft: _marginLeft,
        width: 18,
        height: 18
    });
    self.add(self.Input);
    
    with (self.Input) {
        self.pointerEvents = true;
        self.handpoint = true;
        
        self.onMouseEnter(function() {
            global.UI.requestRedraw();
        });
        
        self.onMouseLeave(function() {
            global.UI.requestRedraw();
        });
        
        self.onDraw = function() {
            var radius = 4;
            // Checkbox background
            draw_set_color(self.parent.value ? global.UI_COL_PRIMARY : global.UI_COL_INPUT_BG);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
            
            // Checkbox border
            draw_set_color(self.parent.value ? global.UI_COL_PRIMARY : global.UI_COL_BORDER);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, true);
            
            if (self.hovered && !self.parent.value) {
                draw_set_color(global.UI_COL_BTN_HOVER);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
                draw_set_color(global.UI_COL_PRIMARY);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, true);
            }
            
            if (self.parent.value) {
                // Fallback checkmark (cleaner)
                draw_set_color(c_white);
                var cx = ~~mean(self.x1, self.x2);
                var cy = ~~mean(self.y1, self.y2);
                draw_line_width(cx - 4, cy, cx - 1, cy + 3, 2);
                draw_line_width(cx - 1, cy + 3, cx + 5, cy - 4, 2);
            }
        };
    }
    
    // Update value from external source
    self.onStep(function() {
        if (self.valueGetter != undefined) self.value = self.valueGetter();
    });
    
    self.onClick(function() {
        self.value = !self.value;
        self.onChange(self.value, self);
        global.UI.requestRedraw();
        return true;
    });
    
    // Draw label if present
    function onDraw() {
        if (self.label != undefined) {
            draw_set_color(global.UI_COL_TEXT_MAIN); draw_set_halign(fa_left); draw_set_valign(fa_middle);
            draw_text(self.x1 + 3, ~~mean(self.y1, self.y2), self.label);
        }
    }
}