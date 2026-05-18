function ui_demo_example_badge(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Variants");
    var row1 = new UiNode({ flexDirection: "row", flexWrap: "wrap", marginBottom: 32, alignItems: "center" });
    PreviewCard.add(row1);
    row1.add(new UiBadge("Default",  { marginRight: 8 }, { variant: "default"  }));
    row1.add(new UiBadge("Primary",  { marginRight: 8 }, { variant: "primary"  }));
    row1.add(new UiBadge("Success",  { marginRight: 8 }, { variant: "success"  }));
    row1.add(new UiBadge("Warning",  { marginRight: 8 }, { variant: "warning"  }));
    row1.add(new UiBadge("Danger",   { marginRight: 8 }, { variant: "danger"   }));
    row1.add(new UiBadge("Info",     {},                 { variant: "info"     }));
    
    __ui_demo_preview_section(PreviewCard, "Dot Indicators");
    var row2 = new UiNode({ flexDirection: "row", alignItems: "center", marginBottom: 32, flexWrap: "wrap" });
    PreviewCard.add(row2);
    var dotVariants = ["primary", "success", "warning", "danger", "info"];
    for (var i = 0; i < array_length(dotVariants); i++) {
        row2.add(new UiBadge("", { marginRight: 12 }, { variant: dotVariants[i], dot: true }));
    }
    
    __ui_demo_preview_section(PreviewCard, "Inline with Text");
    var row3 = new UiNode({ flexDirection: "row", alignItems: "center", flexWrap: "wrap" });
    PreviewCard.add(row3);
    row3.add(new UiText("System Status", { marginRight: 10 }, { color: global.UI_COL_TEXT_MAIN }));
    row3.add(new UiBadge("Online", {}, { variant: "success" }));
    
    return [
        "new UiBadge(\"Default\",  {}, { variant: \"default\"  });",
        "new UiBadge(\"Success\",  {}, { variant: \"success\"  });",
        "new UiBadge(\"Warning\",  {}, { variant: \"warning\"  });",
        "new UiBadge(\"Danger\",   {}, { variant: \"danger\"   });",
        "",
        "// Dot indicator",
        "new UiBadge(\"\", { marginRight: 8 }, { variant: \"success\", dot: true });"
    ];
}
