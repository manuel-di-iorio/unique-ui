# UniqueUI - Project Overview

A high-performance UI engine for GameMaker. Every UI element is a `UiNode` (constructor pattern). Layout uses GameMaker's native Flexpanel (Yoga). Components live in `scripts/<ComponentName>/<ComponentName>.gml`. Tests use the `ui_test_suite()` / `ui_test()` framework and live in `scripts/__Test<Name>/`. Demos use `ui_demo_example_<name>()` and live in `scripts/ui_demo_example_<name>/`. The demo app (sidebar + preview) is registered in `__UiDemo_Sidebar`, `__UiDemo_Metadata`, and `__UiDemo_Content`.

## Project structure

```
scripts/
  UiNode/              - Base class for all components
  Ui<Component>/       - Each component in its own folder
  __Test<Component>/   - Tests for each component
  ui_demo_example_*    - Demo functions
  __UiDemo_Sidebar     - Sidebar registration (add new components to comps array + icon map)
  __UiDemo_Metadata    - Component metadata (desc + props list)
  __UiDemo_Content     - Example rendering and code panel
```

## Adding a new component

1. Create `scripts/Ui<Name>/Ui<Name>.gml` with a constructor function that extends `UiNode`
2. Create `scripts/__TestUi<Name>/__TestUi<Name>.gml` with tests
3. Create `scripts/ui_demo_example_<name>/ui_demo_example_<name>.gml` with a demo function
4. Register in:
   - `__UiDemo_Metadata.gml` - add entry to the metadata dict
   - `__UiDemo_Sidebar.gml` - add to `comps` array + icon case in `__ui_demo_sidebar_icon_name()`
   - `__UiDemo_Content.gml` - add to the `__ui_demo_get_examples_map()` dict
   - `Unique UI.yyp` - add folder.yy + script.yy resource entries

## GML Scope Rules

- `function name() {}` inside another function is hoisted to script scope - it does NOT capture closure variables from the enclosing function
- `method(ctx, function() {})` sets `self = ctx` but does NOT capture local variables from the enclosing scope
- To pass variables into a `method()` handler, pass them through the context struct: `method({ myVar: myVar }, fn)` and access via `self.myVar`
- For hoisted `function name(){}`, pass everything as explicit parameters or use `static` locals inside the function
- Accessing a missing struct property with dot notation (`.prop`) throws an error; use the `$` accessor (`[$ "prop"]`) to safely get `undefined`

## Misc
- Never use the characters "-" or "→" since they are not correctly renderable, use equivalents.
