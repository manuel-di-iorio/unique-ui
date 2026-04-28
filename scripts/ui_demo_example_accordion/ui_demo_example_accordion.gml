function ui_demo_example_accordion(PreviewCard) {
    var acc = new UiAccordion("Dettagli Tecnici", { width: "100%" });
    acc.add(new UiText("Questi sono i dettagli espandibili del componente accordion.", { height: 40 }, { color: #64748B }));
    PreviewCard.add(acc);
    return [
        "var acc = new UiAccordion(\"Dettagli Tecnici\", { width: \"100%\" });",
        "acc.add(new UiText(\"Contenuto espandibile...\", { height: 40 }));"
    ];
}
