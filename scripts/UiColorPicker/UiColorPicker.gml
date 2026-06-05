/// @description Color picker with popup panel, HSV selector and hex input.

function __uui_byte_to_hex(_n) {
    _n = clamp(floor(_n), 0, 255);
    var _digits = "0123456789ABCDEF";
    return string_char_at(_digits, floor(_n / 16) + 1) + string_char_at(_digits, (_n mod 16) + 1);
}

function __uui_color_to_hex(_col) {
    return "#" + __uui_byte_to_hex(color_get_red(_col))
        + __uui_byte_to_hex(color_get_green(_col))
        + __uui_byte_to_hex(color_get_blue(_col));
}

function __uui_hex_pair_to_byte(_pair) {
    var _digits = "0123456789ABCDEF";
    var _hi = string_pos(string_char_at(_pair, 1), _digits) - 1;
    var _lo = string_pos(string_char_at(_pair, 2), _digits) - 1;
    if (_hi < 0 || _lo < 0) return -1;
    return _hi * 16 + _lo;
}

function __uui_hex_to_color(_hex) {
    var _s = string_upper(string_replace_all(string(_hex), "#", ""));
    var _len = string_length(_s);
    if (_len == 3) {
        _s = string_char_at(_s, 1) + string_char_at(_s, 1)
            + string_char_at(_s, 2) + string_char_at(_s, 2)
            + string_char_at(_s, 3) + string_char_at(_s, 3);
        _len = 6;
    }
    if (_len != 6) return undefined;
    var _r = __uui_hex_pair_to_byte(string_copy(_s, 1, 2));
    var _g = __uui_hex_pair_to_byte(string_copy(_s, 3, 2));
    var _b = __uui_hex_pair_to_byte(string_copy(_s, 5, 2));
    if (_r < 0 || _g < 0 || _b < 0) return undefined;
    return make_color_rgb(_r, _g, _b);
}

function __uui_hsv_to_rgb(_h, _s, _v) {
    if (_s <= 0) {
        var _g = _v * 255;
        return make_color_rgb(_g, _g, _g);
    }
    var _i = floor(_h * 6);
    var _f = _h * 6 - _i;
    var _p = _v * (1 - _s);
    var _q = _v * (1 - _f * _s);
    var _t = _v * (1 - (1 - _f) * _s);
    var _r = 0; var _g = 0; var _b = 0;
    switch (_i mod 6) {
        case 0: _r = _v; _g = _t; _b = _p; break;
        case 1: _r = _q; _g = _v; _b = _p; break;
        case 2: _r = _p; _g = _v; _b = _t; break;
        case 3: _r = _p; _g = _q; _b = _v; break;
        case 4: _r = _t; _g = _p; _b = _v; break;
        default: _r = _v; _g = _p; _b = _q; break;
    }
    return make_color_rgb(_r * 255, _g * 255, _b * 255);
}

function __uui_rgb_to_hsv(_col) {
    var _r = color_get_red(_col) / 255;
    var _g = color_get_green(_col) / 255;
    var _b = color_get_blue(_col) / 255;
    var _max = max(max(_r, _g), _b);
    var _min = min(min(_r, _g), _b);
    var _d = _max - _min;
    var _h = 0;
    var _s = 0;
    var _v = _max;
    if (_d > 0.0001) {
        _s = _d / _max;
        if (_max == _r) {
            _h = (_g - _b) / _d;
        } else if (_max == _g) {
            _h = (_b - _r) / _d + 2;
        } else {
            _h = (_r - _g) / _d + 4;
        }
        _h /= 6;
        if (_h < 0) _h += 1;
    }
    return { h: _h, s: _s, v: _v };
}

