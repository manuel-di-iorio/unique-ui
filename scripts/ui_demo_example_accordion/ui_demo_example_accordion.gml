function ui_demo_example_accordion(PreviewCard) {
    var acc = new UiAccordion("Technical Details", { width: "100%" });
    acc.add(new UiText("These are the expandable details of the accordion component.", undefined, { color: #64748B }));
    PreviewCard.add(acc);
    return [
        "var acc = new UiAccordion(\"Technical Details\", { width: \"100%\" });",
        "acc.add(new UiText(\"Expandable content...\"));"
    ];
}
