function UiSwitch(style = {}, props = {}) : UiNode(style, props) constructor {
    setName(props[$ "name"] ?? "UiSwitch");
    self.value = props[$ "value"] ?? false;
    self.label = props[$ "label"] ?? undefined;
    self.onChange = props[$ "onChange"] ?? function(value, input) {};
    self.valueGetter = props[$ "valueGetter"] ?? undefined;
    
    var _marginLeft = self.label == undefined ? 0 : 6 + string_width(self.label);
    
    self.Input = new UiNode({
        name: "UiSwitch.Input", 
        marginLeft: _marginLeft,
        width: 36,
        height: 20
    });
    self.add(self.Input);
    
    // Animation state
    self.animThumbPos = self.value ? 1 : 0;
    
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
            var p = self.parent;
            // Smooth animate
            var targetPos = p.value ? 1 : 0;
            p.animThumbPos += (targetPos - p.animThumbPos) * 0.3;
            if (abs(p.animThumbPos - targetPos) > 0.01) {
                global.UI.requestRedraw();
            }
            
            var r = (self.y2 - self.y1) / 2;
            
            // Track background
            var trackColor = merge_color(global.UI_COL_BOX, global.UI_COL_SELECTED, p.animThumbPos);
            if (self.hovered && !p.value) trackColor = global.UI_COL_BTN_HOVER;
            
            draw_set_color(trackColor);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, r, r, false);
            
            // Thumb
            var thumbR = r - 2;
            var thumbStartX = self.x1 + r;
            var thumbEndX = self.x2 - r;
            var thumbX = lerp(thumbStartX, thumbEndX, p.animThumbPos);
            var thumbY = ~~mean(self.y1, self.y2);
            
            draw_set_color(c_white);
            draw_circle(thumbX, thumbY, thumbR, false);
        };
    }
    
    self.onStep(function() {
        if (self.valueGetter != undefined) self.value = self.valueGetter();
    });
    
    self.onClick(function() {
        self.value = !self.value;
        self.onChange(self.value, self);
        global.UI.requestRedraw();
        return true;
    });
    
    function onDraw() {
        if (self.label != undefined) {
            draw_set_color(c_white); draw_set_halign(fa_left); draw_set_valign(fa_middle);
            draw_text(self.x1, ~~mean(self.y1, self.y2), self.label);
        }
    }
}
