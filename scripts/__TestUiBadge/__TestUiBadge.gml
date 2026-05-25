// ============================================================
//  UiBadge Tests
// ============================================================

ui_test_suite("UiBadge", function() {
    
    ui_test("Create — text property set", function() {
        var b = new UiBadge("Beta", {}, {});
        assert_equal(b.text, "Beta", "text = 'Beta'");
    });
    
    ui_test("Create — default variant is 'default'", function() {
        var b = new UiBadge("New", {}, {});
        assert_equal(b.variant, "default", "variant = default");
    });
    
    ui_test("Variant prop stored correctly", function() {
        var b = new UiBadge("OK", {}, { variant: "success" });
        assert_equal(b.variant, "success", "variant = success");
    });
    
    ui_test("dot prop defaults to false", function() {
        var b = new UiBadge("X", {}, {});
        assert_false(b.dot, "dot = false");
    });
    
    ui_test("dot prop can be enabled", function() {
        var b = new UiBadge("", {}, { dot: true });
        assert_true(b.dot, "dot = true");
    });
    
    ui_test("setText updates text property", function() {
        var b = new UiBadge("Old", {}, {});
        b.setText("New");
        assert_equal(b.text, "New", "text updated to 'New'");
    });
    
    ui_test("setVariant updates variant property", function() {
        var b = new UiBadge("X", {}, {});
        b.setVariant("danger");
        assert_equal(b.variant, "danger", "variant updated to danger");
    });
    
    ui_test("isUiNode is true (inherits UiNode)", function() {
        var b = new UiBadge("X", {}, {});
        assert_true(b.isUiNode, "isUiNode = true");
    });
    
    ui_test("height defaults to 26", function() {
        var b = new UiBadge("Hi", {}, {});
        assert_equal(b.getHeight(), 26, "height = 26");
    });
    
    ui_test("style height override works", function() {
        var b = new UiBadge("Hi", { height: 28 }, {});
        assert_equal(b.getHeight(), 28, "height = 28 from style");
    });
    
    ui_test("all variants are accepted without error", function() {
        var variants = ["default", "primary", "success", "warning", "danger", "info"];
        for (var i = 0; i < array_length(variants); i++) {
            var b = new UiBadge("X", {}, { variant: variants[i] });
            assert_equal(b.variant, variants[i], "variant = " + variants[i]);
        }
    });
    
});
