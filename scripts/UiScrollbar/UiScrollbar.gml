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
    self.minThumbSize = props[$ "minThumbSize"] ?? 30;
    self.orientation = props[$ "orientation"] ?? "vertical";
    self.isVertical = self.orientation == "vertical";
    
    // Cache orientation-dependent property names (never change after construction)
    self.__propName = self.isVertical ? "height" : "width";
    self.__posName = self.isVertical ? "top" : "left";

    // Track background drawn behind the thumb
    self.onDraw = method(self, function() {
        if (self.__maxScroll <= 0) return;
        var col = (typeof(self.thumbColor) == "method") ? self.thumbColor() : self.thumbColor;
        draw_set_color(col);
        draw_set_alpha(0.12);
        if (self.isVertical) {
            draw_roundrect_ext(self.x1 + 3, self.y1 + 2, self.x2 - 3, self.y2 - 2, 4, 4, false);
        } else {
            draw_roundrect_ext(self.x1 + 2, self.y1 + 3, self.x2 - 2, self.y2 - 3, 4, 4, false);
        }
        draw_set_alpha(1);
    });
    self.__marginName = self.isVertical ? "getMarginBottom" : "getMarginRight";
    self.__paddingName = self.isVertical ? "getPaddingBottom" : "getPaddingRight";
    self.__scrollName = self.isVertical ? "scrollTop" : "scrollLeft";
    self.__thumbPosName = self.isVertical ? "getTop" : "getLeft";
    self.__thumbSetPosName = self.isVertical ? "setTop" : "setLeft";
    
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
            self.parent.onWheelUp(method(self, function(ev) {
                if (self.parent == undefined) return;
                var _prevTop = self.parent.scrollTop;
                var _prevLeft = self.parent.scrollLeft;

                if (!keyboard_check(vk_shift) || self.parent.__UiScrollbar == undefined) {
                    self.parent.scrollLeft = max(0, self.parent.scrollLeft - 60);
                    if (self.parent.scrollLeft > self.__maxScroll) self.parent.scrollLeft = self.__maxScroll;
                }

                if (self.parent.scrollTop != _prevTop || self.parent.scrollLeft != _prevLeft) {
                    global.UI.requestUpdate();
                    global.UI.requestRedraw();
                    return true;
                }
                return false;
            }));

            self.parent.onWheelDown(method(self, function(ev) {
                if (self.parent == undefined) return;
                var _prevTop = self.parent.scrollTop;
                var _prevLeft = self.parent.scrollLeft;

                if (!keyboard_check(vk_shift) || self.parent.__UiScrollbar == undefined) {
                    self.parent.scrollLeft = min(self.__maxScroll, self.parent.scrollLeft + 60);
                }

                if (self.parent.scrollTop != _prevTop || self.parent.scrollLeft != _prevLeft) {
                    global.UI.requestUpdate();
                    global.UI.requestRedraw();
                    return true;
                }
                return false;
            }));
        }
    }
    
    self.__contentSize = 0;
    self.__layoutFrames = 2; // Recalculate for 2 frames after layout (catches deferred text wrap)

    self.onStep(function(layoutUpdated) {
        if (self.parent == undefined) return;
        
        var layoutSize = self.isVertical ? self.layout.height : self.layout.width;
        var parentSize = self.isVertical ? self.parent.layout.height : self.parent.layout.width;
        
        // Reactive content size calculation:
        // layoutUpdated tracks layout recalculations (add/remove/child resize).
        // Wrapped text (UiText with wrap:true) adjusts its height one frame after layout,
        // so we keep recalculating for 2 frames after the last layout update to catch that.
        self.__layoutFrames = layoutUpdated ? 2 : max(0, self.__layoutFrames - 1);
        
        if (self.__layoutFrames > 0) {
            var _newContentSize = 0;
            
            // Virtualised parents expose getContentSize() - O(1) instead of O(N).
            if (variable_struct_exists(self.parent, "getContentSize") && self.parent.getContentSize != undefined) {
                _newContentSize = self.parent.getContentSize();
            } else {
                // Inline loop avoids function-call-per-child overhead of reduceChildren
                var _pLayout = self.parent.layout;
                var _children = self.parent.children;
                var _len = self.parent.childrenLength;
                for (var i = 0; i < _len; i++) {
                    var _child = _children[i];
                    if (_child.isScrollbar) continue;
                    var m = _child[$ self.__marginName]();
                    if (is_undefined(m) || is_nan(m)) m = 0;
                    var childEdge = (_child.layout[$ self.__posName] + _child.layout[$ self.__propName]) - _pLayout[$ self.__posName] + m;
                    if (childEdge > _newContentSize) _newContentSize = childEdge;
                }
            }
            
            var pPad = self.parent[$ self.__paddingName]();
            if (is_undefined(pPad) || is_nan(pPad)) pPad = 0;
            _newContentSize += pPad;
            
            if (_newContentSize != self.__contentSize || layoutUpdated) {
                self.__contentSize = _newContentSize;
            
                var _thumbSize = ~~(max(self.minThumbSize, min(layoutSize, layoutSize * (layoutSize / max(1, self.__contentSize)))));
                
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
        var col = (typeof(self.thumbColor) == "method") ? self.thumbColor() : self.thumbColor;
        
        // Thumb fill
        draw_set_color(col);
        draw_set_alpha(0.5);
        if (self.parent.isVertical) {
            draw_roundrect_ext(self.x1 + 3, self.y1 + 1, self.x2 - 3, self.y2 - 1, 4, 4, false);
        } else {
            draw_roundrect_ext(self.x1 + 1, self.y1 + 3, self.x2 - 1, self.y2 - 3, 4, 4, false);
        }
        draw_set_alpha(1);
    }
}
