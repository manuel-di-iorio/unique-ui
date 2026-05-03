function ui_demo_example_modal(parent) {
    var _container = new UiNode({ width: "100%", flexDirection: "column", padding: 20 });
    parent.add(_container);
    
    _container.add(new UiText("Modal component examples.", { marginBottom: 20 }, { color: global.UI_COL_TEXT_MAIN }));

    // Basic Modal
    var _btnBasic = new UiButton("Open Basic Modal", { marginBottom: 10 });
    _btnBasic.onClick(function() {
        var _modal = new UiModal({}, {
            title: "Basic Modal",
        });
        _modal.add(new UiText("This is a basic modal. You can close it by clicking the X or clicking outside.", { width: "100%" }, { wrap: true, color: global.UI_COL_TEXT_MAIN }));
        _modal.open();
    });
    _container.add(_btnBasic);

    // Confirmation Modal
    var _btnConfirm = new UiButton("Open Confirmation Modal", { marginBottom: 10 }, { variant: "primary" });
    _btnConfirm.onClick(function() {
        var _modal = new UiModal({}, {
            title: "Are you sure?",
            dismissOnBackdropClick: false
        });
        
        _modal.add(new UiText("This modal cannot be closed by clicking the background. Do you wish to proceed?", { width: "100%", marginBottom: 20 }, { wrap: true, color: global.UI_COL_TEXT_MAIN }));
        
        var _actions = new UiNode({ flexDirection: "row", justifyContent: "flex-end", marginTop: 10, width: "100%" });
        
        var _cancelBtn = new UiButton("Cancel", { marginRight: 10 }, { variant: "outline" });
        _cancelBtn.onClick(method({ modal: _modal }, function() {
            modal.close();
        }));
        _actions.add(_cancelBtn);
        
        var _confirmBtn = new UiButton("Proceed", {}, { variant: "primary" });
        _confirmBtn.onClick(method({ modal: _modal }, function() {
            // Do something
            modal.close();
        }));
        _actions.add(_confirmBtn);
        
        _modal.add(_actions);
        _modal.open();
    });
    _container.add(_btnConfirm);
    
    return [
        "// Basic Modal",
        "var _modal = new UiModal({}, { title: \"Basic Modal\" });",
        "_modal.add(new UiText(\"Content...\"));",
        "_modal.open();",
        "",
        "// Confirmation Modal",
        "var _modal = new UiModal({}, { title: \"Are you sure?\", dismissOnBackdropClick: false });",
        "var _cancelBtn = new UiButton(\"Cancel\");",
        "_cancelBtn.onClick(method({ modal: _modal }, function() { modal.close(); }));",
        "_modal.add(_cancelBtn);",
        "_modal.open();"
    ];
}
