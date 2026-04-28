function UiDropdown(style = {}, props = {}) : UiNode(style, props) constructor {
    var _this = self;
    setName(props[$ "name"] ?? "UiDropdown");
    self.value = props[$ "value"];
    self.items = props[$ "items"] ?? [];
    self.itemsGetter = props[$ "itemsGetter"];
    self.label = props[$ "label"] ?? undefined;
    self.onChange = props[$ "onChange"] ?? function(input, value) {};
    draw_set_font(fText);
    var _marginLeft = self.label == undefined ? 0 : 3 + string_width(self.label) + 20;
    self.List = undefined;
    self.search = props[$ "search"];

    self.onStep(function() {
        if (self.itemsGetter != undefined) {
            self.items = self.itemsGetter("");
        }

        // Check if current value is still valid
        if (self.value != undefined) {
            var found = false;
            for (var i = 0, l = array_length(self.items); i < l; i++) {
                if (self.items[i].value == self.value) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                self.value = undefined;
                self.onChange(undefined);
            }
        }
    });

    // Draw the label if present
   function onDraw() {
       if (self.label != undefined) {
           draw_set_color(global.UI_COL_TEXT_MAIN); draw_set_halign(fa_left); draw_set_valign(fa_middle);
           draw_text(self.x1 + 3, ~~mean(self.y1, self.y2), self.label);
       }
   }
    
    // Input
    self.Input = new UiNode({
        name: "UiDropdown.Input", 
        flexGrow: 1,
        marginLeft: _marginLeft,
        height: "100%",
        flexDirection: "row",
        alignItems: "center",
        paddingHorizontal: 12
    }, { pointerEvents: true, focusable: true, border: true, handpoint: true });
    self.add(self.Input);
    
    with (self.Input) {
        self.onMouseDown(function() {
            var List = self.parent.List;
            if (List != undefined) {
                self.parent.closeList();
            } else {
                self.parent.createList(); 
            }
        });
        
        self.onDraw = function() {
            var radius = 6;
            draw_set_color(global.UI_COL_INPUT_BG);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
            
            if (self.hovered) {
                draw_set_color(global.UI_COL_BTN_HOVER);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, false);
            }
            
            draw_set_color(global.UI_COL_BORDER);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, radius, radius, true);

            // Button arrow
            draw_set_color(global.UI_COL_TEXT_DIM);
            draw_triangle(self.x2 - 17, self.y1 + 10, self.x2 - 7, self.y1 + 10, self.x2 - 12, self.y2 - 10, false);
            
            // Selected value
            draw_set_halign(fa_left); draw_set_valign(fa_middle); draw_set_color(global.UI_COL_TEXT_MAIN);
            var _selectedIndex = array_find_index(self.parent.items, method({ value: self.parent.value }, function(item) {
                return item.value == self.value;
            }));
       
            var _text = _selectedIndex != -1 ? self.parent.items[_selectedIndex].label : "Select...";
            
            // Clip text to button width
            var _scissor = gpu_get_scissor();
            gpu_set_scissor(self.x1, self.y1, self.x2 - self.x1 - 25, self.y2 - self.y1);
            draw_text(self.x1 + 8, ~~mean(self.y1, self.y2), _text);
            gpu_set_scissor(_scissor);
         };
    } 
     
    self.createList = function() { 
        var _Dropdown = self;
        var _Input = self.Input;
        self.List = new UiNode({
            name: "UiDropdown.List", position: "absolute", padding: 5, maxHeight: 500, 
            left: -9999, top: -9999
        }, { pointerEvents: true });
        
        with (self.List) {
            self.Dropdown = _Dropdown;
         
            self.computePosition = function() {
                var _Dropdown = self.Dropdown;
                if (!_Dropdown.Input.isVisible()) return _Dropdown.closeList();
                
                var _height = self.layout.height;
                if (!_height) return;
                
                var Input = _Dropdown.Input;
                if (abs(self.x1 - Input.x1) > 1) self.setLeft(Input.x1);
                if (abs(self.width - Input.width) > 1) self.setWidth(Input.width); 
                
                var yy = floor(Input.y1 + 30);
                if (yy + _height > display_get_gui_height()) {
                    yy = floor(yy - 30 - self.layout.height);
                }
                if (abs(self.y1 - yy) > 1) self.setTop(yy);
            }
    
            // Skip the first mouseReleased after opening (user might hold mouse and release outside)
            self.__skipFirstRelease = true;
            
            self.onStep(function() {
                self.computePosition();
                
                if (global.UI.mouseReleased) {
                    // Skip the first mouseReleased event after opening
                    if (self.__skipFirstRelease) {
                        self.__skipFirstRelease = false;
                        return;
                    }
                    
                    var y1 = min(self.y1, self.Dropdown.y1);
                    var y2 = max(self.y2, self.Dropdown.y2);
                    
                    if (!point_in_rectangle(global.UI.mouseX, global.UI.mouseY, self.x1, y1, self.x2, y2)) {
                        self.Dropdown.closeList();
                    }
                }
            });
            
            self.onDraw = function() {
                draw_set_color(c_white);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
                draw_set_color(global.UI_COL_BORDER);
                draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
            }
            
            self.createItems = function() {
                var _Dropdown = self.Dropdown;
                var _items = _Dropdown.items;
        
                if (!array_length(_items)) {
                    self.Items.add(new UiText("No assets found", { marginLeft: 5 }, { color: c_ltgray, font: fTextItalic }));
                }
        
                // Add the items
                for (var i = 0, l = array_length(_items); i < l; i++) {
                    var _item = _items[i];
                    var _itemNode = new UiNode({
                        name: "UiDropdown.List.Item",
                        width: "100%",
                        height: 25
                    }, {
                        tooltip: _item[$ "tooltip"]
                    });
                    _itemNode.label = _item.label;
                    _itemNode.value = _item.value;
                    
                    with (_itemNode) {
                        self.pointerEvents = true;
                        self.handpoint = true;
                        
                        self.onClick(function() {
                            var Dropdown = self.parent.parent.Dropdown;
                            if (Dropdown.value != self.value) {
                                Dropdown.value = self.value;
                                Dropdown.onChange(self.value);
                            }
                            Dropdown.closeList();
                        });
                        
                        self.onMouseEnter(function() {
                            global.UI.requestRedraw();
                        });
                        
                        self.onMouseLeave(function() {
                            global.UI.requestRedraw();
                        });
                        
                        self.onDraw = function() {
                            if (self.parent.parent.Dropdown.value == self.value) {
                                draw_set_color(global.UI_COL_PRIMARY);
                                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
                            } else if (self.hovered) {
                                draw_set_color(global.UI_COL_BTN_HOVER);
                                draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
                            }
                            
                            var text_color = (self.parent.parent.Dropdown.value == self.value) ? c_white : global.UI_COL_TEXT_MAIN;
                            draw_set_halign(fa_left); draw_set_valign(fa_middle); draw_set_color(text_color);
                            draw_text(self.x1 + 12, ~~mean(self.y1, self.y2), self.label);
                        };
                    }
                    
                    self.Items.add(_itemNode);
                }
                
                self.Items.enableScrollbar(global.UI_COL_CHECKBOX_HOVER);
            }
            
            // Create the search input
            if (_Dropdown.search != undefined) {
                self.Search = new UiTextbox({ height: 25, marginBottom: 10 }, {
                    placeholder: _Dropdown.search ?? "Search..",
                    onChange: method({ _Dropdown }, function(searchValue) {
                        _Dropdown.List.Items.destroyChildren();
                        _Dropdown.items = [];
                        
                        if (_Dropdown.itemsGetter != undefined) _Dropdown.items = _Dropdown.itemsGetter(searchValue);
                        _Dropdown.List.createItems();
                    })
                });
                self.add(self.Search);
            }
            
            // Create the items container
            self.Items = new UiNode({ height: "100%", maxHeight: 450 });
            self.add(self.Items);
            
            // Create the initial items
            var initialSearch = self[$ "Search"] != undefined ? self.Search.value : "";
            if (_Dropdown.itemsGetter != undefined) _Dropdown.items = _Dropdown.itemsGetter(initialSearch);
            self.createItems(); 
        }
        
        global.UI.Overlay.add(self.List);
        // Don't call computePosition() here - layout isn't calculated yet!
        // It will be called in the first onStep after layout is ready.
    }
    
    self.closeList = function() {
        if (self.List != undefined) {
            self.List.destroy();
            self.List = undefined;
        }
    }
}

