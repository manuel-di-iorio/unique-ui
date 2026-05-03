function ui_demo_example_treeview(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Interactive Hierarchy");
    
    // Top bar for actions
    var TopBar = new UiNode({ flexDirection: "row", width: "100%", marginBottom: 12, gap: 8 });
    PreviewCard.add(TopBar);
    
    var tree = new UiTreeview({ flex: 1, width: "100%", height: 300 });
    
    var addBtn = new UiButton("Add Root Item", { height: 32 }, { variant: "outline" });
    addBtn.onClick(method({ tree }, function() {
        var newItem = new UiTreeviewItem({ name: "New Folder" }, { treeview: tree, assetType: "Folder" });
        tree.Items.add(newItem);
        global.UI.requestUpdate();
    }));
    TopBar.add(addBtn);
    
    PreviewCard.add(tree);
    
    // Handle Drop (Move item)
    tree.onAssetDrop = function(draggedItem, targetFolder) {
        if (draggedItem == targetFolder) return;
        targetFolder.addChild(draggedItem);
        targetFolder.expandItem();
        global.UI.requestUpdate();
    };
    
    // Handle Context Menu
    tree.onContextMenu = function(item) {
        var menu = new UiContextMenu(global.UI.mouseX, global.UI.mouseY);
        menu.addItem("Add Child", method({ item }, function() {
            item.addChild(new UiTreeviewItem({ name: "New Item" }, { treeview: item.treeview, assetType: "Asset", icon: sprDemo }));
            item.expandItem();
        }));
        menu.addItem("Rename", method({ item }, function() {
            item.name = "Renamed Item";
            item.Label.text = item.name;
        }));
        menu.addSeparator();
        menu.addItem("Delete", method({ item }, function() {
            item.destroy();
        }));
        menu.show();
    };

    // Initial items (Adding more to test scroll)
    var root = new UiTreeviewItem({ name: "Project" }, { treeview: tree, assetType: "Folder", collapsed: false });
    tree.Items.add(root);
    
    var folder1 = new UiTreeviewItem({ name: "Sprites" }, { treeview: tree, assetType: "Folder" });
    root.addChild(folder1);
    folder1.addChild(new UiTreeviewItem({ name: "sprPlayer" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    folder1.addChild(new UiTreeviewItem({ name: "sprEnemy" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    folder1.addChild(new UiTreeviewItem({ name: "sprBoss" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    folder1.addChild(new UiTreeviewItem({ name: "sprNPC" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    
    var folder2 = new UiTreeviewItem({ name: "Scripts" }, { treeview: tree, assetType: "Folder" });
    root.addChild(folder2);
    folder2.addChild(new UiTreeviewItem({ name: "scrMovement" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    folder2.addChild(new UiTreeviewItem({ name: "scrCombat" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    folder2.addChild(new UiTreeviewItem({ name: "scrInventory" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    
    var folder3 = new UiTreeviewItem({ name: "Sounds" }, { treeview: tree, assetType: "Folder" });
    root.addChild(folder3);
    folder3.addChild(new UiTreeviewItem({ name: "sndExplosion" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    
    return [
        "var tree = new UiTreeview({ flex: 1, width: \"100%\" });",
        "",
        "// Drag and Drop support",
        "tree.onAssetDrop = function(draggedItem, targetFolder) {",
        "    targetFolder.addChild(draggedItem);",
        "};",
        "",
        "// Context Menu support",
        "tree.onContextMenu = function(item) {",
        "    var menu = new UiContextMenu(mouseX, mouseY);",
        "    menu.addItem(\"Delete\", function() { item.destroy(); });",
        "    menu.show();",
        "};"
    ];
}
