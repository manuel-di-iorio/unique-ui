function ui_demo_example_virtualgrid(PreviewCard) {
    var ROW_GAP = 4;

    __ui_demo_preview_section(PreviewCard, "Basic grid - 1000 x 6 cells");
    PreviewCard.add(new UiText(
        "A UiVirtualGrid with 1000 rows and 6 columns. Only a small pool of rows exists in the tree; " +
        "cells are rebound as the user scrolls vertically. A horizontal scrollbar allows browsing wide columns.",
        { width: "100%", marginBottom: 12 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var dataBasic = [];
    for (var r = 0; r < 1000; r++) {
        var row = [];
        for (var c = 0; c < 6; c++) {
            array_push(row, { label: "R" + string(r + 1) + "/C" + string(c + 1), value: r * 6 + c });
        }
        array_push(dataBasic, row);
    }

    var HEADERS = ["ID", "Name", "Category", "Status", "Price", "Date"];

    var _renderCell = method({ ROW_GAP: ROW_GAP }, function(rowIndex, colIndex) {
        var cell = new UiNode({ width: 120, height: "100%", flexShrink: 0, justifyContent: "center", alignItems: "center" });
        cell.__ROW_GAP = self.ROW_GAP;
        cell.onDraw = method(cell, function() {
            var cy2 = self.y2 - self.__ROW_GAP;
            if (self.parent.hovered) {
                draw_set_color(global.UI_COL_HOVER);
                draw_rectangle(self.x1, self.y1, self.x2, cy2, false);
            }
            draw_set_color(global.UI_COL_TEXT_2);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(~~mean(self.x1, self.x2), ~~((self.y1 + cy2) / 2), self.__label ?? "");
        });
        return cell;
    });

    var _bindCell = method({ data: dataBasic }, function(rowIndex, colIndex, node) {
        node.__label = self.data[rowIndex][colIndex].label;
    });

    var grid = new UiVirtualGrid({ width: "100%", height: 360, marginBottom: 28 }, {
        value: dataBasic,
        estimatedRowHeight: 40 + ROW_GAP,
        estimatedColumnWidth: 120,
        numColumns: 6,
        renderCell: _renderCell,
        onBind: _bindCell,
        scrollbarColor: function() { return global.UI_COL_SCROLLBAR; }
    });

    // Header row sits above the grid
    var headerRow = new UiNode({ width: "100%", height: 32, flexDirection: "row", flexShrink: 0 });
    for (var c = 0; c < 6; c++) {
        var hcell = new UiNode({ width: 120, flexShrink: 0, height: "100%", justifyContent: "center", alignItems: "center" });
        hcell.__label = HEADERS[c];
        hcell.onDraw = method(hcell, function() {
            draw_set_color(global.UI_COL_SURFACE_3);
            draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
            draw_set_color(global.UI_COL_PRIMARY);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.__label);
        });
        headerRow.add(hcell);
    }
    PreviewCard.add(headerRow);
    PreviewCard.add(grid);

    __ui_demo_preview_section(PreviewCard, "Variable row height");
    PreviewCard.add(new UiText(
        "Rows cycle through 3 heights (40-80 px). The lazy offset cache adapts automatically.",
        { width: "100%", marginBottom: 16 },
        { color: global.UI_COL_TEXT_2, wrap: true }
    ));

    var dataVar = [];
    for (var r = 0; r < 200; r++) {
        var row = [];
        for (var c = 0; c < 4; c++) {
            array_push(row, { label: "Item " + string(r + 1) + "-" + string(c + 1), height: 40 + irandom(80) });
        }
        array_push(dataVar, row);
    }

    var _renderVar = method({ ROW_GAP: ROW_GAP }, function(rowIndex, colIndex) {
        var cell = new UiNode({ width: 150, height: "100%", flexShrink: 0, justifyContent: "center", alignItems: "center" });
        cell.__bg = colIndex % 2 == 0 ? global.UI_COL_SURFACE_2 : global.UI_COL_SURFACE_3;
        cell.__ROW_GAP = self.ROW_GAP;
        cell.onDraw = method(cell, function() {
            var cy2 = self.y2 - self.__ROW_GAP;
            draw_set_color(self.__bg);
            draw_rectangle(self.x1, self.y1, self.x2, cy2, false);
            if (self.parent.hovered) {
                draw_set_color(global.UI_COL_HOVER);
                draw_rectangle(self.x1, self.y1, self.x2, cy2, false);
            }
            draw_set_color(global.UI_COL_TEXT_2);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(~~mean(self.x1, self.x2), ~~((self.y1 + cy2) / 2), self.__label ?? "");
        });
        return cell;
    });

    var _bindVar = method({ data: dataVar, ROW_GAP: ROW_GAP }, function(rowIndex, colIndex, node) {
        node.__label = self.data[rowIndex][colIndex].label;
        if (colIndex == 0) {
            var h = self.data[rowIndex][0].height;
            node.parent.setHeight(h + self.ROW_GAP);
        }
    });

    var gridVar = new UiVirtualGrid({ width: "100%", height: 260, marginBottom: 28 }, {
        value: dataVar,
        estimatedRowHeight: 40 + ROW_GAP,
        estimatedColumnWidth: 150,
        numColumns: 4,
        renderCell: _renderVar,
        onBind: _bindVar,
        scrollbarColor: function() { return global.UI_COL_SCROLLBAR; }
    });

    var headerRow2 = new UiNode({ width: "100%", height: 32, flexDirection: "row", flexShrink: 0 });
    var VAR_HEADERS = ["Product", "Region", "Sales", "Rating"];
    for (var c = 0; c < 4; c++) {
        var hcell2 = new UiNode({ width: 150, flexShrink: 0, height: "100%", justifyContent: "center", alignItems: "center" });
        hcell2.__label = VAR_HEADERS[c];
        hcell2.onDraw = method(hcell2, function() {
            draw_set_color(global.UI_COL_SURFACE_3);
            draw_rectangle(self.x1, self.y1, self.x2, self.y2, false);
            draw_set_color(global.UI_COL_PRIMARY);
            draw_set_font(global.UI_FONTS.small);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(~~mean(self.x1, self.x2), ~~mean(self.y1, self.y2), self.__label);
        });
        headerRow2.add(hcell2);
    }
    PreviewCard.add(headerRow2);
    PreviewCard.add(gridVar);

    return [
        "// UiVirtualGrid - virtual scrolling grid",
        "var ROW_GAP = 4;",
        "var data = [];",
        "for (var r = 0; r < 1000; r++) {",
        "    var row = [];",
        "    for (var c = 0; c < 6; c++) {",
        "        array_push(row, { label: \"R\" + string(r) + \"/C\" + string(c) });",
        "    }",
        "    array_push(data, row);",
        "}",
        "",
        "var grid = new UiVirtualGrid({ width: \"100%\", height: 360 }, {",
        "    value: data,",
        "    estimatedRowHeight: 40 + ROW_GAP,",
        "    estimatedColumnWidth: 120,",
        "    numColumns: 6,",
        "    renderCell: function(rowIndex, colIndex) {",
        "        return new UiNode({ width: 120, height: \"100%\" });",
        "    },",
        "    onBind: function(rowIndex, colIndex, node) {",
        "        node.__label = data[rowIndex][colIndex].label;",
        "        if (colIndex == 0) node.parent.marginBottom = ROW_GAP;",
        "    },",
        "    scrollbarColor: #818CF8",
        "});",
        "",
        "// API (same as UiVirtualList)",
        "grid.scrollToIndex(500);",
        "grid.setValue(newData);",
        "grid.getContentSize();",
    ];
}
