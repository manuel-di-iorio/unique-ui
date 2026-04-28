function UiSwitch(style = {}, props = {}) : UiNode(style, props) constructor {
    setName(props[$ "name"] ?? "UiSwitch");
    self.value = props[$ "value"] ?? false;
    self.label = props[$ "label"] ?? undefined;
    self.onChange = props[$ "onChange"] ?? function(value, input) {};
    self.valueGetter = props[$ "valueGetter"] ?? undefined;
    
    // Setup container
    self.flexDirection = "row";
    self.alignItems = "center";
    self.pointerEvents = true;
    self.handpoint = true;
    
    // Label node
    if (self.label != undefined) {
        self.Label = new UiText(self.label, { marginRight: 12 }, { color: global.UI_COL_TEXT_MAIN });
        self.add(self.Label);
    }
    
    // Input node (the visual track)
    self.Input = new UiNode({
        name: "UiSwitch.Input", 
        width: 36,
        height: 20
    });
    self.add(self.Input);
    
    // Animation state
    self.animThumbPos = self.value ? 1 : 0;
    
    with (self.Input) {
        self.onDraw = function() {
            var p = self.parent;
            var targetPos = p.value ? 1 : 0;
            p.animThumbPos += (targetPos - p.animThumbPos) * 0.3;
            if (abs(p.animThumbPos - targetPos) > 0.01) global.UI.requestRedraw();
            
            var h = (self.y2 - self.y1);
            var r = h / 2;
            
            // Track
            var trackColor = merge_color(#E2E8F0, global.UI_COL_PRIMARY, p.animThumbPos);
            if (p.hovered && !p.value) trackColor = #CBD5E1;
            
            draw_set_color(trackColor);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, r, r, false);
            
            // Thumb
            var thumbR = r - 3;
            var thumbX = lerp(self.x1 + r, self.x2 - r, p.animThumbPos);
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
}

