function ui_demo_example_introduction(PreviewCard) {
    // --- 1. UiRoot & UiNode Overview ---
    __ui_demo_preview_section(PreviewCard, "Core Concepts: UiRoot & UiNode");
    
    PreviewCard.add(new UiText(
        "UniqueUI is built on a hierarchical tree structure of elements. " +
        "At the top of the hierarchy sits UiRoot (instantiated globally as global.UI), which handles window resizing, " +
        "input propagation, rendering to a surface, and focus management.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_DIM, wrap: true }
    ));
    
    PreviewCard.add(new UiText(
        "Every element in the UI (including containers, buttons, and text fields) inherits from UiNode. " +
        "A UiNode defines coordinates (x1, y1, x2, y2), flexbox layout configuration, and event listeners.",
        { width: "100%", marginBottom: 28 },
        { color: global.UI_COL_TEXT_DIM, wrap: true }
    ));
    
    // --- 2. Containers and Nesting ---
    __ui_demo_preview_section(PreviewCard, "Containers & Nesting");
    
    PreviewCard.add(new UiText(
        "You can easily nest nodes inside other nodes using parent.add(child) to create nested structures and layouts. " +
        "The following interactive card represents a container node holding a title and a horizontal row of buttons.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_DIM, wrap: true }
    ));
    
    // Container Demo
    var demoContainer = new UiNode({
        width: "100%",
        padding: 16,
        flexDirection: "column",
        marginBottom: 28
    });
    demoContainer.onDraw = method(demoContainer, function() {
        draw_set_color(global.UI_COL_BG_MAIN);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    
    demoContainer.add(new UiText("Parent Container (UiNode)", { marginBottom: 12 }, { color: global.UI_COL_TEXT_MAIN, font: fTextBig }));
    
    var rowContainer = new UiNode({
        flexDirection: "row",
        width: "100%"
    });
    rowContainer.add(new UiButton("Child Button A", { marginRight: 12, height: 32 }, { variant: "primary" }));
    rowContainer.add(new UiButton("Child Button B", { height: 32 }, { variant: "outline" }));
    
    demoContainer.add(rowContainer);
    PreviewCard.add(demoContainer);
    
    // --- 3. Custom Drawing (onDraw) ---
    __ui_demo_preview_section(PreviewCard, "Custom Drawing (onDraw)");
    
    PreviewCard.add(new UiText(
        "By assigning a function to the onDraw callback, you can draw whatever you like using GameMaker's " +
        "standard drawing functions. Inside the bound callback, self.x1, self.y1, self.x2, and self.y2 correspond " +
        "to the layout bounds calculated by the library.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_DIM, wrap: true }
    ));
    
    // Gradient custom drawing demo
    var customDrawNode = new UiNode({
        width: "100%",
        height: 60,
        marginBottom: 28,
        justifyContent: "center",
        alignItems: "center"
    });
    customDrawNode.onDraw = method(customDrawNode, function() {
        // Draw a beautiful smooth horizontal gradient
        draw_rectangle_color(self.x1, self.y1, self.x2, self.y2, #6366F1, #3B82F6, #3B82F6, #6366F1, false);
        
        // Draw an elegant inner border
        draw_set_color(#FFFFFF);
        draw_set_alpha(0.15);
        draw_rectangle(self.x1 + 3, self.y1 + 3, self.x2 - 3, self.y2 - 3, true);
        draw_set_alpha(1.0);
    });
    customDrawNode.add(new UiText("Custom Gradient drawn inside onDraw", {}, { color: c_white, font: fTextSmall }));
    PreviewCard.add(customDrawNode);
    
    // --- 4. Event Handling ---
    __ui_demo_preview_section(PreviewCard, "Event Handling & Reactivity");
    
    PreviewCard.add(new UiText(
        "Registering handlers for events like mouse clicks or hovers is straightforward. " +
        "Use methods like onClick(callback) or addEventListener(event_type, callback). " +
        "Try clicking the button below to see the click count update reactively via a valueGetter function.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_DIM, wrap: true }
    ));
    
    // Interactive event demo
    var eventContainer = new UiNode({
        width: "100%",
        flexDirection: "row",
        alignItems: "center",
        padding: 16,
        marginBottom: 12
    });
    eventContainer.onDraw = method(eventContainer, function() {
        draw_set_color(global.UI_COL_BG_MAIN);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    
    var clickState = {
        count: 0
    };
    
    var eventBtn = new UiButton("Click to Trigger", { marginRight: 16, height: 36 }, { variant: "success" });
    eventBtn.onClick(method(clickState, function() {
        self.count += 1;
    }));
    
    var counterText = new UiText("Clicks: 0", {}, {
        color: global.UI_COL_TEXT_MAIN,
        font: fTextBig,
        valueGetter: method(clickState, function() {
            return "Clicks: " + string(self.count);
        })
    });
    
    eventContainer.add(eventBtn);
    eventContainer.add(counterText);
    PreviewCard.add(eventContainer);
    
    return [
        "// === 1. CREATING A CONTAINER & NESTING CHILDREN ===",
        "var myCard = new UiNode({",
        "    width: \"100%\",",
        "    padding: 16,",
        "    flexDirection: \"column\"",
        "});",
        "myCard.onDraw = method(myCard, function() {",
        "    draw_set_color(global.UI_COL_BG_CARD);",
        "    draw_roundrect_ext(x1, y1, x2, y2, 8, 8, false);",
        "});",
        "",
        "var text = new UiText(\"Hello Parent!\", {}, { color: \"main\" });",
        "var button = new UiButton(\"Child Button\", { height: 32 });",
        "",
        "myCard.add(text);",
        "myCard.add(button); // Added as children",
        "global.UI.add(myCard);",
        "",
        "// === 2. CUSTOM DRAWING (onDraw) ===",
        "var customNode = new UiNode({ width: \"100%\", height: 60 });",
        "customNode.onDraw = method(customNode, function() {",
        "    // Draw a custom horizontal gradient color block",
        "    draw_rectangle_color(x1, y1, x2, y2,",
        "                         #6366F1, #3B82F6,",
        "                         #3B82F6, #6366F1, false);",
        "});",
        "",
        "// === 3. EVENT HANDLING ===",
        "button.onClick(function() {",
        "    show_debug_message(\"Button was clicked!\");",
        "});",
        "",
        "// === 4. REACTIVE LABELS USING valueGetter ===",
        "var clickState = { count: 0 };",
        "button.onClick(method(clickState, function() {",
        "    self.count++;",
        "}));",
        "",
        "var reactiveLabel = new UiText(\"Clicks: 0\", {}, {",
        "    valueGetter: method(clickState, function() {",
        "        return \"Clicks: \" + string(self.count);",
        "    })",
        "});"
    ];
}
