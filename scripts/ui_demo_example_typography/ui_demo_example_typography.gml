function ui_demo_example_typography(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Fonts");
    PreviewCard.add(new UiText("Big", { marginBottom: 4, height: 42 }, { color: global.UI_COL_TEXT_MAIN, font: global.UI_FONTS.big }));
    PreviewCard.add(new UiText("Standard", { marginBottom: 4, height: 32 }, { color: global.UI_COL_TEXT_MAIN, font: global.UI_FONTS.standard }));
    PreviewCard.add(new UiText("Small", { marginBottom: 4, height: 24 }, { color: global.UI_COL_TEXT_DIM, font: global.UI_FONTS.small }));
    PreviewCard.add(new UiText("Italic", { marginBottom: 24, height: 24 }, { color: global.UI_COL_TEXT_DIM, font: global.UI_FONTS.italic }));
    
    __ui_demo_preview_section(PreviewCard, "Body Text");
    PreviewCard.add(new UiText("Design is not just what it looks like and feels like. Design is how it works. - Steve Jobs", { width: "100%", marginBottom: 12 }, { color: #64748B }));
    PreviewCard.add(new UiText("The quick brown fox jumps over the lazy dog.", { width: "100%" }, { color: #94A3B8, font: global.UI_FONTS.small }));
    
    __ui_demo_preview_section(PreviewCard, "Available Fonts", 40);
    var fontGrid = new UiNode({ flexDirection: "column", width: "100%" });
    PreviewCard.add(fontGrid);
    __ui_demo_doc_row(fontGrid, "fTextBig", "font", "Large font for headings (14pt)");
    __ui_demo_doc_row(fontGrid, "fText", "font", "Standard font (12pt)");
    __ui_demo_doc_row(fontGrid, "fTextSmall", "font", "Small font (11pt)");
    __ui_demo_doc_row(fontGrid, "fTextItalic", "font", "Italic font");
    
    return [
        "new UiText(\"Heading 1\", { height: 42 }, { font: global.UI_FONTS.big });",
        "new UiText(\"Heading 2\", { height: 32 }, { font: global.UI_FONTS.standard });",
        "new UiText(\"Heading 3\", { height: 24 }, { font: global.UI_FONTS.small });",
        "new UiText(\"Heading 4\", { height: 24 }, { font: global.UI_FONTS.italic });",
        "new UiText(\"Body Text\", { width: \"100%\" }, { color: #64748B });",
        "new UiText(\"Small\", { height: 20 }, { font: global.UI_FONTS.small });"
    ];
}
