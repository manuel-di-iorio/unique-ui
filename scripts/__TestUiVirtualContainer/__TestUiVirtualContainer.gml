ui_test_suite("UiVirtualContainer", function() {

    // ── Construction ─────────────────────────────────────────────────────────

    ui_test("constructor sets dataLength and estimatedItemHeight", function() {
        var c = new UiVirtualContainer(100, 40);
        assert_equal(c.getTotalContentSize(), 4000, "100 * 40 = 4000 total");
        assert_equal(c.getItemHeight(0), 40, "estimate used before measure");
        assert_equal(c.getItemHeight(99), 40, "estimate used for last index");
        assert_equal(c.getItemOffset(0), 0, "first offset is 0");
    });

    ui_test("constructor with zero length", function() {
        var c = new UiVirtualContainer(0, 40);
        assert_equal(c.getTotalContentSize(), 0, "no items = 0 size");
        assert_equal(c.findNearestItem(0), 0, "empty returns 0");
        assert_equal(c.findNearestItem(100), 0, "empty returns 0");
    });

    ui_test("constructor with one item", function() {
        var c = new UiVirtualContainer(1, 50);
        assert_equal(c.getTotalContentSize(), 50, "1 * 50");
        assert_equal(c.getItemOffset(0), 0, "offset 0");
        assert_equal(c.getItemHeight(0), 50, "estimate");
        assert_equal(c.findNearestItem(0), 0, "first item");
        assert_equal(c.findNearestItem(100), 0, "clamped to last");
    });

    // ── getItemOffset ────────────────────────────────────────────────────────

    ui_test("getItemOffset returns 0 for negative index", function() {
        var c = new UiVirtualContainer(10, 40);
        assert_equal(c.getItemOffset(-1), 0, "negative → 0");
        assert_equal(c.getItemOffset(-999), 0, "very negative → 0");
    });

    ui_test("getItemOffset builds lazy cache", function() {
        var c = new UiVirtualContainer(100, 40);
        assert_equal(c.getItemOffset(5), 5 * 40, "offset 5 = 200");
        assert_equal(c.getItemOffset(10), 10 * 40, "offset 10 = 400 (extended)");
        assert_equal(c.getItemOffset(3), 3 * 40, "offset 3 = 120 (cached)");
    });

    ui_test("getItemOffset with measured heights", function() {
        var c = new UiVirtualContainer(10, 40);
        c.setItemHeight(2, 80);
        c.setItemHeight(3, 60);
        // offsets computed lazily on first access
        assert_equal(c.getItemOffset(0), 0, "0");
        assert_equal(c.getItemOffset(1), 40, "1");
        assert_equal(c.getItemOffset(2), 80, "2 = 40+40  (still estimate before setItemHeight was at idx 2, wait...)");
        // Actually offsets are computed lazily. After setItemHeight(2,80) and setItemHeight(3,60),
        // calling getItemOffset(3) recomputes: 0→0@40, 1→40@40, 2→80@80, 3→160@60
        assert_equal(c.getItemOffset(3), 160, "3 = 40 + 40 + 80");
        assert_equal(c.getItemOffset(4), 220, "4 = 160 + 60");
    });

    ui_test("setItemHeight invalidates offsets forward", function() {
        var c = new UiVirtualContainer(5, 40);
        c.getItemOffset(4); // computes all offsets (0..4)
        c.setItemHeight(2, 100);
        // cache invalidated from index 2; getItemOffset(4) should recompute
        assert_equal(c.getItemOffset(4), 40 + 100 + 40 + 40, "recomputed");
    });

    // ── setItemHeight ────────────────────────────────────────────────────────

    ui_test("setItemHeight stores height and invalidates cache", function() {
        var c = new UiVirtualContainer(10, 40);
        c.getItemOffset(5); // warm up cache
        c.setItemHeight(3, 100);
        assert_equal(c.getItemHeight(3), 100, "stored height");
        assert_equal(c.getItemOffset(3), 3 * 40, "offset 3 still 120 (pre-invalidation)");
        assert_equal(c.getItemOffset(5), 40+40+40+100+40, "recomputed from index 3");
        assert_equal(c.getItemHeight(3), 100, "height preserved after recompute");
    });

    ui_test("setItemHeight with negative index does nothing", function() {
        var c = new UiVirtualContainer(5, 40);
        c.setItemHeight(-1, 100);
        assert_equal(c.getItemHeight(0), 40, "unchanged");
    });

    // ── getItemHeight ────────────────────────────────────────────────────────

    ui_test("getItemHeight returns estimate for unmeasured indices", function() {
        var c = new UiVirtualContainer(5, 40);
        assert_equal(c.getItemHeight(2), 40, "estimate");
        assert_equal(c.getItemHeight(0), 40, "estimate");
    });

    ui_test("getItemHeight returns 0 for negative index", function() {
        var c = new UiVirtualContainer(5, 40);
        assert_equal(c.getItemHeight(-1), 0, "negative → 0");
        assert_equal(c.getItemHeight(-5), 0, "negative → 0");
    });

    ui_test("getItemHeight returns measured value after setItemHeight", function() {
        var c = new UiVirtualContainer(5, 40);
        c.setItemHeight(2, 80);
        assert_equal(c.getItemHeight(2), 80, "measured");
    });

    // ── getTotalContentSize ──────────────────────────────────────────────────

    ui_test("getTotalContentSize with no measurements", function() {
        var c = new UiVirtualContainer(50, 30);
        assert_equal(c.getTotalContentSize(), 1500, "50 * 30");
    });

    ui_test("getTotalContentSize with partial measurements", function() {
        var c = new UiVirtualContainer(10, 40);
        c.getItemOffset(4); // compute offsets for 0..4
        // After setItemHeight + invalidation, total = offset(4) + height(4) + remaining*40
        c.setItemHeight(2, 80);
        c.getItemOffset(4); // recompute up to 4
        var total = c.getTotalContentSize();
        // offsets: 0@40, 1@40, 2@80, 3@40, 4@40
        // lastMeasuredIndex=4, offset[4]=200, height[4]=40, remaining=10-4-1=5
        // total = 200 + 40 + 5*40 = 440
        assert_equal(total, 440, "computed total");
    });

    // ── findNearestItem ──────────────────────────────────────────────────────

    ui_test("findNearestItem with even heights", function() {
        var c = new UiVirtualContainer(100, 40);
        assert_equal(c.findNearestItem(0), 0, "offset 0 → index 0");
        assert_equal(c.findNearestItem(39), 0, "offset 39 → index 0");
        assert_equal(c.findNearestItem(40), 1, "offset 40 → index 1");
        assert_equal(c.findNearestItem(79), 1, "offset 79 → index 1");
        assert_equal(c.findNearestItem(80), 2, "offset 80 → index 2");
    });

    ui_test("findNearestItem at boundaries", function() {
        var c = new UiVirtualContainer(10, 40);
        assert_equal(c.findNearestItem(-10), 0, "negative → 0");
        assert_equal(c.findNearestItem(0), 0, "zero → 0");
        assert_equal(c.findNearestItem(400), 9, "total size → last");
        assert_equal(c.findNearestItem(9999), 9, "beyond total → last");
    });

    ui_test("findNearestItem with mixed heights", function() {
        var c = new UiVirtualContainer(5, 40);
        c.setItemHeight(1, 80);
        c.setItemHeight(3, 20);
        // 0:0@40, 1:40@80, 2:120@40, 3:160@20, 4:180@40
        assert_equal(c.findNearestItem(30), 0, "30 → 0");
        assert_equal(c.findNearestItem(40), 1, "40 → 1");
        assert_equal(c.findNearestItem(119), 1, "119 → 1 (still within item 1 [40,120))");
        assert_equal(c.findNearestItem(120), 2, "120 → 2 (offset of idx 2)");
        assert_equal(c.findNearestItem(160), 3, "160 → 3");
        assert_equal(c.findNearestItem(179), 3, "179 → 3");
        assert_equal(c.findNearestItem(180), 4, "180 → 4");
    });

    // ── reset ────────────────────────────────────────────────────────────────

    ui_test("reset clears all cached data and recalculates estimate", function() {
        var c = new UiVirtualContainer(100, 40);
        c.getItemOffset(50);
        c.setItemHeight(25, 80);
        c.reset(20, 60);
        assert_equal(c.getTotalContentSize(), 1200, "20 * 60");
        assert_equal(c.getItemHeight(0), 60, "new estimate");
        assert_equal(c.getItemOffset(0), 0, "fresh start");
    });

    ui_test("reset with no new estimate uses old estimate", function() {
        var c = new UiVirtualContainer(10, 40);
        c.reset(5);
        assert_equal(c.getTotalContentSize(), 5 * 40, "5 * 40");
    });

    // ── setEstimatedHeight ───────────────────────────────────────────────────

    ui_test("setEstimatedHeight changes estimate for unmeasured items", function() {
        var c = new UiVirtualContainer(10, 40);
        c.setEstimatedHeight(80);
        assert_equal(c.getTotalContentSize(), 800, "10 * 80");
        assert_equal(c.getItemHeight(5), 80, "new estimate");
    });

});
