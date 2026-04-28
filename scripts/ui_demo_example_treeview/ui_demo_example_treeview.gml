function ui_demo_example_treeview(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Esempio Gerarchia");
    var tree = new UiTreeview({ flex: 1, width: "100%" });
    PreviewCard.add(tree);
    
    var root = new UiTreeviewItem({ name: "Progetto" }, { treeview: tree, assetType: "Folder", collapsed: false });
    tree.Items.add(root);
    
    var folder1 = new UiTreeviewItem({ name: "Sprites" }, { treeview: tree, assetType: "Folder" });
    root.addChild(folder1);
    folder1.addChild(new UiTreeviewItem({ name: "sprPlayer" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    folder1.addChild(new UiTreeviewItem({ name: "sprEnemy" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    
    var folder2 = new UiTreeviewItem({ name: "Scripts" }, { treeview: tree, assetType: "Folder" });
    root.addChild(folder2);
    folder2.addChild(new UiTreeviewItem({ name: "scrMovement" }, { treeview: tree, assetType: "Asset", icon: sprDemo }));
    
    return [
        "var tree = new UiTreeview({ flex: 1, width: \"100%\" });",
        "PreviewCard.add(tree);",
        "",
        "var root = new UiTreeviewItem({ name: \"Root\" }, { ",
        "    treeview: tree, assetType: \"Folder\", collapsed: false ",
        "});",
        "tree.Items.add(root);",
        "",
        "var folder = new UiTreeviewItem({ name: \"Folder\" }, { ... });",
        "root.addChild(folder);",
        "folder.addChild(new UiTreeviewItem({ name: \"Asset\" }, { ... }));"
    ];
}
