function ui_demo_example_store(PreviewCard) {
    // --- Intro: value / setValue / onChange (push-based) ---
    PreviewCard.add(new UiText(
        "Every UiNode supports push-based reactive state via value, setValue(), and onChange(). " +
        "Components like UiText, UiSwitch, UiSlider, UiVirtualList all inherit these from UiNode.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    // --- Demo A: direct setValue() ---
    __ui_demo_preview_section(PreviewCard, "Direct setValue() - no store needed");

    var dirRow = new UiNode({
        width: "100%",
        flexDirection: "row",
        alignItems: "center",
        padding: 16,
        marginBottom: 28
    });
    dirRow.onDraw = method(dirRow, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });

    var state = { count: 0 };
    var dirLabel = new UiText("Clicks: 0", { marginRight: 16 }, { color: global.UI_COL_TEXT_1, font: global.UI_FONTS.big });
    var dirBtn = new UiButton("Click me", { height: 36 }, { variant: "primary" });
    dirBtn.onClick(method({ label: dirLabel, s: state }, function() {
        self.s.count++;
        self.label.setValue("Clicks: " + string(self.s.count));
    }));

    dirRow.add(dirLabel);
    dirRow.add(dirBtn);
    PreviewCard.add(dirRow);

    // --- Demo B: onChange listener ---
    __ui_demo_preview_section(PreviewCard, "onChange() listener");

    var onChangeRow = new UiNode({
        width: "100%",
        flexDirection: "column",
        padding: 16,
        marginBottom: 28
    });
    onChangeRow.onDraw = method(onChangeRow, function() {
        draw_set_color(global.UI_COL_SURFACE_0);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, false);
        draw_set_color(global.UI_COL_BORDER_1);
        draw_roundrect_ext(self.x1, self.y1, self.x2, self.y2, 8, 8, true);
    });

    var echoLabel = new UiText("Waiting…", { marginBottom: 8 }, { color: global.UI_COL_TEXT_2 });
    var echoInput = new UiTextbox({ width: 200, height: 32 }, {
        placeholder: "Type something…",
        onChange: method(echoLabel, function(val, _comp) {
            self.setValue(val != "" ? "You typed: " + val : "Waiting…");
        })
    });
    onChangeRow.add(echoInput);
    onChangeRow.add(echoLabel);
    PreviewCard.add(onChangeRow);

    // --- Demo C: UiStore with subscribe + setValue ---
    __ui_demo_preview_section(PreviewCard, "UiStore - subscribe() + setValue()");

    PreviewCard.add(new UiText(
        "UiStore is a lightweight reactive state container. Subscribe to changes and sync " +
        "components via setValue(). Write back via onChange.",
        { width: "100%", marginBottom: 12 },
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
        })
    });
    settingsStore.subscribe(method(statusLabel, function(state) {
        self.setValue(state.notifications ? "Notifications: On" : "Notifications: Off");
    }));

    var notifSwitch = new UiSwitch({ marginBottom: 16 }, {
        label: "Enable Notifications",
        value: settingsStore.get("notifications"),
        onChange: method(settingsStore, function(val) { self.set({ notifications: val }); })
    });
    settingsStore.subscribe(method(notifSwitch, function(state) {
        self.setValue(state.notifications);
    }));

    var volumeLabel = new UiText("Volume: " + string(settingsStore.get("volume")) + "%", { marginBottom: 8 });
    settingsStore.subscribe(method(volumeLabel, function(state) {
        self.setValue("Volume: " + string(state.volume) + "%");
    }));

    var volumeSlider = new UiSlider({ width: "100%", marginBottom: 8 }, {
        min: 0, max: 100, step: 5,
        value: settingsStore.get("volume"),
        onChange: method(settingsStore, function(val) { self.set({ volume: val }); })
    });
    settingsStore.subscribe(method(volumeSlider, function(state) {
        self.setValue(state.volume);
    }));

    syncCard.add(statusLabel);
    syncCard.add(notifSwitch);
    syncCard.add(volumeLabel);
    syncCard.add(volumeSlider);
    PreviewCard.add(syncCard);

    // --- API reference table ---
    __ui_demo_preview_section(PreviewCard, "UiStore API", 16);
    var apiGrid = new UiNode({ flexDirection: "column", width: "100%" });
    PreviewCard.add(apiGrid);
    __ui_demo_doc_row(apiGrid, "set(partial, replace?)", "method", "Merge or replace state, notify subscribers");
    __ui_demo_doc_row(apiGrid, "get(key, default?)", "method", "Read a value (returns default if missing)");
    __ui_demo_doc_row(apiGrid, "subscribe(cb)", "method", "Register callback on every state change");
    __ui_demo_doc_row(apiGrid, "reset()", "method", "Restore initial state snapshot");
    __ui_demo_doc_row(apiGrid, "has(key)", "method", "Check if a key exists in state");
    __ui_demo_doc_row(apiGrid, "remove(key)", "method", "Remove a key and notify subscribers");
    __ui_demo_doc_row(apiGrid, "use(middleware)", "method", "Add custom middleware (undo/redo, logging, etc.)");

    return [
        "// Push-based API: value / setValue / onChange",
        "var label = new UiText(\"Hello\", {});",
        "label.setValue(\"World\");",
        "",
        "label.onChange(function(val, component) {",
        "    show_debug_message(\"label changed to \" + val);",
        "});",
        "",
        "// UiStore - lightweight reactive state",
        "var store = new UiStore({ count: 0 });",
        "",
        "// Subscribe → setValue (store to component)",
        "store.subscribe(function(state) {",
        "    self.setValue(\"Count: \" + string(state.count));",
        "});",
        "",
        "// onChange → store.set() (component to store)",
        "var slider = new UiSlider({}, {",
        "    value: store.get(\"count\", 0),",
        "    onChange: function(val) {",
        "        store.set({ count: val });",
        "    }",
        "});",
        "",
        "store.set({ count: 5 });",
    ];
}
