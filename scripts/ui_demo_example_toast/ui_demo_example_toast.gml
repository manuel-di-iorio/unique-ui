/// @desc ui_demo_example_toast — interactive showcase for UiToast.
/// @param {Struct} PreviewCard The container node to append playground elements to
/// @return {Array} Code lines preview for the code panel
function ui_demo_example_toast(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Interactive Playground");
    
    // Lazy initialize default demo variables in global.UI_DEMO
    if (!variable_struct_exists(global.UI_DEMO, "toastTitle")) {
        global.UI_DEMO.toastTitle = "Success";
    }
    if (!variable_struct_exists(global.UI_DEMO, "toastMessage")) {
        global.UI_DEMO.toastMessage = "Your configuration has been updated successfully!";
    }
    if (!variable_struct_exists(global.UI_DEMO, "toastDuration")) {
        global.UI_DEMO.toastDuration = "4000";
    }
    
    // Playground title input
    PreviewCard.add(new UiText("Toast Title (Optional):", { marginBottom: 6 }, { color: global.UI_COL_TEXT_DIM, font: fTextSmall }));
    var inputTitle = new UiTextbox({ width: "100%", height: 38, marginBottom: 12 }, {
        placeholder: "Enter title...",
        value: global.UI_DEMO.toastTitle,
        onChange: function(val) {
            global.UI_DEMO.toastTitle = val;
        }
    });
    inputTitle.onMouseDown(method(inputTitle, function() { self.Input.focus(); }));
    PreviewCard.add(inputTitle);
    
    // Playground message input
    PreviewCard.add(new UiText("Toast Message:", { marginBottom: 6 }, { color: global.UI_COL_TEXT_DIM, font: fTextSmall }));
    var inputMessage = new UiTextbox({ width: "100%", height: 38, marginBottom: 12 }, {
        placeholder: "Enter message...",
        value: global.UI_DEMO.toastMessage,
        onChange: function(val) {
            global.UI_DEMO.toastMessage = val;
        }
    });
    inputMessage.onMouseDown(method(inputMessage, function() { self.Input.focus(); }));
    PreviewCard.add(inputMessage);
    
    // Playground duration input
    PreviewCard.add(new UiText("Duration (ms, 0 for infinite):", { marginBottom: 6 }, { color: global.UI_COL_TEXT_DIM, font: fTextSmall }));
    var inputDuration = new UiTextbox({ width: "100%", height: 38, marginBottom: 20 }, {
        placeholder: "e.g. 4000",
        value: global.UI_DEMO.toastDuration,
        format: "integer",
        onChange: function(val) {
            global.UI_DEMO.toastDuration = val;
        }
    });
    inputDuration.onMouseDown(method(inputDuration, function() { self.Input.focus(); }));
    PreviewCard.add(inputDuration);
    
    // Trigger Buttons
    __ui_demo_preview_section(PreviewCard, "Trigger Toasts");
    var rowSpawners = new UiNode({ flexDirection: "row", marginBottom: 24, flexWrap: "wrap" });
    PreviewCard.add(rowSpawners);
    
    var btnInfo = new UiButton("Info", { marginRight: 10, marginBottom: 8, height: 34 }, { variant: "primary" });
    btnInfo.onClick(function() {
        var duration = real(global.UI_DEMO.toastDuration == "" ? "0" : global.UI_DEMO.toastDuration);
        var title = global.UI_DEMO.toastTitle == "" ? undefined : global.UI_DEMO.toastTitle;
        ui_toast_info(global.UI_DEMO.toastMessage, title, duration);
    });
    rowSpawners.add(btnInfo);
    
    var btnSuccess = new UiButton("Success", { marginRight: 10, marginBottom: 8, height: 34 }, { variant: "outline" });
    btnSuccess.onClick(function() {
        var duration = real(global.UI_DEMO.toastDuration == "" ? "0" : global.UI_DEMO.toastDuration);
        var title = global.UI_DEMO.toastTitle == "" ? undefined : global.UI_DEMO.toastTitle;
        ui_toast_success(global.UI_DEMO.toastMessage, title, duration);
    });
    rowSpawners.add(btnSuccess);
    
    var btnWarning = new UiButton("Warning", { marginRight: 10, marginBottom: 8, height: 34 }, { variant: "outline" });
    btnWarning.onClick(function() {
        var duration = real(global.UI_DEMO.toastDuration == "" ? "0" : global.UI_DEMO.toastDuration);
        var title = global.UI_DEMO.toastTitle == "" ? undefined : global.UI_DEMO.toastTitle;
        ui_toast_warning(global.UI_DEMO.toastMessage, title, duration);
    });
    rowSpawners.add(btnWarning);
    
    var btnError = new UiButton("Error", { marginRight: 10, marginBottom: 8, height: 34 }, { variant: "danger" });
    btnError.onClick(function() {
        var duration = real(global.UI_DEMO.toastDuration == "" ? "0" : global.UI_DEMO.toastDuration);
        var title = global.UI_DEMO.toastTitle == "" ? undefined : global.UI_DEMO.toastTitle;
        ui_toast_error(global.UI_DEMO.toastMessage, title, duration);
    });
    rowSpawners.add(btnError);
    
    // Actions Section
    __ui_demo_preview_section(PreviewCard, "Actions");
    var btnClear = new UiButton("Dismiss All Toasts", { height: 34, marginBottom: 40 }, { variant: "secondary" });
    btnClear.onClick(function() {
        if (global.UiToastInstance != undefined && !global.UiToastInstance.destroyed) {
            global.UiToastInstance.destroyChildren();
            global.UI.requestUpdate();
        }
    });
    PreviewCard.add(btnClear);
    
    return [
        "// Spawning different types of toast notifications",
        "// (Toasts stack top-right, newest on top)",
        "",
        "// 1. Spawning basic Info toast",
        "ui_toast_info(\"System is running normally.\");",
        "",
        "// 2. Spawning Success toast with bold title and 4-second timeout",
        "ui_toast_success(\"Data saved successfully!\", \"Success\", 4000);",
        "",
        "// 3. Spawning Warning toast with custom timeout",
        "ui_toast_warning(\"Your session will expire soon.\", \"Warning\", 5000);",
        "",
        "// 4. Spawning Error toast with 6-second timeout",
        "ui_toast_error(\"Could not upload file.\", \"Error\", 6000);",
        "",
        "// 5. Dismiss all active toasts programmatically",
        "if (global.UiToastInstance != undefined) {",
        "    global.UiToastInstance.destroyChildren();",
        "}"
    ];
}
