function ui_demo_example_alert(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Types");
    PreviewCard.add(new UiAlert("Your information has been saved successfully.", { marginBottom: 12 }, { type: "success", title: "Success" }));
    PreviewCard.add(new UiAlert("New update available. Restart to apply changes.", { marginBottom: 12 }, { type: "info", title: "Update Available" }));
    PreviewCard.add(new UiAlert("Storage is almost full. Free up some space.", { marginBottom: 12 }, { type: "warning", title: "Warning" }));
    PreviewCard.add(new UiAlert("Connection to the server failed. Please retry.", { marginBottom: 32 }, { type: "error", title: "Error" }));
    
    __ui_demo_preview_section(PreviewCard, "Without Title");
    PreviewCard.add(new UiAlert("A simple notification without a title.", { marginBottom: 12 }, { type: "info" }));
    PreviewCard.add(new UiAlert("Operation completed.", { marginBottom: 32 }, { type: "success" }));
    
    __ui_demo_preview_section(PreviewCard, "Dismissible");
    PreviewCard.add(new UiAlert("Click × to dismiss this alert.", { marginBottom: 12 }, {
        type: "warning",
        title: "Dismissible Alert",
        dismissible: true
    }));
    
    return [
        "new UiAlert(\"Saved successfully.\", {}, { type: \"success\", title: \"Success\" });",
        "new UiAlert(\"Update available.\",   {}, { type: \"info\",    title: \"Info\"    });",
        "new UiAlert(\"Storage almost full.\",{}, { type: \"warning\", title: \"Warning\" });",
        "new UiAlert(\"Connection failed.\",  {}, { type: \"error\",   title: \"Error\"   });",
        "",
        "// Dismissible",
        "new UiAlert(\"Click × to close.\", {}, { type: \"warning\", dismissible: true });"
    ];
}
