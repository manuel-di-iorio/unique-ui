function UiSlider(style = {}, props = {}) : UiNode(style, props) constructor {
    setName(props[$ "name"] ?? "UiSlider");
    self.value = props[$ "value"] ?? 0;
    self.minValue = props[$ "min"] ?? 0;
    self.maxValue = props[$ "max"] ?? 100;
    self.onChange = props[$ "onChange"] ?? function(value, input) {};
    self.valueGetter = props[$ "valueGetter"] ?? undefined;
    self.step = props[$ "step"] ?? 1;
    
    self.pointerEvents = true;
    self.handpoint = true;
    
    // For smooth drawing
    self.animValue = self.value;
    
    self.onMouseEnter(function() { global.UI.requestRedraw(); });
    self.onMouseLeave(function() { global.UI.requestRedraw(); });
    
    self.onDraw = function() {
        self.animValue += (self.value - self.animValue) * 0.3;
        if (abs(self.animValue - self.value) > 0.01) global.UI.requestRedraw();
        
        var cy = ~~mean(self.y1, self.y2);
        var trackH = 4;
        
        // Background track
        draw_set_color(global.UI_COL_BOX);
        draw_roundrect_ext(self.x1, cy - trackH/2, self.x2, cy + trackH/2, trackH/2, trackH/2, false);
        
        // Fill track
        var t = clamp((self.animValue - self.minValue) / (self.maxValue - self.minValue), 0, 1);
        var fillX = lerp(self.x1, self.x2, t);
        
        if (fillX > self.x1) {
            draw_set_color(global.UI_COL_SELECTED);
            draw_roundrect_ext(self.x1, cy - trackH/2, fillX, cy + trackH/2, trackH/2, trackH/2, false);
        }
        
        // Thumb
        var thumbR = 8;
        if (self.hovered || self.dragging) thumbR = 10;
        
        draw_set_color(c_white);
        draw_circle(fillX, cy, thumbR, false);
        
        // Hover ring
        if (self.hovered || self.dragging) {
            draw_set_color(global.UI_COL_SELECTED);
            draw_set_alpha(0.2);
            draw_circle(fillX, cy, thumbR + 4, false);
            draw_set_alpha(1.0);
        }
    };
    
    self.onStep(function() {
        if (self.valueGetter != undefined && !self.dragging) {
            self.value = self.valueGetter();
        }
    });
    
    function updateValueFromMouse() {
        var mx = window_mouse_get_x();
        var t = clamp((mx - self.x1) / (self.x2 - self.x1), 0, 1);
        var rawVal = lerp(self.minValue, self.maxValue, t);
        
        if (self.step > 0) {
            rawVal = round(rawVal / self.step) * self.step;
        }
        rawVal = clamp(rawVal, self.minValue, self.maxValue);
        
        if (self.value != rawVal) {
            self.value = rawVal;
            self.onChange(self.value, self);
            global.UI.requestRedraw();
        }
    }
    
    self.onMouseDown(function() {
        self.dragging = true;
        updateValueFromMouse();
        return true;
    });
    
    self.onStep(function() {
        if (self.dragging) {
            if (!mouse_check_button(mb_left)) {
                self.dragging = false;
                global.UI.requestRedraw();
            } else {
                updateValueFromMouse();
            }
        }
    });
}
