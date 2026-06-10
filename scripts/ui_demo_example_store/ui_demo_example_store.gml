function ui_demo_example_store(PreviewCard) {
    // --- Intro ---
    PreviewCard.add(new UiText(
        "UiStore is a lightweight reactive state container. When you call set(), " +
        "all subscribers are notified immediately. " +
        "UiStore also calls global.UI.requestRedraw() so bound UI updates on the next frame.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    // --- Counter demo (subscribe) ---
    __ui_demo_preview_section(PreviewCard, "Subscribe & set()");

    var counterStore = new UiStore({ count: 0 });

    var counterRow = new UiNode({
        width: "100%",
        flexDirection: "row",
        alignItems: "center",
        padding: 16,
        marginBottom: 28
    });
    counterRow.onDraw = method(counterRow, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });

    var counterLabel = new UiText("Count: 0", { marginRight: 16 }, { color: global.UI_COL_TEXT_1, font: global.UI_FONTS.big });
    counterStore.subscribe(method(counterLabel, function(state) {
        self.text = "Count: " + string(state.count);
    }));

    var decBtn = new UiButton("-", { width: 40, height: 36, marginRight: 8 }, { variant: "outline" });
    decBtn.onClick(method(counterStore, function() {
        self.set({ count: self.get("count") - 1 });
    }));

    var incBtn = new UiButton("+", { width: 40, height: 36, marginRight: 16 }, { variant: "primary" });
    incBtn.onClick(method(counterStore, function() {
        self.set({ count: self.get("count") + 1 });
    }));

    counterRow.add(counterLabel);
    counterRow.add(decBtn);
    counterRow.add(incBtn);
    PreviewCard.add(counterRow);

    // --- Two-way sync demo ---
    __ui_demo_preview_section(PreviewCard, "Shared State (set & valueGetter)");

    PreviewCard.add(new UiText(
        "Multiple components can read and write the same store. Use valueGetter on inputs " +
        "for read binding, and onChange to write back with set().",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var settingsStore = new UiStore({ notifications: false, volume: 80 });

    var syncCard = new UiNode({
        width: "100%",
        flexDirection: "column",
        padding: 16,
        marginBottom: 28
    });
    syncCard.onDraw = method(syncCard, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });

    var statusLabel = new UiText("Notifications: Off", { marginBottom: 12 }, {
        color: method(settingsStore, function() {
            return self.get("notifications") ? #16A34A : global.UI_COL_TEXT_2;
        }),
        valueGetter: method(settingsStore, function() {
            return self.get("notifications") ? "Notifications: On" : "Notifications: Off";
        })
    });

    var notifSwitch = new UiSwitch({ marginBottom: 16 }, {
        label: "Enable Notifications",
        valueGetter: method(settingsStore, function() { return self.get("notifications"); }),
        onChange: method(settingsStore, function(val) { self.set({ notifications: val }); })
    });

    var volumeLabel = new UiText("Volume: 80%", { marginBottom: 8 }, {
        valueGetter: method(settingsStore, function() {
            return "Volume: " + string(self.get("volume")) + "%";
        })
    });

    var volumeSlider = new UiSlider({ width: "100%", marginBottom: 8 }, {
        min: 0, max: 100, step: 5,
        valueGetter: method(settingsStore, function() { return self.get("volume"); }),
        onChange: method(settingsStore, function(val) { self.set({ volume: val }); })
    });

    syncCard.add(statusLabel);
    syncCard.add(notifSwitch);
    syncCard.add(volumeLabel);
    syncCard.add(volumeSlider);
    PreviewCard.add(syncCard);

    // --- Batch & reset demo ---
    __ui_demo_preview_section(PreviewCard, "set(), reset() & Side Effects");

    PreviewCard.add(new UiText(
        "set() merges multiple keys in a single notification. reset() restores the initial " +
        "state snapshot. subscribe() is ideal for side effects, logging, or audio updates.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var batchStore = new UiStore({ label: "Ready", level: 1 });

    var batchRow = new UiNode({
        width: "100%",
        flexDirection: "row",
        alignItems: "center",
        flexWrap: "wrap",
        padding: 16,
        marginBottom: 12
    });
    batchRow.onDraw = method(batchRow, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });

    var batchLabel = new UiText("Ready - Level 1", { marginRight: 40, marginBottom: 8 }, { color: global.UI_COL_TEXT_1 });
    batchStore.subscribe(method(batchLabel, function(state) {
        self.text = state.label + " - Level " + string(state.level);
    }));

    var levelUpBtn = new UiButton("Level Up", { height: 34, marginRight: 8, marginBottom: 8 }, { variant: "primary" });
    levelUpBtn.onClick(method(batchStore, function() {
        self.set({ label: "Level Up!", level: self.get("level") + 1 });
    }));

    var resetBtn = new UiButton("Reset", { height: 34, marginBottom: 8 }, { variant: "outline" });
    resetBtn.onClick(method(batchStore, function() {
        self.reset();
    }));

    batchRow.add(batchLabel);
    batchRow.add(levelUpBtn);
    batchRow.add(resetBtn);
    PreviewCard.add(batchRow);

    // --- API reference table ---
    __ui_demo_preview_section(PreviewCard, "API Reference", 16);
    var apiGrid = new UiNode({ flexDirection: "column", width: "100%" });
    PreviewCard.add(apiGrid);
    __ui_demo_doc_row(apiGrid, "set(partial)", "method", "Update state (merge or replace with second param)");
    __ui_demo_doc_row(apiGrid, "get(key, default?)", "method", "Read a value (returns default if missing)");
    __ui_demo_doc_row(apiGrid, "has(key)", "method", "Check if a key exists in state");
    __ui_demo_doc_row(apiGrid, "remove(key)", "method", "Remove a key and notify subscribers");
    __ui_demo_doc_row(apiGrid, "reset()", "method", "Restore initial state and notify subscribers");
    __ui_demo_doc_row(apiGrid, "subscribe(cb)", "method", "Register callback on state changes");
    __ui_demo_doc_row(apiGrid, "use(middleware)", "method", "Add custom middleware (undo/redo, logging, etc.)");
    __ui_demo_doc_row(apiGrid, ".state", "variable", "Return the live state struct reference");

    return [
        "// Create a store with initial state",
        "var store = new UiStore({ count: 0, enabled: true });",
        "",
        "// Subscribe - fires when state changes",
        "store.subscribe(function(state) {",
        "    self.text = \"Count: \" + string(state.count);",
        "});",
        "",
        "// Update state (merge)",
        "store.set({ count: store.get(\"count\") + 1 });",
        "",
        "// Replace entire state",
        "store.set({ count: 0, enabled: false }, true);",
        "",
        "// Read / check / remove",
        "var val = store.get(\"count\", 0);",
        "if (store.has(\"enabled\")) store.remove(\"enabled\");",
        "",
        "// Reset to initial snapshot",
        "store.reset();",
        "",
        "// Unsubscribe when done",
        "var unsubscribe = store.subscribe(callback);",
        "unsubscribe();",
    ];
}
