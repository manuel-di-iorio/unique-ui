function ui_demo_example_introduction(PreviewCard) {
    // --- 1. UiRoot & UiNode Overview ---
    __ui_demo_preview_section(PreviewCard, "Core Concepts: UiRoot & UiNode");
    
    PreviewCard.add(new UiText(
        "UniqueUI is built on a hierarchical tree structure of elements. " +
        "At the top of the hierarchy sits UiRoot (instantiated globally as global.UI), which handles window resizing, " +
        "input propagation, rendering to a surface, and focus management.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));
    
    PreviewCard.add(new UiText(
        "Every element in the UI (including containers, buttons, and text fields) inherits from UiNode. " +
        "A UiNode defines coordinates (x1, y1, x2, y2), flexbox layout configuration, and event listeners.",
        { width: "100%", marginBottom: 28 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));
    
    // --- 2. Containers and Nesting ---
    __ui_demo_preview_section(PreviewCard, "Containers & Nesting");
    
    PreviewCard.add(new UiText(
        "You can easily nest nodes inside other nodes using parent.add(child) to create nested structures and layouts. " +
        "The following interactive card represents a container node holding a title and a horizontal row of buttons.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));
    
    // Container Demo
    var demoContainer = new UiNode({
        width: "100%",
        padding: 16,
        flexDirection: "column",
        marginBottom: 28
    });
    demoContainer.onDraw = method(demoContainer, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    
    demoContainer.add(new UiText("Parent Container (UiNode)", { marginBottom: 12 }, { color: global.UI_COL_TEXT_1, font: global.UI_FONTS.big }));
    
    var rowContainer = new UiNode({
        flexDirection: "row",
        width: "100%"
    });
    rowContainer.add(new UiButton("Child Button A", { marginRight: 12, height: 32 }, { variant: "primary" }));
    rowContainer.add(new UiButton("Child Button B", { height: 32 }, { variant: "outline" }));
    
    demoContainer.add(rowContainer);
    PreviewCard.add(demoContainer);
    
    // --- 3. Pointer Events & Propagation ---
    __ui_demo_preview_section(PreviewCard, "Pointer Events & Interaction");
    
    PreviewCard.add(new UiText(
        "For a node to intercept mouse input, you must set pointerEvents: true in its property constructor (or set it manually on the instance). " +
        "Nodes with pointerEvents: false are invisible to mouse detection, allowing mouse clicks and hovers to pass straight through them to elements underneath.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    PreviewCard.add(new UiText(
        "Event handlers (like onClick, onMouseEnter, etc.) trigger event propagation. Bubble-capable events propagate up from the deepest hovered target to its parent nodes.",
        { width: "100%", marginBottom: 28 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    // --- 4. Custom Drawing (onDraw) ---
    __ui_demo_preview_section(PreviewCard, "Custom Drawing (onDraw)");
    
    PreviewCard.add(new UiText(
        "By assigning a function to the onDraw callback, you can draw whatever you like using GameMaker's " +
        "standard drawing functions. Inside the bound callback, self.x1, self.y1, self.x2, and self.y2 correspond " +
        "to the layout bounds calculated by the library.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
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
    customDrawNode.add(new UiText("Custom Gradient drawn inside onDraw", {}, { color: c_white, font: global.UI_FONTS.small }));
    PreviewCard.add(customDrawNode);
    
    // --- 5. Drag & Drop ---
    __ui_demo_preview_section(PreviewCard, "Drag & Drop Operations");
    
    PreviewCard.add(new UiText(
        "Natively support dragging elements and dropping them onto targeted zones: \n" +
        "- Set draggable: true to enable dragging a node. When dragged, self.dragging becomes true.\n" +
        "- Set dropzone: true on target nodes, and define onDrop = function(draggedNode) to handle the drop event.\n" +
        "Drag and drop any of the blue boxes below and drop them onto the target container!",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    // Drag & drop interactive demo
    var dragDropContainer = new UiNode({
        width: "100%",
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        padding: 16,
        marginBottom: 28
    });
    dragDropContainer.onDraw = method(dragDropContainer, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });

    var dragNode1 = new UiNode({ width: 80, height: 40, justifyContent: "center", alignItems: "center" }, { pointerEvents: true, draggable: true, handpoint: true });
    dragNode1.onDraw = method(dragNode1, function() {
        draw_set_color(self.dragging ? #818CF8 : #3B82F6);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
        draw_set_color(c_white); draw_set_font(global.UI_FONTS.small); draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.dragging ? "Dragging" : "Drag Me A");
    });

    var dragNode2 = new UiNode({ width: 80, height: 40, justifyContent: "center", alignItems: "center" }, { pointerEvents: true, draggable: true, handpoint: true });
    dragNode2.onDraw = method(dragNode2, function() {
        draw_set_color(self.dragging ? #818CF8 : #3B82F6);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
        draw_set_color(c_white); draw_set_font(global.UI_FONTS.small); draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.dragging ? "Dragging" : "Drag Me B");
    });

    var dropZoneNode = new UiNode({ width: 140, height: 50, justifyContent: "center", alignItems: "center" }, { pointerEvents: true, dropzone: true });
    dropZoneNode.__statusText = "Dropzone";
    dropZoneNode.onDrop = method(dropZoneNode, function(draggedNode) {
        if (variable_struct_exists(draggedNode, "parent") && draggedNode.parent != undefined) {
            var label = "Dropped!";
            if (variable_struct_exists(draggedNode, "children") && array_length(draggedNode.children) > 0) {
                label = draggedNode.children[0].value;
            }
            self.__statusText = "Received: " + label;
            global.UI.requestRedraw();
        }
    });
    dropZoneNode.onDraw = method(dropZoneNode, function() {
        draw_set_color(#10B981);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 6, 6, false);
        draw_set_color(c_white); draw_set_font(global.UI_FONTS.small); draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.__statusText);
    });

    dragDropContainer.add(dragNode1);
    dragDropContainer.add(dragNode2);
    dragDropContainer.add(dropZoneNode);
    PreviewCard.add(dragDropContainer);

    // --- 6. UI Update vs Redraw Lifecycle ---
    __ui_demo_preview_section(PreviewCard, "Lifecycle: Automatic vs. Manual Updates");
    
    PreviewCard.add(new UiText(
        "To achieve maximum performance, UniqueUI separates structural layout computations from visual rendering. " +
        "Crucially, the library automatically handles these updates for you in most cases:\n" +
        "- Built-in layout methods (such as setSize(), add(), remove(), show(), and hide()) automatically trigger a layout update and repaint. You DO NOT need to call requestUpdate() manually for these actions.\n" +
        "- State changes (like mouse hovering or text changes in responsive labels) automatically request a redraw. You only need to call global.UI.requestRedraw() manually when you modify custom variables in your drawing code (e.g., toggling a custom selected color or changing a state flag in custom event handlers).",
        { width: "100%", marginBottom: 28 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    // --- 7. Push-Based Reactivity (value / setValue / onChange) ---
    __ui_demo_preview_section(PreviewCard, "Push-Based Reactivity: value, setValue, onChange");
    
    PreviewCard.add(new UiText(
        "Every UiNode has a generic value property and a built-in push-based notification system " +
        "independent of UiStore:\n" +
        "- self.value - stores any type (string, number, boolean, color)\n" +
        "- setValue(newValue) - updates value, fires onChange listeners, calls requestRedraw()\n" +
        "- onChange(cb) - registers a listener; multiple listeners are supported\n\n" +
        "This enables direct reactive data flow between components without polling.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));
    
    // Push-based demo: checkbox controls a text label directly
    var pushDemoRow = new UiNode({
        width: "100%",
        flexDirection: "row",
        alignItems: "center",
        padding: 16,
        marginBottom: 12
    });
    pushDemoRow.onDraw = method(pushDemoRow, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    
    var pushLabel = new UiText("Toggle me", { }, {
        color: global.UI_COL_TEXT_1,
        font: global.UI_FONTS.big
    });
    
    var pushCheckbox = new UiCheckbox({ marginRight: 16 }, {
        label: "Push-based demo",
        onChange: method(pushLabel, function(val) {
            self.setValue(val ? "Checked!" : "Unchecked!");
        })
    });
    
    pushDemoRow.add(pushCheckbox);
    pushDemoRow.add(pushLabel);
    PreviewCard.add(pushDemoRow);
    
    // --- 8. Event Handling & UiStore Reactivity ---
    __ui_demo_preview_section(PreviewCard, "Event Handling & UiStore Reactivity");
    
    PreviewCard.add(new UiText(
        "Registering handlers for events like mouse clicks or hovers is straightforward. " +
        "Use methods like onClick(callback) or addEventListener(event_type, callback). " +
        "UiStore extends the push-based pattern to shared state: when you call store.set(), " +
        "all subscribers fire immediately.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));
    
    // Interactive event demo - UiStore-powered
    var eventContainer = new UiNode({
        width: "100%",
        flexDirection: "row",
        alignItems: "center",
        padding: 16,
        marginBottom: 28
    });
    eventContainer.onDraw = method(eventContainer, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    
    // Create a reactive store for this demo
    var clickStore = new UiStore({ count: 0 });
    
    var counterText = new UiText("Clicks: 0", {}, {
        color: global.UI_COL_TEXT_1,
        font: global.UI_FONTS.big
    });
    
    // Subscribe the label to store changes
    clickStore.subscribe(method(counterText, function(state) {
        self.value = "Clicks: " + string(state.count);
    }));
    
    var eventBtn = new UiButton("Click to Trigger", { marginRight: 16, height: 36 }, { variant: "success" });
    eventBtn.onClick(method(clickStore, function() {
        self.set({ "count": self.get("count") + 1 });
    }));
    
    eventContainer.add(eventBtn);
    eventContainer.add(counterText);
    PreviewCard.add(eventContainer);
    
    // --- 8. Scrollable Container ---
    __ui_demo_preview_section(PreviewCard, "Scrollable Container");
    
    PreviewCard.add(new UiText(
        "When content overflows a container, you can enable vertical (and horizontal) scrollbars. " +
        "The scrollbar automatically appears when content exceeds the container bounds " +
        "and supports mouse wheel scrolling and thumb dragging.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));
    
    var scrollDemo = new UiNode({
        width: "100%",
        height: 200,
        flexDirection: "column",
        padding: 8,
        marginBottom: 12
    });
    scrollDemo.enableScrollbar(global.UI_COL_SCROLLBAR);
    scrollDemo.onDraw = method(scrollDemo, function() {
        draw_set_color(global.UI_COL_SURFACE_3);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });
    
    for (var i = 1; i <= 20; i++) {
        var row = new UiNode({ width: "100%", height: 24, marginBottom: 2, paddingLeft: 12, justifyContent: "center" });
        row.onDraw = method(row, function() {
            draw_set_color(c_white);
            draw_set_alpha(0.06);
            draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 4, 4, false);
            draw_set_alpha(1);
            draw_set_color(global.UI_COL_TEXT_2);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(self.x1 + 8, ~~mean(self.y1, self.y2), self.__label);
        });
        row.__label = "Item #" + string(i);
        scrollDemo.add(row);
    }
    
    PreviewCard.add(scrollDemo);
    
    return [
        "// === 1. CONTAINERS & NESTING ===",
        "var myCard = new UiNode({ width: \"100%\", padding: 16 });",
        "myCard.add(new UiButton(\"Child Button\", { height: 32 }));",
        "global.UI.add(myCard);",
        "",
        "// === 2. LIFECYCLE (AUTOMATIC VS MANUAL UPDATES) ===",
        "node.setSize(200, 50); // requestUpdate() + redraw - automatic!",
        "node.hide();           // requestUpdate() + redraw - automatic!",
        "",
        "// Call requestRedraw() manually only for custom onDraw variables:",
        "node.customColor = #EF4444;",
        "global.UI.requestRedraw();",
        "", 
        "// === 3. POINTER EVENTS ===",
        "// Block input / handle clicks",
        "var node = new UiNode({ width: 100 }, { pointerEvents: true });",
        "// Let clicks pass through",
        "var overlay = new UiNode({ width: 100 }, { pointerEvents: false });",
        "",
        "// === 4. DRAG & DROP ===",
        "var dragNode = new UiNode({ width: 60 }, {",
        "    pointerEvents: true,",
        "    draggable: true",
        "});",
        "var dropTarget = new UiNode({ width: 100 }, {",
        "    pointerEvents: true,",
        "    dropzone: true",
        "});",
        "dropTarget.onDrop = function(draggedNode) {",
        "    show_debug_message(\"Dropped: \" + string(draggedNode.id));",
        "};",
        "",   
        "// === 5. PUSH-BASED REACTIVITY (value / setValue / onChange) ===",
        "// Every UiNode has a reactive value system built in:",
        "node.setValue(newValue);  // updates value + fires onChange + requestRedraw",
        "node.onChange(cb);        // register a value change listener",
        "",
        "// === 6. REACTIVE STATE (UiStore) ===",
        "// Create a store with initial state",
        "var store = new UiStore({ count: 0 });",
        "",
        "// Subscribe - fires immediately when state changes",
        "store.subscribe(method(myLabel, function(state) {",
        "    self.value = \"Clicks: \" + string(state.count);",
        "}));",
        "",
        "// Update state - all subscribers are notified automatically",
        "myButton.onClick(function() {",
        "    store.set({ count: store.get(\"count\") + 1 });",
        "});",
        "",
        "// Batch-update multiple keys in one notification",
        "store.set({ count: 0, label: \"Reset\" });",
        "",
        "// === 7. SCROLLABLE CONTAINER ===",
        "var container = new UiNode({ width: \"100%\", height: 200, flexDirection: \"column\" });",
        "container.enableScrollbar(global.UI_COL_SCROLLBAR);",
        "for (var i = 0; i < 20; i++) {",
        "    container.add(new UiText(\"Item \" + string(i)));",
        "}",
        "parent.add(container);",
    ];
}
