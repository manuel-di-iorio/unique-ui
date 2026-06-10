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
    
    __ui_demo_preview_section(PreviewCard, "Disabled State");
    var row4 = new UiNode({ flexDirection: "row", flexWrap: "wrap", alignItems: "center", marginBottom: 32 });
    PreviewCard.add(row4);
    
    var disabledPrimary = new UiButton("Disabled Primary", { marginRight: 12, marginBottom: 8 }, { variant: "primary" });
    disabledPrimary.setDisabled(true);
    row4.add(disabledPrimary);
    
    var disabledSecondary = new UiButton("Disabled Secondary", { marginRight: 12, marginBottom: 8 }, { variant: "secondary" });
    disabledSecondary.setDisabled(true);
    row4.add(disabledSecondary);
    
    var disabledOutline = new UiButton("Disabled Outline", { marginRight: 12, marginBottom: 8 }, { variant: "outline" });
    disabledOutline.setDisabled(true);
    row4.add(disabledOutline);
    
    __ui_demo_preview_section(PreviewCard, "Sprite Buttons");
    var row5 = new UiNode({ flexDirection: "row", flexWrap: "wrap", alignItems: "center", marginBottom: 32 });
    PreviewCard.add(row5);
    
    // Sprite button (copy icon)
    var spriteBtn = new UiButton(sprUiIconCopy, { marginRight: 12, marginBottom: 8 }, { variant: "primary" });
    row5.add(spriteBtn);
    
    // Sprite button + label
    var spriteLabelBtn = new UiButton(sprUiIconCopy, { marginRight: 12, marginBottom: 8 }, { variant: "secondary", label: "Copy" });
    row5.add(spriteLabelBtn);
    
    // Sprite button with custom size
    var smallSpriteBtn = new UiButton(sprUiIconCopy, { marginRight: 12, marginBottom: 8 }, { variant: "outline", spriteWidth: 16, spriteHeight: 16 });
    row5.add(smallSpriteBtn);
    
    // Sprite button + label with custom size
    var smallSpriteLabelBtn = new UiButton(sprUiIconCopy, { marginRight: 12, marginBottom: 8 }, { variant: "ghost", label: "Copy", spriteWidth: 18, spriteHeight: 18 });
    row5.add(smallSpriteLabelBtn);
    
    // Disabled sprite button
    var disabledSpriteBtn = new UiButton(sprUiIconCopy, { marginRight: 12, marginBottom: 8 }, { variant: "primary" });
    disabledSpriteBtn.setDisabled(true);
    row5.add(disabledSpriteBtn);
    
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
    
    __ui_demo_preview_section(PreviewCard, "Interactive - Enable/Disable");
    if (!variable_struct_exists(global.UI_DEMO, "enableDisableBtnState")) global.UI_DEMO.enableDisableBtnState = true;
    var row5 = new UiNode({ flexDirection: "row", alignItems: "center", marginBottom: 16 });
    PreviewCard.add(row5);
    
    var targetBtn = new UiButton("Target Button", { width: 160, height: 36, marginRight: 12 }, { variant: "primary" });
    if (!global.UI_DEMO.enableDisableBtnState) targetBtn.setDisabled(true);
    row5.add(targetBtn);
    
    var toggleEnableBtn = new UiButton(
        global.UI_DEMO.enableDisableBtnState ? "Disable" : "Enable",
        { width: 120, height: 36 },
        { variant: "outline" }
    );
    toggleEnableBtn.onClick(method({ targetBtn, toggleEnableBtn }, function() {
        global.UI_DEMO.enableDisableBtnState = !global.UI_DEMO.enableDisableBtnState;
        targetBtn.setDisabled(!global.UI_DEMO.enableDisableBtnState);
        toggleEnableBtn.setText(global.UI_DEMO.enableDisableBtnState ? "Disable" : "Enable");
    }));
    row5.add(toggleEnableBtn);
    
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
        "new UiButton(\"Left\", { width: \"100%\" }, { variant: \"outline\", halign: fa_left });",
        "",
        "// Sprite button (icon only)",
        "new UiButton(sprUiIconCopy, {}, { variant: \"primary\" });",
        "",
        "// Sprite button + label",
        "new UiButton(sprUiIconCopy, {}, { variant: \"secondary\", label: \"Copy\" });",
        "",
        "// Sprite button with custom dimensions",
        "new UiButton(sprUiIconCopy, {}, { variant: \"outline\", spriteWidth: 16, spriteHeight: 16 });",
        "",
        "// Disabled button",
        "var btn = new UiButton(\"Disabled\", {}, { variant: \"primary\" });",
        "btn.setDisabled(true);",
    ];
}
