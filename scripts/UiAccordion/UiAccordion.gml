function UiAccordion(text, style = {}, data = {}) : UiNode(style, data) constructor {
    self.text = text;
    self.collapsed = data[$ "collapsed"] ?? false;
    
    // Default style adjustments
    if (style[$ "width"] == undefined) self.setWidth("100%");
    flexpanel_node_style_set_flex_direction(self.node, flexpanel_flex_direction.column);
    
    // Main Container Styling
    self.onDraw = method(self, function() {
        var borderCol = #E2E8F0;
        // Draw main border around the whole component
        draw_set_color(c_white);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, false);
        draw_set_color(borderCol);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 12, 12, true);
    });
    
    // Create Header
    self.Header = new UiNode({ 
        width: "100%",
        flexDirection: "row", 
        alignItems: "center",
        paddingHorizontal: 16,
        height: 48,
    }, { pointerEvents: true });
    
    self.Header.onDraw = method(self.Header, function() {
        var hoverCol = #F8FAFC;
        var borderCol = #E2E8F0;
        
        // Background on hover
        if (self.hovered) {
            draw_set_color(hoverCol);
            draw_roundrect_ext(self.x1 + 1, self.y1 + 1, self.x2 - 1, self.y2 - 1, 11, 11, false);
        }
        
        // Separator line when expanded
        if (!self.parent.collapsed) {
            draw_set_color(borderCol);
            draw_line(self.x1, self.y2, self.x2, self.y2);
        }
    });
    
    // Arrow (Chevron)
    self.Arrow = new UiNode({ width: 16, height: 16, marginRight: 12 });
    self.Arrow.onDraw = method(self.Arrow, function() {
        var cx = floor(self.x1 + self.width/2);
        var cy = floor(self.y1 + self.height/2);
        var size = 3;
        
        draw_set_color(#64748B);
        if (self.parent.parent.collapsed) {
            // Right Chevron (thinner, more elegant)
            draw_line_width(cx - size/2, cy - size, cx + size/2, cy, 1.5);
            draw_line_width(cx + size/2, cy, cx - size/2, cy + size, 1.5);
        } else {
            // Down Chevron
            draw_line_width(cx - size, cy - size/2, cx, cy + size/2, 1.5);
            draw_line_width(cx, cy + size/2, cx + size, cy - size/2, 1.5);
        }
    });
    
    // Label
    self.Label = new UiText(self.text, { height: 20 }, { 
        color: #0F172A,
        font: fText
    });
    
    self.Header.add(self.Arrow, self.Label);
    
    // Content Container
    self.Content = new UiNode({
        width: "100%",
        flexDirection: "column",
        display: self.collapsed ? "none" : "flex",
        paddingHorizontal: 16,
        paddingTop: 12,
        paddingBottom: 16,
    });
    
    // Add internal nodes
    self.add_base = self.add;
    self.add_base(self.Header, self.Content);
    
    /** Methods */
    
    self.collapse = function() {
        self.collapsed = true;
        self.Content.hide();
        global.UI.requestUpdate();
        return self;
    }
    
    self.expand = function() {
        self.collapsed = false;
        self.Content.show();
        global.UI.requestUpdate();
        return self;
    }
    
    // Override add to put children into Content
    self.add = function() {
        for (var i=0; i<argument_count; i++) {
            self.Content.add(argument[i]);
        }
        return self;
    }
    
    // Toggle Logic
    self.Header.onClick(method(self, function() {
        if (self.collapsed) {
            self.expand();
        } else {
            self.collapse();
        }
    }));
}
