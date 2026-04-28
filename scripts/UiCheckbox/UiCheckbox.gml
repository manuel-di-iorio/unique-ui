function UiCheckbox(style = {}, props = {}) : UiNode(style, props) constructor {
    self.flexDirection = "row";
    flexpanel_node_style_set_flex_direction(self.node, flexpanel_flex_direction.row);
    self.alignItems = "center";
    
    setName(props[$ "name"] ?? "UiCheckbox");
    self.value = props[$ "value"] ?? false;
    self.label = props[$ "label"] ?? undefined;
    self.onChange = props[$ "onChange"] ?? function(value, input) {};
    self.valueGetter = props[$ "valueGetter"] ?? undefined;
    self.variant = props[$ "variant"] ?? "checkbox";
    self.group = props[$ "group"];
    
    self.pointerEvents = true;
    self.handpoint = true;
    
    // Input node first (the visual box/circle)
    self.Input = new UiNode({
        name: "UiCheckbox.Input", 
        width: 18,
        height: 18,
        marginRight: 10
    });
    self.add(self.Input);
    
    // Label node second
    if (self.label != undefined) {
        self.Label = new UiText(self.label, {}, { color: global.UI_COL_TEXT_MAIN });
        self.add(self.Label);
    }
    
    with (self.Input) {
        self.onDraw = function() {
            var radius = (self.parent.variant == "radio") ? 9 : 4;
            var isChecked = self.parent.value;
            
            // Background
            draw_set_color(isChecked ? global.UI_COL_PRIMARY : global.UI_COL_INPUT_BG);
            if (self.parent.variant == "radio") {
                draw_circle(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), 9, false);
            } else {
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
            }
            
            // Border
            draw_set_color(isChecked ? global.UI_COL_PRIMARY : global.UI_COL_BORDER);
            if (self.parent.variant == "radio") {
                draw_circle(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), 9, true);
            } else {
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, true);
            }
            
            if (self.parent.hovered && !isChecked) {
                draw_set_color(global.UI_COL_BTN_HOVER);
                if (self.parent.variant == "radio") {
                    draw_circle(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), 9, false);
                } else {
                    draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
                }
            }
            
            if (isChecked) {
                draw_set_color(c_white);
                var cx = ~~mean(self.x1, self.x2);
                var cy = ~~mean(self.y1, self.y2);
                if (self.parent.variant == "radio") {
                    draw_circle(cx, cy, 4, false);
                } else {
                    draw_line_width(cx - 4, cy, cx - 1, cy + 3, 2);
                    draw_line_width(cx - 1, cy + 3, cx + 5, cy - 4, 2);
                }
            }
        };
    }
    
    self.onStep(function() {
        if (self.valueGetter != undefined) self.value = self.valueGetter();
    });
    
    self.onClick(function() {
        if (self.variant == "radio" && self.value) return true; 
        
        self.value = !self.value;
        
        // Radio group logic
        if (self.variant == "radio" && self.value && self.parent != undefined) {
            var myGroup = self.group;
            if (myGroup != undefined) {
                var siblings = self.parent.children;
                for (var i = 0; i < array_length(siblings); i++) {
                    var s = siblings[i];
                    if (s != self && s[$ "variant"] == "radio" && s[$ "group"] == myGroup) {
                        s.value = false;
                        if (s[$ "onChange"] != undefined) s.onChange(false, s);
                    }
                }
            }
        }
        
        self.onChange(self.value, self);
        global.UI.requestRedraw();
        return true;
    });
}