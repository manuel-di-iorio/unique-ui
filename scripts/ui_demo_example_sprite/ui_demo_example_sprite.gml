function ui_demo_example_sprite(PreviewCard) {
    __ui_demo_preview_section(PreviewCard, "Example");
    PreviewCard.add(new UiSprite(sprDemo, { width: 64, height: 64 }));
    return ["new UiSprite(sprDemo, { width: 64, height: 64 });"];
}
