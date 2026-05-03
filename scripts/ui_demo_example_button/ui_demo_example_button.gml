function ui_demo_example_button(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Variants");
    var row1 = new UiNode({ flexDirection: "row", marginBottom: 32, flexWrap: "wrap", alignItems: "center" });
    PreviewCard.add(row1);
    row1.add(new UiButton("Primary",   { marginRight: 12, marginBottom: 8 }, { variant: "primary"   }));
    row1.add(new UiButton("Secondary", { marginRight: 12, marginBottom: 8 }, { variant: "secondary" }));
    row1.add(new UiButton("Outline",   { marginRight: 12, marginBottom: 8 }, { variant: "outline"   }));
    row1.add(new UiButton("Ghost",     { marginRight: 12, marginBottom: 8 }, { variant: "ghost"     }));
    row1.add(new UiButton("Danger",    { marginBottom: 8 },                  { variant: "danger"    }));
    
    __ui_demo_preview_section(PreviewCard, "Sizes");
    var row2 = new UiNode({ flexDirection: "row", alignItems: "center", marginBottom: 32, flexWrap: "wrap" });
    PreviewCard.add(row2);
    row2.add(new UiButton("Small",  { height: 28, marginRight: 12 }, { variant: "outline"  }));
    row2.add(new UiButton("Medium", { height: 36, marginRight: 12 }, { variant: "primary"  }));
    row2.add(new UiButton("Large",  { height: 44 },                  { variant: "outline"  }));
    
    __ui_demo_preview_section(PreviewCard, "Text Alignment");
    var row3 = new UiNode({ flexDirection: "column", marginBottom: 32 });
    PreviewCard.add(row3);
    row3.add(new UiButton("Left Aligned",   { width: "100%", height: 36, marginBottom: 8 }, { variant: "outline", halign: fa_left   }));
    row3.add(new UiButton("Center Aligned", { width: "100%", height: 36, marginBottom: 8 }, { variant: "outline", halign: fa_center }));
    row3.add(new UiButton("Right Aligned",  { width: "100%", height: 36 },                  { variant: "outline", halign: fa_right  }));
    
    __ui_demo_preview_section(PreviewCard, "Interactive - Toggle");
    if (!variable_struct_exists(global.UI_DEMO, "btnToggle")) global.UI_DEMO.btnToggle = false;
    var toggleBtn = new UiButton(
        global.UI_DEMO.btnToggle ? "Enabled" : "Disabled",
        { width: 160, height: 36, marginBottom: 16 },
        { variant: global.UI_DEMO.btnToggle ? "primary" : "secondary" }
    );
    toggleBtn.onClick(method({ toggleBtn }, function() {
        global.UI_DEMO.btnToggle = !global.UI_DEMO.btnToggle;
        toggleBtn.setText(global.UI_DEMO.btnToggle ? "Enabled" : "Disabled");
        toggleBtn.variant = global.UI_DEMO.btnToggle ? "primary" : "secondary";
    }));
    PreviewCard.add(toggleBtn);
    
    return [
        "new UiButton(\"Primary\",   {}, { variant: \"primary\"   });",
        "new UiButton(\"Secondary\", {}, { variant: \"secondary\" });",
        "new UiButton(\"Outline\",   {}, { variant: \"outline\"   });",
        "new UiButton(\"Ghost\",     {}, { variant: \"ghost\"     });",
        "new UiButton(\"Danger\",    {}, { variant: \"danger\"    });",
        "",
        "// Sizes via style.height",
        "new UiButton(\"Small\",  { height: 28 }, { variant: \"outline\" });",
        "new UiButton(\"Medium\", { height: 36 }, { variant: \"primary\" });",
        "new UiButton(\"Large\",  { height: 44 }, { variant: \"outline\" });",
        "",
        "// Alignment via props.halign",
        "new UiButton(\"Left\", { width: \"100%\" }, { variant: \"outline\", halign: fa_left });"
    ];
}
