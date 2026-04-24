// ============================================================
//  UniqueUI Test Framework
//  Mini assertion + runner framework for GML
// ============================================================

#macro UI_TEST_PASS  0
#macro UI_TEST_FAIL  1

function __ui_test_init() {
    if (!variable_global_exists("__ui_test_suites")) {
        global.__ui_test_suites  = [];
    }
    if (!variable_global_exists("__ui_test_results")) {
        global.__ui_test_results = [];
    }
    if (!variable_global_exists("__ui_test_current_suite")) {
        global.__ui_test_current_suite = "";
    }
}

// ─── Registration ───────────────────────────────────────────

/// Register a named test suite.
/// @param {String} name
/// @param {Function} suite_fn  — function that calls ui_test() inside
function ui_test_suite(name, suite_fn) {
    __ui_test_init();
    array_push(global.__ui_test_suites, { name: name, fn: suite_fn });
}

// ─── Assertions ─────────────────────────────────────────────

function __ui_assert_fail(message) {
    throw { message: message };
}

/// Assert two values are equal (uses ==).
function assert_equal(actual, expected, msg = "") {
    if (actual != expected) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected [" + string(expected) + "] but got [" + string(actual) + "]"
        );
    }
}

/// Assert value is true.
function assert_true(value, msg = "") {
    if (!value) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected TRUE but got [" + string(value) + "]"
        );
    }
}

/// Assert value is false.
function assert_false(value, msg = "") {
    if (value) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected FALSE but got [" + string(value) + "]"
        );
    }
}

/// Assert value is undefined.
function assert_is_undefined(value, msg = "") {
    if (!is_undefined(value)) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected UNDEFINED but got [" + string(value) + "]"
        );
    }
}

/// Assert value is NOT undefined.
function assert_not_undefined(value, msg = "") {
    if (is_undefined(value)) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected a value but got UNDEFINED"
        );
    }
}

/// Assert a > b.
function assert_greater(a, b, msg = "") {
    if (!(a > b)) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected [" + string(a) + "] > [" + string(b) + "]"
        );
    }
}

/// Assert a < b.
function assert_less(a, b, msg = "") {
    if (!(a < b)) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected [" + string(a) + "] < [" + string(b) + "]"
        );
    }
}

/// Assert a >= b.
function assert_greater_equal(a, b, msg = "") {
    if (!(a >= b)) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected [" + string(a) + "] >= [" + string(b) + "]"
        );
    }
}

/// Assert string contains substring.
function assert_string_contains(str, substr, msg = "") {
    if (string_count(substr, str) == 0) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Expected string [" + str + "] to contain [" + substr + "]"
        );
    }
}

/// Assert two arrays are equal (shallow).
function assert_array_equal(actual, expected, msg = "") {
    var la = array_length(actual);
    var le = array_length(expected);
    if (la != le) {
        __ui_assert_fail(
            (msg != "" ? msg + " | " : "") +
            "Array lengths differ: expected " + string(le) + " got " + string(la)
        );
    }
    for (var i = 0; i < la; i++) {
        if (actual[i] != expected[i]) {
            __ui_assert_fail(
                (msg != "" ? msg + " | " : "") +
                "Array[" + string(i) + "]: expected " + string(expected[i]) + " got " + string(actual[i])
            );
        }
    }
}

// ─── Runner ─────────────────────────────────────────────────

/// Run a single named test inside the current suite.
/// @param {String}   name
/// @param {Function} fn
function ui_test(name, fn) {
    var _suite = global.__ui_test_current_suite;
    var _status = UI_TEST_PASS;
    var _msg    = "";
    
    try {
        fn();
    } catch (e) {
        _status = UI_TEST_FAIL;
        _msg    = is_struct(e) ? (e[$ "message"] ?? string(e)) : string(e);
    }
    
    array_push(global.__ui_test_results, {
        suite:   _suite,
        name:    name,
        status:  _status,
        message: _msg
    });
}

/// Run all registered test suites and print results.
function ui_test_run_all() {
    global.__ui_test_results = [];
    
    show_debug_message("");
    show_debug_message("══════════════════════════════════════════");
    show_debug_message("  UniqueUI Test Suite — Running...");
    show_debug_message("══════════════════════════════════════════");
    
    var suites = global.__ui_test_suites;
    for (var i = 0; i < array_length(suites); i++) {
        var suite = suites[i];
        global.__ui_test_current_suite = suite.name;
        show_debug_message("  ■ Suite: " + suite.name);
        suite.fn();
    }
    
    // ─── Print results ───────────────────────────────────────
    var results = global.__ui_test_results;
    var total   = array_length(results);
    var passed  = 0;
    var failed  = 0;
    
    show_debug_message("");
    show_debug_message("── Results ───────────────────────────────");
    
    var current_suite = "";
    for (var i = 0; i < total; i++) {
        var r = results[i];
        
        if (r.suite != current_suite) {
            current_suite = r.suite;
            show_debug_message("  [ " + current_suite + " ]");
        }
        
        if (r.status == UI_TEST_PASS) {
            passed++;
            show_debug_message("    ✓ " + r.name);
        } else {
            failed++;
            show_debug_message("    ✗ " + r.name);
            show_debug_message("      → " + r.message);
        }
    }
    
    show_debug_message("");
    show_debug_message("══════════════════════════════════════════");
    show_debug_message("  PASSED: " + string(passed) + "/" + string(total) +
                       "   FAILED: " + string(failed));
    show_debug_message("══════════════════════════════════════════");
    
    // Concise failures summary for logs
    if (failed > 0) {
        show_debug_message("");
        show_debug_message("--- FAILED TESTS LIST ---");
        for (var i = 0; i < total; i++) {
            var r = results[i];
            if (r.status == UI_TEST_FAIL) {
                show_debug_message("FAIL: [" + r.suite + "] " + r.name + " >> " + r.message);
            }
        }
        show_debug_message("-------------------------");
    }
    show_debug_message("");
    
    return { passed: passed, failed: failed, total: total };
}
