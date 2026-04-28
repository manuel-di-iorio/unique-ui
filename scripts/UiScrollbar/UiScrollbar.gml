function UiScrollbar(style = {}, props = {}): UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "__UiScrollbar");
    self.dragged = false;
    self.dragStartMouse = undefined;
    self.dragStartScroll = undefined; 
    self.maxScroll = 0;
    self.pointerEvents = true;
    self.__contentHeight = undefined;
    self.__maxThumbPosition = undefined;
    self.__maxScroll = undefined;
    self.thumbColor = props[$ "thumbColor"] ?? global.UI_COL_BOX;
    self.orientation = props[$ "orientation"] ?? "vertical";
    self.isVertical = self.orientation == "vertical";
    
    // Create the thumb
    var thumbStyle = self.isVertical ? 
        { position: "absolute", left: 0, right: 0, top: 0, height: 0 } :
        { position: "absolute", top: 0, bottom: 0, left: 0, width: 0 };
        
    self.Thumb = new UiScrollbarThumb(thumbStyle, {
        isScrollbar: true, 
        thumbColor: self.thumbColor 
    });
    self.add(self.Thumb);
    
    function onMount() {
        if (self.isVertical) {
            self.parent.onWheelUp(function(ev) {
                self.parent.scrollTop = max(0, self.parent.scrollTop - 60);
                global.UI.requestUpdate();
                global.UI.requestRedraw();
            });
            
            self.parent.onWheelDown(function(ev) {
                self.parent.scrollTop = min(self.__maxScroll, self.parent.scrollTop + 60);
                global.UI.requestUpdate();
                global.UI.requestRedraw();
            });
        } else {
            // Horizontal wheel (Shift+Wheel is common but GM doesn't distinguish natively easily, 
            // so we might just use wheel if it's a dedicated horizontal area or just drag)
        }
    }
    
    self.onStep(function(layoutUpdated) {
        var layoutSize = self.isVertical ? self.layout.height : self.layout.width;
        var parentSize = self.isVertical ? self.parent.layout.height : self.parent.layout.width;
        
        if (layoutUpdated) {
            // Content size calculation
            var propName = self.isVertical ? "height" : "width";
            var posName = self.isVertical ? "top" : "left";
            var scrollName = self.isVertical ? "scrollTop" : "scrollLeft";
            var marginName = self.isVertical ? "getMarginBottom" : "getMarginRight";
            var paddingName = self.isVertical ? "getPaddingBottom" : "getPaddingRight";

            self.__contentSize = self.parent.reduceChildren(method({ scrollableParent: self.parent, propName, posName, marginName }, function(maxS, child) {
                if (child.isScrollbar) return maxS;
                var m = child[$ marginName]();
                if (is_undefined(m) || is_nan(m)) m = 0;
                var childEdge = (child.layout[$ posName] + child.layout[$ propName]) - scrollableParent.layout[$ posName] + m;
                return max(maxS, childEdge);
            }), 0, false);
            
            var pPad = self.parent[$ paddingName]();
            if (is_undefined(pPad) || is_nan(pPad)) pPad = 0;
            self.__contentSize += pPad;
           
            var _thumbSize = ~~(max(10, min(layoutSize, layoutSize * (layoutSize / max(1, self.__contentSize)))));
            
            if (self.isVertical) {
                if (_thumbSize != self.Thumb.getHeight()) self.Thumb.setHeight(_thumbSize);
            } else {
                if (_thumbSize != self.Thumb.getWidth()) self.Thumb.setWidth(_thumbSize);
            }
        
            self.__maxThumbPosition = layoutSize - _thumbSize;
            self.__maxScroll = max(0, self.__contentSize - parentSize);

            // Reset if content fits
            if (self.__maxScroll <= 0) {
                self.parent[$ scrollName] = 0;
                var thumbPosName = self.isVertical ? "getTop" : "getLeft";
                var thumbSetPosName = self.isVertical ? "setTop" : "setLeft";
                if (self.Thumb[$ thumbPosName]() != 0) self.Thumb[$ thumbSetPosName](0);
            }
        } 
        
        // Dragging
        if (self.dragged) {
            var mousePos = self.isVertical ? global.UI.mouseY : global.UI.mouseX;
            var delta = mousePos - self.dragStartMouse;
            var scrollName = self.isVertical ? "scrollTop" : "scrollLeft";
            
            if (self.__maxScroll > 0) {
                if (self.__maxThumbPosition > 0) {
                    var scrollDelta = (delta / self.__maxThumbPosition) * self.__maxScroll;
                    self.parent[$ scrollName] = clamp(self.dragStartScroll + scrollDelta, 0, self.__maxScroll);
                    global.UI.requestUpdate();
                    global.UI.requestRedraw();
                }
            }
        }
        
        // Update thumb position
        if (self.__maxScroll > 0) {
            var scrollName = self.isVertical ? "scrollTop" : "scrollLeft";
            var thumbSetPosName = self.isVertical ? "setTop" : "setLeft";
            var thumbPosName = self.isVertical ? "getTop" : "getLeft";
            
            var thumbPosition = floor((self.parent[$ scrollName] / self.__maxScroll) * self.__maxThumbPosition); 
            if (self.Thumb[$ thumbPosName]() != thumbPosition) {
                self.Thumb[$ thumbSetPosName](thumbPosition);
            }
        }
    });
}

function UiScrollbarThumb(style = {}, props = {}): UiNode(style, props) constructor {
    self.pointerEvents = true;
    setName(style[$ "name"] ?? "__UiScrollbar.Thumb");
    self.thumbColor = props[$ "thumbColor"];
    
    self.onMouseDown(function(ev) {
        self.parent.dragged = true;
        self.parent.dragStartMouse = self.parent.isVertical ? global.UI.mouseY : global.UI.mouseX;
        self.parent.dragStartScroll = self.parent.isVertical ? self.parent.parent.scrollTop : self.parent.parent.scrollLeft;
        global.UI.isScrolling = true;
        
        if (self.parent.isVertical) {
            self.setWidth(17);
            self.setLeft(-3);
        } else {
            self.setHeight(17);
            self.setTop(-3);
        }
        return true;
    });
    
    self.onStep(function() {
        if (global.UI.mouseReleased) {
            if (self.parent.dragged) {
                self.parent.dragged = false;
                global.UI.isScrolling = false;
                if (self.parent.isVertical) {
                    self.setWidth(11);
                    self.setLeft(0);
                } else {
                    self.setHeight(11);
                    self.setTop(0);
                }
            }
        }
    });
    
    function onDraw() {
        if (self.parent.__maxScroll <= 0) return;
        
        var layoutSize = self.parent.isVertical ? self.parent.layout.height : self.parent.layout.width;
        draw_set_color(self.thumbColor);
        draw_set_alpha(0.4);
        if (self.parent.isVertical) {
            draw_roundrect_ext(self.x1 + 3, self.y1 + 4, self.x2 - 3, self.y2 - 4, 4, 4, false);
        } else {
            draw_roundrect_ext(self.x1 + 4, self.y1 + 3, self.x2 - 4, self.y2 - 3, 4, 4, false);
        }
        draw_set_alpha(1);
    }
}
