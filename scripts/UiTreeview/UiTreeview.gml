/**
 * Treeview - Free-form hierarchical tree structure
 * Supports flexible asset organization with drag & drop
 * @note This component is opinionated and should be customized.
 */
function UiTreeview(style = {}, props = {}): UiNode(style, props) constructor {
    setName(style[$ "name"] ?? "UiTreeview");
    var _this = self;
    self.selectedItem = undefined;  
    self.pointerEvents = true;
    self.onItemSelected = undefined;
    self.onAssetDrop = undefined;
    self.onContextMenu = undefined; // Callback for showing context menu
    self.backgroundColor = global.UI_COL_BG_SIDEBAR;
    
    // Create the items container
    self.Items = new UiNode({ name: "UiTreeview.Items", flex: 1, width: "100%" });
    self.add(self.Items);
    
    // Handle delete shortcut
    self.onStep(method(self, function() {
        if (keyboard_check_pressed(vk_delete)) {
            if (self.selectedItem != undefined && !global.UI.hasAnyFocus()) {
                self.selectedItem.__removeItem();
            }
        }
    }));
    
    /**
     * Select a treeview item
     */
    function __onItemSelected(treeviewItem, focus = false) {
        if (self.selectedItem != treeviewItem) {
            self.selectedItem = treeviewItem;
            self.Items.traverseChildren(method({ treeviewItem }, function(child) {
                if (child[$ "isTreeviewItem"]) {
                    child.selected = child == self.treeviewItem;
                }
            }));
        }
        
        if (self.onItemSelected != undefined) self.onItemSelected(treeviewItem, focus);
    }
    
    /**
     * Filter the treeview items by name
     */
    function filter(searchText) {
        var _lowerSearch = string_lower(searchText);
        
        var _filterItem = undefined;
        _filterItem = method({ _lowerSearch, _filterItem: function(item) {
                var nameToCheck = item.name;
                var matches = (_lowerSearch == "" || string_pos(_lowerSearch, string_lower(nameToCheck)) > 0);
                
                var hasMatchingChildren = false;
                var itemsNode = item[$ "Items"];
                if (itemsNode != undefined) {
                    var children = itemsNode.children;
                    for (var i = 0; i < array_length(children); i++) {
                        if (self._filterItem(children[i])) hasMatchingChildren = true;
                    }
                }
                
                var shouldBeVisible = matches || hasMatchingChildren;
                if (shouldBeVisible) {
                    item.show();
                    if (hasMatchingChildren && _lowerSearch != "") {
                        if (item.collapsed) item.expandItem();
                    }
                } else {
                    item.hide();
                }
                
                return shouldBeVisible;
            } 
        }, function(item) {
            return _filterItem(item);
        });
        
        var rootItems = self.Items.children;
        for (var i = 0; i < array_length(rootItems); i++) {
            _filterItem(rootItems[i]);
        }
    }
}

/**
 * Treeview Item - Represents an item in the tree hierarchy
 */
function UiTreeviewItem(style = {}, props = {}): UiNode(style, props) constructor {
    var _this = self;
    self.isTreeviewItem = true;
    self.treeview = props[$ "treeview"];
    self.assetType = props[$ "assetType"] ?? "Asset";
    self.icon = props[$ "icon"];
    self.name = props[$ "name"] ?? style[$ "name"] ?? "Item";
    self.selected = false;
    self.collapsed = props[$ "collapsed"] ?? true;
    
    // Row Content
    self.Content = new UiNode({ 
        name: "UiTreeview.Item.Content", 
        height: 32, 
        flexDirection: "row",
        alignItems: "center",
        paddingLeft: 4,
        paddingRight: 4
    }, {
        pointerEvents: true,
        handpoint: true,
    });
    self.add(self.Content);
    
    // Background highlight
    self.Content.onDraw = method(self.Content, function() {
        var _item = self.parent; 
        if (self.hovered || _item.selected) {
            draw_set_color(_item.selected ? global.UI_COL_SELECTED : global.UI_COL_BTN_HOVER);
            draw_set_alpha(_item.selected ? 0.3 : 0.1);
            draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
            draw_set_alpha(1);
        }
    });

    // Arrow Button (Toggle)
    self.ArrowContainer = new UiNode({ width: 20, height: 20, justifyContent: "center", alignItems: "center" });
    self.Content.add(self.ArrowContainer);
    
    self.Arrow = new UiNode({ width: 12, height: 12 }, { pointerEvents: true });
    self.Arrow.onDraw = method(self.Arrow, function() {
        var _item = self.parent.parent.parent; 
        if (_item.assetType != "Folder") return;
        draw_set_color(c_white);
        var mx = (self.x1 + self.x2) / 2;
        var my = (self.y1 + self.y2) / 2;
        if (_item.collapsed) {
            draw_triangle(mx-3, my-4, mx-3, my+4, mx+3, my, false);
        } else {
            draw_triangle(mx-4, my-3, mx+4, my-3, mx, my+3, false);
        }
    });
    self.Arrow.onClick(method(self, function() {
        if (self.collapsed) self.expandItem(); else self.collapseItem();
    }));
    self.ArrowContainer.add(self.Arrow);

    // Icon
    self.Icon = new UiNode({ width: 20, height: 20, marginLeft: 4, marginRight: 8 });
    self.Icon.onDraw = method(self.Icon, function() {
        var _item = self.parent.parent; 
        var mx = (self.x1 + self.x2) / 2;
        var my = (self.y1 + self.y2) / 2;
        
        if (_item.icon != undefined && _item.icon != -1) {
            var _sw = sprite_get_width(_item.icon);
            var _sh = sprite_get_height(_item.icon);
            var _scale = min(16 / _sw, 16 / _sh);
            var _ox = sprite_get_xoffset(_item.icon);
            var _oy = sprite_get_yoffset(_item.icon);
            // Draw centered regardless of origin
            draw_sprite_ext(_item.icon, 0, mx - (_sw/2 - _ox) * _scale, my - (_sh/2 - _oy) * _scale, _scale, _scale, 0, c_white, 1);
        } else {
            if (_item.assetType == "Folder") {
                draw_set_color(_item.collapsed ? #F59E0B : #FCD34D);
                // Folder shape
                draw_rectangle(self.x1+2, self.y1+6, self.x2-2, self.y2-4, false);
                draw_rectangle(self.x1+2, self.y1+4, self.x1+10, self.y1+6, false);
            } else {
                draw_set_color(#6366F1);
                draw_rectangle(self.x1+4, self.y1+4, self.x2-4, self.y2-4, false);
            }
        }
    });
    self.Content.add(self.Icon);

    // Label
    self.Label = new UiText(self.name, { flex: 1 }, { color: c_white, font: fTextSmall });
    self.Content.add(self.Label);

    // Handle selection
    self.Content.onClick(method(self, function() {
        self.treeview.__onItemSelected(self);
    }));
    
    self.Content.onDoubleClick(method(self, function() {
        if (self.assetType == "Folder") {
            if (self.collapsed) self.expandItem(); else self.collapseItem();
        }
    }));

    // Children Container
    self.Items = new UiNode({ marginLeft: 16 });
    if (self.collapsed) self.Items.hide();
    self.add(self.Items);
    
    function expandItem() {
        self.collapsed = false;
        self.Items.show();
        global.UI.requestUpdate();
    }
    
    function collapseItem() {
        self.collapsed = true;
        self.Items.hide();
        global.UI.requestUpdate();
    }
    
    function addChild(childItem) {
        self.Items.add(childItem);
        return self;
    }
}