function UiColorPicker(style = {}, props = {}) : UiNode(style, props) constructor {
    flexpanel_node_style_set_flex_direction(self.node, flexpanel_flex_direction.row);
    flexpanel_node_style_set_align_items(self.node, flexpanel_align.center);
    flexpanel_node_style_set_justify_content(self.node, flexpanel_justify.start);
    flexpanel_node_style_set_align_self(self.node, flexpanel_align.flex_start);
    
    setName(props[$ "name"] ?? "UiColorPicker");
    self.value = props[$ "value"] ?? #3B82F6;
    self.onChange = props[$ "onChange"] ?? function(_color, _picker) {};
    self.valueGetter = props[$ "valueGetter"] ?? undefined;
    
    var _hsv = __uui_rgb_to_hsv(self.value);
    self.hue = _hsv.h;
    self.saturation = _hsv.s;
    self.brightness = _hsv.v;
    self.__syncLock = false;
    
    self.Panel = undefined;
    self.__copyCheckTimer = 0;
    
    // Contenitore principale che contiene TUTTO (con bordo)
    self.Container = new UiNode({
        name: "UiColorPicker.Container",
        flexDirection: "row",
        alignItems: "center",
        height: 32,
        paddingLeft: 12,
        paddingRight: 2
    }, { pointerEvents: true });
    self.add(self.Container);
    
    // Disegna il bordo sul Container (non più sull'HexField)
    self.Container.onDraw = function() {
        var _focused = self.HexInput.Input.focused;
        draw_set_color(global.UI_COL_BG_CARD);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
        draw_set_color(_focused ? global.UI_COL_PRIMARY : global.UI_COL_BORDER);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, true);
    };
    
    self.HexField = new UiNode({
        name: "UiColorPicker.HexField",
        height: 32,
        flexDirection: "row",
        alignItems: "center",
        paddingLeft: 0,
        paddingRight: 0
    }, { pointerEvents: true });
    self.Container.add(self.HexField);
    
    self.Swatch = new UiNode({
        name: "UiColorPicker.Swatch",
        width: 16,
        height: 16,
        marginRight: 8,
        flexShrink: 0
    }, { pointerEvents: true, focusable: true, handpoint: true });
    self.HexField.add(self.Swatch);
    
    with (self.Swatch) {
        self.onMouseDown(function() {
            var _picker = self.parent.parent.parent;
            if (_picker.Panel != undefined) {
                _picker.closePanel();
            } else {
                _picker.openPanel();
            }
        });
        
        self.onDraw = function() {
            var _col = self.parent.parent.parent.value;
            var _cx = mean(self.x1, self.x2);
            var _cy = mean(self.y1, self.y2);
            var _r = min(self.x2 - self.x1, self.y2 - self.y1) * 0.7;
            
            draw_set_color(_col);
            draw_roundrect_ext(_cx - _r, _cy - _r, _cx + _r, _cy + _r, 5, 5, false);
            
            if (self.hovered) {
                draw_set_alpha(0.2);
                draw_set_color(c_white);
                draw_roundrect_ext(_cx - _r, _cy - _r, _cx + _r, _cy + _r, 5, 5, false);
                draw_set_alpha(1);
            }
        };
    }
    
    var _Picker = self;
    self.HexInput = new UiTextbox({ height: "100%", minWidth: 75 }, {
        value: __uui_color_to_hex(self.value),
        maxLength: 7,
        placeholder: "#RRGGBB",
        onChange: method({ _Picker }, function(_hex, _input) {
            if (_Picker.__syncLock) return;
            var _col = __uui_hex_to_color(_hex);
            if (_col != undefined) {
                _Picker.setColor(_col);
            }
        }),
        onBlur: method({ _Picker }, function(_hex, _input) {
            if (_Picker.__syncLock) return;
            var _col = __uui_hex_to_color(_hex);
            if (_col != undefined) {
                _Picker.setColor(_col);
                _Picker.__syncLock = true;
                _input.value = __uui_color_to_hex(_col);
                _Picker.__syncLock = false;
            } else {
                _Picker.__syncLock = true;
                _input.value = __uui_color_to_hex(_Picker.value);
                _Picker.__syncLock = false;
            }
        })
    });
    self.HexField.add(self.HexInput);
    
    with (self.HexInput.Input) {
        self.border = false;
        flexpanel_node_style_set_padding(self.node, flexpanel_edge.left, 0);
        flexpanel_node_style_set_padding(self.node, flexpanel_edge.right, 4);
        self.onDraw = function() {
            var _scissor = gpu_get_scissor();
            var _ix1 = max(self.x1, _scissor.x);
            var _iy1 = max(self.y1, _scissor.y);
            var _ix2 = min(self.x2, _scissor.x + _scissor.w);
            var _iy2 = min(self.y2, _scissor.y + _scissor.h);
            __uui_set_scissor(_ix1, _iy1, max(0, _ix2 - _ix1), max(0, _iy2 - _iy1));
            
            draw_set_color(global.UI_COL_TEXT_MAIN);
            draw_set_font(fText);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            
            var _text = self.parent.value;
            var _textX = self.x1 + self.layout.paddingLeft - self.scrollOffset;
            var _textY = floor(mean(self.y1, self.y2));
            
            if (self.focused && self.selectionStart != self.selectionEnd) {
                var _start = min(self.selectionStart, self.selectionEnd);
                var _ended = max(self.selectionStart, self.selectionEnd);
                var _startX = _textX + string_width(string_copy(_text, 1, _start));
                var _endX = _textX + string_width(string_copy(_text, 1, _ended));
                draw_set_color(global.UI_COL_SELECTION);
                draw_set_alpha(0.3);
                draw_rectangle(_startX, self.y1 + 2, _endX, self.y2 - 2, false);
                draw_set_alpha(1);
            }
            
            draw_set_color(global.UI_COL_TEXT_MAIN);
            if (_text == "" && self.parent.placeholder != undefined) {
                draw_set_alpha(0.5);
                draw_text(_textX, _textY, self.parent.placeholder);
                draw_set_alpha(1);
            } else {
                draw_text(_textX, _textY, _text);
            }
            
            if (self.focused && self.showCursor && self.selectionStart == self.selectionEnd) {
                var _cursorX = _textX + string_width(string_copy(_text, 1, self.cursorPos));
                draw_set_color(global.UI_COL_PRIMARY);
                draw_line(_cursorX, self.y1 + 5, _cursorX, self.y2 - 5);
            }
            
            gpu_set_scissor(_scissor);
        };
    }
    
    self.Divider = new UiNode({ width: 1, height: 18, flexShrink: 0 }, { pointerEvents: false });
    self.HexField.add(self.Divider);
    with (self.Divider) {
        self.onDraw = function() {
            draw_set_color(global.UI_COL_BORDER);
            draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
        };
    }
    
    self.CopyBtn = new UiNode({
        name: "UiColorPicker.CopyBtn",
        width: 32,
        height: "90%",
        margin: 3
    }, { pointerEvents: true, handpoint: true });
    self.HexField.add(self.CopyBtn);
    with (self.CopyBtn) {
        self.onMouseEnter(function() { global.UI.requestRedraw(); });
        self.onMouseLeave(function() { global.UI.requestRedraw(); });
        self.onMouseDown(function() {
            clipboard_set_text(__uui_color_to_hex(self.parent.parent.parent.value));
            self.parent.parent.parent.__copyCheckTimer = 60;
            global.UI.requestRedraw();
            return true;
        });
        self.onDraw = function() {
            if (self.hovered) {
                draw_set_alpha(0.08);
                draw_set_color(global.UI_COL_TEXT_MAIN);
                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
                draw_set_alpha(1);
            }
            var _cx = mean(self.x1, self.x2);
            var _cy = mean(self.y1, self.y2);
            var _sprite = (self.parent.parent.parent.__copyCheckTimer > 0) ? sprUiIconCheck : sprUiIconCopy;
            var _sw = sprite_get_width(_sprite);
            var _sh = sprite_get_height(_sprite);
            var _color = (self.parent.parent.parent.__copyCheckTimer > 0) ? global.UI_COL_SUCCESS : global.UI_COL_TEXT_DIM;
            draw_sprite_ext(_sprite, 0, _cx, _cy, 16 / _sw, 16 / _sh, 0, _color, 1);
        };
    }
    
    self.onStep(function() {
        if (self.valueGetter != undefined && !self.__syncLock) {
            var _ext = self.valueGetter();
            if (_ext != self.value) {
                self.setColor(_ext, false);
            }
        }
        if (self.__copyCheckTimer > 0) {
            self.__copyCheckTimer -= 1;
        }
    });
    
    self.syncHsvFromValue = function() {
        var _hsv = __uui_rgb_to_hsv(self.value);
        self.hue = _hsv.h;
        self.saturation = _hsv.s;
        self.brightness = _hsv.v;
    };
    
    self.colorFromHsv = function() {
        return __uui_hsv_to_rgb(self.hue, self.saturation, self.brightness);
    };
    
    self.setColor = function(_col, _fireChange = true) {
        if (_col == undefined) return;
        var _changed = (self.value != _col);
        self.value = _col;
        self.syncHsvFromValue();
        if (self.HexInput != undefined) {
            self.__syncLock = true;
            self.HexInput.value = __uui_color_to_hex(self.value);
            self.__syncLock = false;
        }
        if (_fireChange && _changed) self.onChange(self.value, self);
        global.UI.requestRedraw();
    };
    
    self.applyHsv = function(_fireChange = true) {
        var _newCol = self.colorFromHsv();
        if (_newCol != self.value) {
            self.value = _newCol;
            if (self.HexInput != undefined) {
                self.__syncLock = true;
                self.HexInput.value = __uui_color_to_hex(self.value);
                self.__syncLock = false;
            }
            if (_fireChange) self.onChange(self.value, self);
            global.UI.requestRedraw();
        }
    };
    
    self.openPanel = function() {
        var _Picker = self;
        
        self.Panel = new UiNode({
            name: "UiColorPicker.Panel",
            position: "absolute",
            width: 248,
            flexDirection: "column",
            padding: 10,
            left: -9999,
            top: -9999
        }, { pointerEvents: true });
        
        with (self.Panel) {
            self.Picker = _Picker;
            
            self.computePosition = function() {
                var _Picker = self.Picker;
                if (!_Picker.Container.isVisible()) return _Picker.closePanel();
                
                var _height = self.layout.height;
                if (!_height) return;
                
                var _Anchor = _Picker.Container;
                if (abs(self.x1 - _Anchor.x1) > 1) self.setLeft(_Anchor.x1);
                
                var _yy = floor(_Anchor.y2 + 6);
                if (_yy + _height > display_get_gui_height()) {
                    _yy = floor(_Anchor.y1 - 6 - _height);
                }
                if (abs(self.y1 - _yy) > 1) self.setTop(_yy);
            };
            
            self.__skipFirstRelease = true;
            
            self.onStep(function() {
                self.computePosition();
                
                if (global.UI.mouseReleased) {
                    if (self.__skipFirstRelease) {
                        self.__skipFirstRelease = false;
                        return;
                    }
                    
                    var _Picker = self.Picker;
                    var _inPanel = point_in_rectangle(global.UI.mouseX, global.UI.mouseY, self.x1, self.y1, self.x2, self.y2);
                    var _inPicker = point_in_rectangle(global.UI.mouseX, global.UI.mouseY, _Picker.x1, _Picker.y1, _Picker.x2, _Picker.y2);
                    
                    if (!_inPanel && !_inPicker) {
                        _Picker.closePanel();
                    }
                }
            });
            
            self.onDraw = function() {
                draw_set_color(global.UI_COL_DROPDOWN_LIST_BG);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
                draw_set_color(global.UI_COL_BORDER);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
            };
            
            // Saturation / brightness area
            self.SvArea = new UiNode({
                name: "UiColorPicker.Panel.SvArea",
                width: "100%",
                height: 140,
                marginBottom: 10
            }, { pointerEvents: true, handpoint: true });
            self.add(self.SvArea);
            
            with (self.SvArea) {
                self.dragging = false;
                
                self.updateFromMouse = function() {
                    var _Picker = self.parent.Picker;
                    var _t = clamp((global.UI.mouseX - self.x1) / (self.x2 - self.x1), 0, 1);
                    var _v = 1 - clamp((global.UI.mouseY - self.y1) / (self.y2 - self.y1), 0, 1);
                    _Picker.saturation = _t;
                    _Picker.brightness = _v;
                    _Picker.applyHsv();
                };
                
                self.onMouseDown(function() {
                    self.dragging = true;
                    self.updateFromMouse();
                    return true;
                });
                
                self.onStep(function() {
                    if (self.dragging) {
                        if (!mouse_check_button(mb_left)) {
                            self.dragging = false;
                        } else {
                            self.updateFromMouse();
                        }
                    }
                });
                
                self.onDraw = function() {
                    var _hueCol = __uui_hsv_to_rgb(self.parent.Picker.hue, 1, 1);
                    
                    // Draw SV area with smooth primitives for better gradient
                    draw_primitive_begin(pr_trianglestrip);
                    // Top row (value = 1)
                    draw_vertex_color(self.x1, self.y1, c_white, 1);
                    draw_vertex_color(self.x2, self.y1, _hueCol, 1);
                    // Bottom row ( (value = 0)
                    draw_vertex_color(self.x1, self.y2, c_black, 1);
                    draw_vertex_color(self.x2, self.y2, c_black, 1);
                    draw_primitive_end();
                    
                    draw_set_color(global.UI_COL_BORDER);
                    draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, true);
                    
                    var _Picker = self.parent.Picker;
                    var _cx = lerp(self.x1, self.x2, _Picker.saturation);
                    var _cy = lerp(self.y2, self.y1, _Picker.brightness);
                    draw_set_color(c_white);
                    draw_circle(_cx, _cy, 6, false);
                    draw_set_color(global.UI_COL_TEXT_MAIN);
                    draw_circle(_cx, _cy, 6, true);
                };
            }
            
            // Hue slider
            self.HueBar = new UiNode({
                name: "UiColorPicker.Panel.HueBar",
                width: "100%",
                height: 14
            }, { pointerEvents: true, handpoint: true });
            self.add(self.HueBar);
            
            with (self.HueBar) {
                self.dragging = false;
                
                self.updateFromMouse = function() {
                    var _Picker = self.parent.Picker;
                    _Picker.hue = clamp((global.UI.mouseX - self.x1) / (self.x2 - self.x1), 0, 1);
                    _Picker.applyHsv();
                };
                
                self.onMouseDown(function() {
                    self.dragging = true;
                    self.updateFromMouse();
                    return true;
                });
                
                self.onStep(function() {
                    if (self.dragging) {
                        if (!mouse_check_button(mb_left)) {
                            self.dragging = false;
                        } else {
                            self.updateFromMouse();
                        }
                    }
                });
                
                self.onDraw = function() {
                    var _segments = 36;
                    var _w = (self.x2 - self.x1) / _segments;
                    draw_primitive_begin(pr_trianglestrip);
                    for (var _i = 0; _i <= _segments; _i++) {
                        var _h = _i / _segments;
                        var _c = __uui_hsv_to_rgb(_h, 1, 1);
                        var _x = lerp(self.x1, self.x2, _i / _segments);
                        draw_vertex_color(_x, self.y1, _c, 1);
                        draw_vertex_color(_x, self.y2, _c, 1);
                    }
                    draw_primitive_end();
                    
                    draw_set_color(global.UI_COL_BORDER);
                    draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, true);
                    
                    var _hx = lerp(self.x1, self.x2, self.parent.Picker.hue);
                    draw_set_color(c_white);
                    draw_roundrect_ext(_hx - 3, self.y1 - 2, _hx + 3, self.y2 + 2, 2, 2, false);
                    draw_set_color(global.UI_COL_TEXT_MAIN);
                    draw_roundrect_ext(_hx - 3, self.y1 - 2, _hx + 3, self.y2 + 2, 2, 2, true);
                };
            }
        }
        
        global.UI.getOverlay().add(self.Panel);
    };
    
    self.closePanel = function() {
        if (self.Panel != undefined) {
            self.Panel.destroy();
            self.Panel = undefined;
        }
    };
}
