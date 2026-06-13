/**
 * UiMenuBar - Horizontal application-style menu bar
 * Renders a row of top-level labels (File, Edit, View…) that open
 * dropdown panels on click, with hover-to-switch when one is already open.
 *
 * Usage:
 *   var menuBar = new UiMenuBar([
 *     {
 *       label: "File",
 *       items: [
 *         { label: "New",  onClick: function() { … }, shortcut: "Ctrl+N" },
 *         { separator: true },
 *         { label: "Exit", onClick: function() { … }, disabled: true }
 *       ]
 *     },
 *     { label: "Edit", items: [ … ] }
 *   ], { width: "100%", height: 32 }, {});
 */
function UiMenuBar(menus = [], style = {}, props = {}) : UiNode(style, props) constructor {
    var _this = self;
    setName("UiMenuBar");

    flexpanel_node_style_set_flex_direction(self.node, flexpanel_flex_direction.row);
    flexpanel_node_style_set_align_items(self.node, flexpanel_align.center);
    flexpanel_node_style_set_padding(self.node, flexpanel_edge.left,   6);
    flexpanel_node_style_set_padding(self.node, flexpanel_edge.right,  6);

    self.menus             = menus;
    self.activeMenu        = undefined;
    self.activeTrigger     = undefined;
    self.__triggerNodes    = [];
    self.__itemPadding     = props[$ "itemPadding"] ?? 12;
    self.__minDropdownWidth = props[$ "minDropdownWidth"] ?? 200;
    self.__triggerInsetV   = 5;
    self.__triggerInsetH   = 2;
    self.__triggerRadius    = 5;

    draw_set_font(global.UI_FONTS.standard);

    self.onDraw = function() {
        // Slightly recessed fill (theme-aware, no hardcoded white)
        draw_set_color(merge_color(global.UI_COL_SURFACE_3, global.UI_COL_BORDER_1, 0.14));
        draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);

        // Top & bottom edges - both use theme border color
        draw_set_color(global.UI_COL_BORDER_1);
        draw_line(self.x1, self.y1, self.x2, self.y1);
        draw_line(self.x1, self.y2 - 1, self.x2, self.y2 - 1);
    };

    for (var i = 0; i < array_length(menus); i++) {
        var _menuData = menus[i];
        var _labelW   = string_width(_menuData.label);
        var _triggerW = _labelW + self.__itemPadding * 2;

        var _trigger = new UiNode({
            name:              "UiMenuBar.Trigger",
            height:            "100%",
            width:             _triggerW,
            flexShrink:        0,
            marginRight:       2,
            paddingHorizontal: self.__itemPadding,
            justifyContent:    "center",
            alignItems:        "center"
        }, { pointerEvents: true, handpoint: true });

        _trigger.__label    = _menuData.label;
        _trigger.__menuData = _menuData;
        _trigger.__bar      = _this;

        with (_trigger) {
            self.onMouseEnter(method(self, function() {
                if (self.__bar.activeMenu != undefined && self.__bar.activeTrigger != self) {
                    self.__bar.__openMenu(self);
                }
                global.UI.requestRedraw();
            }));

            self.onMouseLeave(function() {
                global.UI.requestRedraw();
            });

            self.onMouseDown(method(self, function() {
                if (self.__bar.activeTrigger == self && self.__bar.activeMenu != undefined) {
                    self.__bar.closeAll();
                } else {
                    self.__bar.__openMenu(self);
                }
            }));

            self.onDraw = method(self, function() {
                var _bar    = self.__bar;
                var _isOpen = (_bar.activeTrigger == self && _bar.activeMenu != undefined);
                var _ix1 = self.x1 + _bar.__triggerInsetH;
                var _iy1 = self.y1 + _bar.__triggerInsetV;
                var _ix2 = self.x2 - _bar.__triggerInsetH;
                var _iy2 = self.y2 - _bar.__triggerInsetV;
                var _rad = _bar.__triggerRadius;

                if (_isOpen) {
                    draw_set_color(global.UI_COL_PRIMARY);
                    draw_roundrect_ext(_ix1, _iy1, _ix2, _iy2, _rad, _rad, false);
                } else if (self.hovered) {
                    draw_set_color(global.UI_COL_HOVER);
                    draw_roundrect_ext(_ix1, _iy1, _ix2, _iy2, _rad, _rad, false);
                    draw_set_color(global.UI_COL_BORDER_1);
                    draw_roundrect_ext(_ix1, _iy1, _ix2, _iy2, _rad, _rad, true);
                }

                draw_set_font(global.UI_FONTS.standard);
                draw_set_color(_isOpen ? c_white : global.UI_COL_TEXT_1);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.__label);
            });
        }

        array_push(self.__triggerNodes, _trigger);
        self.add(_trigger);
    }

    function closeAll() {
        if (self.activeMenu != undefined) {
            self.activeMenu.destroy();
            self.activeMenu    = undefined;
            self.activeTrigger = undefined;
            global.UI.requestRedraw();
        }
    }

    function __measureDropdownWidth(items) {
        draw_set_font(global.UI_FONTS.standard);
        var _minW = self.__minDropdownWidth;
        for (var j = 0; j < array_length(items); j++) {
            var _it = items[j];
            if (_it[$ "separator"]) continue;
            var _lw = string_width(_it.label);
            draw_set_font(global.UI_FONTS.small);
            var _sw = (_it[$ "shortcut"] != undefined) ? string_width(_it[$ "shortcut"]) : 0;
            draw_set_font(global.UI_FONTS.standard);
            var _rowW = 36 + _lw + (_sw > 0 ? _sw + 28 : 0);
            if (_rowW > _minW) _minW = _rowW;
        }
        return _minW;
    }

    function __openMenu(triggerNode) {
        if (self.activeMenu != undefined) {
            self.activeMenu.destroy();
            self.activeMenu = undefined;
        }

        self.activeTrigger = triggerNode;
        global.UI.requestRedraw();

        var _menuData = triggerNode.__menuData;
        var _items    = _menuData.items;
        var _bar      = self;
        var _panelW   = __measureDropdownWidth(_items);

        var _panel = new UiNode({
            name:              "UiMenuBar.Dropdown",
            position:          "absolute",
            flexDirection:     "column",
            width:             _panelW,
            paddingHorizontal: 8,
            paddingVertical:   8,
            left:              -9999,
            top:               -9999
        }, { pointerEvents: true });

        with (_panel) {
            self.__bar         = _bar;
            self.__trigger     = triggerNode;
            self.__justOpened  = true;
            self.__positionSet = false;

            self.onStep(function() {
                if (!self.__positionSet && self.__trigger.width > 0) {
                    self.setLeft(self.__trigger.x1);
                    self.setTop(self.__trigger.y2 + 2);
                    self.__positionSet = true;
                }

                if (self.__justOpened) {
                    self.__justOpened = false;
                    return;
                }

                if (global.UI.mouseReleased) {
                    var _inBar   = point_in_rectangle(global.UI.mouseX, global.UI.mouseY,
                                    self.__bar.x1, self.__bar.y1, self.__bar.x2, self.__bar.y2);
                    var _inPanel = point_in_rectangle(global.UI.mouseX, global.UI.mouseY,
                                    self.x1, self.y1, self.x2, self.y2);
                    if (!_inBar && !_inPanel) {
                        self.__bar.closeAll();
                    }
                }

                if (keyboard_check_pressed(vk_escape)) {
                    self.__bar.closeAll();
                }

                if (self.__positionSet && self.layout.width > 0) {
                    var _rEdge = self.x1 + self.layout.width;
                    if (_rEdge > display_get_gui_width()) {
                        self.setLeft(display_get_gui_width() - self.layout.width - 4);
                    }
                    var _bEdge = self.y1 + self.layout.height;
                    if (_bEdge > display_get_gui_height()) {
                        self.setTop(self.__trigger.y1 - self.layout.height - 2);
                    }
                }
            });

            self.onDraw = function() {
                draw_set_color(global.UI_COL_FLOATING_BG);
                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);

                draw_set_color(#334155);
                draw_rectangle(self.x1, self.y1, self.x2, self.y2, true);
            };

            for (var i = 0; i < array_length(_items); i++) {
                var _item = _items[i];

                if (_item[$ "separator"]) {
                    var _sep = new UiNode({ width: "100%", height: 9 });
                    _sep.onDraw = method(_sep, function() {
                        var _sy = floor(mean(self.y1, self.y2));
                        draw_set_color(#334155);
                        draw_line(self.x1 + 6, _sy, self.x2 - 6, _sy);
                    });
                    self.add(_sep);
                    continue;
                }

                var _disabled = _item[$ "disabled"] ?? false;
                var _shortcut = _item[$ "shortcut"];
                var _onClick  = _item[$ "onClick"];
                var _label    = _item.label;

                var _row = new UiNode({
                    name:              "UiMenuBar.Item",
                    width:             "100%",
                    height:            30,
                    paddingHorizontal: 12,
                    marginBottom:      1,
                    flexDirection:     "row",
                    alignItems:        "center"
                }, { pointerEvents: !_disabled, handpoint: !_disabled });

                _row.__label    = _label;
                _row.__shortcut = _shortcut;
                _row.__disabled = _disabled;
                _row.__onClick  = _onClick;
                _row.__bar      = _bar;

                with (_row) {
                    self.onMouseEnter(function() { global.UI.requestRedraw(); });
                    self.onMouseLeave(function() { global.UI.requestRedraw(); });

                    self.onMouseDown(method(self, function() {
                        if (self.__disabled) return;
                        if (mouse_check_button_pressed(mb_left)) {
                            if (self.__onClick != undefined) self.__onClick();
                            self.__bar.closeAll();
                            return true;
                        }
                        return false;
                    }));

                    self.onDraw = method(self, function() {
                        if (!self.__disabled && self.hovered) {
                            draw_set_color(global.UI_COL_PRIMARY);
                            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 5, 5, false);
                        }

                        var _xx = self.x1 + 12;
                        var _yy = ~~mean(self.y1, self.y2);

                        draw_set_font(global.UI_FONTS.standard);
                        if (self.__disabled) {
                            draw_set_color(#64748B);
                        } else if (self.hovered) {
                            draw_set_color(c_white);
                        } else {
                            draw_set_color(#E2E8F0);
                        }
                        draw_set_halign(fa_left);
                        draw_set_valign(fa_middle);
                        draw_text(_xx, _yy, self.__label);

                        if (self.__shortcut != undefined) {
                            draw_set_font(global.UI_FONTS.small);
                            if (self.__disabled) {
                                draw_set_color(#475569);
                            } else if (self.hovered) {
                                draw_set_color(#BFDBFE);
                            } else {
                                draw_set_color(#94A3B8);
                            }
                            draw_set_halign(fa_right);
                            draw_text(self.x2 - 12, _yy, self.__shortcut);
                            draw_set_halign(fa_left);
                            draw_set_font(global.UI_FONTS.standard);
                        }
                    });
                }

                self.add(_row);
            }
        }

        self.activeMenu = _panel;
        global.UI.getOverlay().add(_panel);
    }
}
