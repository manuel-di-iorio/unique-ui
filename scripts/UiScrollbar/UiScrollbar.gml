function UiScrollbar(style = {}, props = {}): UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "__UiScrollbar");
    self.dragged = false;
    self.dragStartMouse = undefined;
    self.dragStartScroll = undefined; 
    self.maxScroll = 0;
    self.pointerEvents = true;
    self.__contentHeight = 0;
    self.__maxThumbPosition = 0;
    self.__maxScroll = 0;
    self.thumbColor = props[$ "thumbColor"] ?? global.UI_COL_SCROLLBAR;
    self.orientation = props[$ "orientation"] ?? "vertical";
    self.isVertical = self.orientation == "vertical";
    
    // Cache orientation-dependent property names (never change after construction)
    self.__propName = self.isVertical ? "height" : "width";
    self.__posName = self.isVertical ? "top" : "left";
    self.__marginName = self.isVertical ? "getMarginBottom" : "getMarginRight";
    self.__paddingName = self.isVertical ? "getPaddingBottom" : "getPaddingRight";
    self.__scrollName = self.isVertical ? "scrollTop" : "scrollLeft";
    self.__thumbPosName = self.isVertical ? "getTop" : "getLeft";
    self.__thumbSetPosName = self.isVertical ? "setTop" : "setLeft";
    
    // Pre-create the reduce callback to avoid method struct allocation every step
    self.__reduceCb = method(self, function(maxS, child) {
        if (child.isScrollbar) return maxS;
        var m = child[$ self.__marginName]();
        if (is_undefined(m) || is_nan(m)) m = 0;
        var childEdge = (child.layout[$ self.__posName] + child.layout[$ self.__propName]) - self.parent.layout[$ self.__posName] + m;
        return max(maxS, childEdge);
    });
    
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
            self.parent.onWheelUp(method(self, function(ev) {
                if (self.parent == undefined) return;
                var _prevTop = self.parent.scrollTop;
                var _prevLeft = self.parent.scrollLeft;
                
                // Shift + wheel => horizontal scrolling when available
                if (keyboard_check(vk_shift) && self.parent.__UiScrollbarH != undefined) {
                    var hScrollbar = self.parent.__UiScrollbarH;
                    self.parent.scrollLeft = max(0, self.parent.scrollLeft - 60);
                    if (self.parent.scrollLeft > hScrollbar.__maxScroll) self.parent.scrollLeft = hScrollbar.__maxScroll;
                } else {
                    self.parent.scrollTop = max(0, self.parent.scrollTop - 60);
                }

                if (self.parent.scrollTop != _prevTop || self.parent.scrollLeft != _prevLeft) {
                    global.UI.requestUpdate();
                    global.UI.requestRedraw();
                    return true;
                }
                
                // Nothing moved: allow event bubbling to parent scroll containers.
                return false;
            }));
            
            self.parent.onWheelDown(method(self, function(ev) {
                if (self.parent == undefined) return;
                var _prevTop = self.parent.scrollTop;
                var _prevLeft = self.parent.scrollLeft;
                
                // Shift + wheel => horizontal scrolling when available
                if (keyboard_check(vk_shift) && self.parent.__UiScrollbarH != undefined) {
                    var hScrollbar = self.parent.__UiScrollbarH;
                    self.parent.scrollLeft = min(hScrollbar.__maxScroll, self.parent.scrollLeft + 60);
                } else {
                    self.parent.scrollTop = min(self.__maxScroll, self.parent.scrollTop + 60);
                }

                if (self.parent.scrollTop != _prevTop || self.parent.scrollLeft != _prevLeft) {
                    global.UI.requestUpdate();
                    global.UI.requestRedraw();
                    return true;
                }

                // Nothing moved: allow event bubbling to parent scroll containers.
                return false;
            }));
        } else {
            // Horizontal wheel
        }
    }
    
    self.__contentSize = 0;

    self.onStep(function(layoutUpdated) {
        if (self.parent == undefined) return;
        
        var layoutSize = self.isVertical ? self.layout.height : self.layout.width;
        var parentSize = self.isVertical ? self.parent.layout.height : self.parent.layout.width;
        
        // Always recalculate content size: wrapped text (UiText with wrap:true)
        // adjusts its height one frame after layout, so a single layoutUpdated check
        // would miss deferred size changes.
        var _newContentSize = self.parent.reduceChildren(self.__reduceCb, 0, false);
        
        var pPad = self.parent[$ self.__paddingName]();
        if (is_undefined(pPad) || is_nan(pPad)) pPad = 0;
        _newContentSize += pPad;
        
        if (_newContentSize != self.__contentSize || layoutUpdated) {
            self.__contentSize = _newContentSize;
        
            var _thumbSize = ~~(max(10, min(layoutSize, layoutSize * (layoutSize / max(1, self.__contentSize)))));
            
            if (self.isVertical) {
                if (_thumbSize != self.Thumb.getHeight()) self.Thumb.setHeight(_thumbSize);
            } else {
                if (_thumbSize != self.Thumb.getWidth()) self.Thumb.setWidth(_thumbSize);
            }
        
            self.__maxThumbPosition = layoutSize - _thumbSize;
            self.__maxScroll = max(0, self.__contentSize - parentSize);

            if (self.__maxScroll <= 0) {
                self.parent[$ self.__scrollName] = 0;
                if (self.Thumb[$ self.__thumbPosName]() != 0) self.Thumb[$ self.__thumbSetPosName](0);
            }
            
            global.UI.requestRedraw();
        }
        
        // Dragging
        if (self.dragged) {
            var mousePos = self.isVertical ? global.UI.mouseY : global.UI.mouseX;
            var delta = mousePos - self.dragStartMouse;
            
            if (self.__maxScroll > 0 && self.__maxThumbPosition > 0) {
                var scrollDelta = (delta / self.__maxThumbPosition) * self.__maxScroll;
                self.parent[$ self.__scrollName] = clamp(self.dragStartScroll + scrollDelta, 0, self.__maxScroll);
                global.UI.requestUpdate();
                global.UI.requestRedraw();
            }
        }
        
        // Update thumb position
        if (self.__maxScroll > 0) {
            var thumbPosition = floor((self.parent[$ self.__scrollName] / self.__maxScroll) * self.__maxThumbPosition); 
            if (self.Thumb[$ self.__thumbPosName]() != thumbPosition) {
                self.Thumb[$ self.__thumbSetPosName](thumbPosition);
            }
        }
        
        // Ensure scroll is within bounds (e.g. after items destroyed)
        if (self.parent[$ self.__scrollName] > self.__maxScroll) {
            self.parent[$ self.__scrollName] = self.__maxScroll;
            global.UI.requestUpdate();
        }
    });
}

function UiScrollbarThumb(style = {}, props = {}): UiNode(style, props) constructor {
    self.pointerEvents = true;
    setName(style[$ "name"] ?? "__UiScrollbar.Thumb");
    self.thumbColor = props[$ "thumbColor"];
    
    self.onMouseDown(method(self, function(ev) {
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
    }));
    
    self.onStep(method(self, function() {
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
    }));
    
    function onDraw() {
        if (self.parent.__maxScroll <= 0) return;
        
        var layoutSize = self.parent.isVertical ? self.parent.layout.height : self.parent.layout.width;
        var col = (typeof(self.thumbColor) == "method") ? self.thumbColor() : self.thumbColor;
        draw_set_color(col);
        draw_set_alpha(0.4);
        if (self.parent.isVertical) {
            draw_roundrect_ext(self.x1 + 3, self.y1 + 4, self.x2 - 3, self.y2 - 4, 4, 4, false);
        } else {
            draw_roundrect_ext(self.x1 + 4, self.y1 + 3, self.x2 - 4, self.y2 - 3, 4, 4, false);
        }
        draw_set_alpha(1);
    }
}
