// ============================================================
//  UniqueUI Test Runner - Entry Point
//
//  Call ui_test_run_all() from anywhere (e.g. a room creation
//  code, an object Create event, or a debug key press) to run
//  the entire test suite and see results in the Output console.
//
//  Example usage in a room or object:
//      ui_test_run_all();
// ============================================================

// ── Register all test suites ─────────────────────────────────
// (Each __Test* script calls ui_test_suite() at parse time,
//  so by the time this runner executes, all suites are already
//  registered in global.__ui_test_suites.)
//
// If you want to run only a subset, call ui_test_run_all()
// after clearing global.__ui_test_suites and re-registering
// only the suites you want.
//
// Order of registration matches script execution order set in
// the resource_order file.

/// @desc Run all registered UniqueUI test suites.
///       Returns a struct { passed, failed, total }.
function ui_test_run_all_suites() {
    return ui_test_run_all();
}

// Run tests automatically at startup (delayed by 1 frame to ensure all scripts are loaded)
call_later(1, time_source_units_frames, ui_test_run_all);

