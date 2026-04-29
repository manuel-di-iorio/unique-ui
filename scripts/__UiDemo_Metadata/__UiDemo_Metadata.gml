function __ui_demo_get_component_metadata() {
    return {
        "Button": {
            desc: "Allows users to perform an action with a single click.",
            props: [
                { name: "variant", type: "string", desc: "Visual appearance: 'primary', 'secondary', 'outline', 'ghost', 'danger'" },
                { name: "halign", type: "constant", desc: "Horizontal alignment: fa_left, fa_center, fa_right" },
                { name: "outline", type: "boolean", desc: "Shows a thin border" },
                { name: "enableRipple", type: "boolean", desc: "Enables ripple effect on click" },
                { name: "label", type: "string", desc: "Text to show next to the sprite" },
                { name: "autoResize", type: "boolean", desc: "Automatically resizes based on content" }
            ]
        },
        "Input": {
            desc: "Text field for user data entry.",
            props: [
                { name: "label", type: "string", desc: "Descriptive label above the field" },
                { name: "value", type: "string", desc: "Current value of the field" },
                { name: "placeholder", type: "string", desc: "Placeholder text when the field is empty" },
                { name: "maxLength", type: "number", desc: "Maximum number of characters allowed" },
                { name: "format", type: "string", desc: "Data type: 'string', 'float', 'integer'" },
                { name: "onChange", type: "function", desc: "Callback called when the value changes" },
                { name: "iconLeft", type: "sprite", desc: "Sprite to show on the left" },
                { name: "iconRight", type: "sprite", desc: "Sprite to show on the right" }
            ]
        },
        "Checkbox": {
            desc: "Allows selecting one or more options from a set.",
            props: [
                { name: "value", type: "boolean", desc: "Selection state (true/false)" },
                { name: "label", type: "string", desc: "Descriptive text next to the checkbox" },
                { name: "onChange", type: "function", desc: "Callback called on state change" },
                { name: "variant", type: "string", desc: "Input type: 'checkbox' or 'radio'" }
            ]
        },
        "Radio": {
            desc: "Allows selecting a single option from a group.",
            props: [
                { name: "value", type: "boolean", desc: "Selection state" },
                { name: "label", type: "string", desc: "Descriptive text" },
                { name: "group", type: "string", desc: "Group name for mutual selection" },
                { name: "onChange", type: "function", desc: "Callback called on state change" }
            ]
        },
        "Switch": {
            desc: "Binary toggle to enable or disable a setting.",
            props: [
                { name: "value", type: "boolean", desc: "Switch state" },
                { name: "label", type: "string", desc: "Descriptive text" },
                { name: "onChange", type: "function", desc: "Callback called on state change" }
            ]
        },
        "Select": {
            desc: "Dropdown menu to select an option from a list.",
            props: [
                { name: "value", type: "any", desc: "Selected value" },
                { name: "items", type: "array", desc: "Array of structs {label, value}" },
                { name: "label", type: "string", desc: "Selector label" },
                { name: "search", type: "string", desc: "Placeholder for the internal search bar" },
                { name: "onChange", type: "function", desc: "Callback called on selection" }
            ]
        },
        "Badge": {
            desc: "Small status indicators or counters.",
            props: [
                { name: "variant", type: "string", desc: "Badge style (uses UiButton with variants)" }
            ]
        },
        "Alert": {
            desc: "Contextual feedback messages for the user.",
            props: [
                { name: "type", type: "string", desc: "Alert type: 'info', 'success', 'warning', 'error'" },
                { name: "title", type: "string", desc: "Message title" }
            ]
        },
        "Card": {
            desc: "Flexible container to group related content.",
            props: [
                { name: "padding", type: "number", desc: "Internal spacing" },
                { name: "border", type: "boolean", desc: "Shows the outer border" }
            ]
        },
        "Tabs": {
            desc: "Organizes content into different navigable views.",
            props: [
                { name: "items", type: "array", desc: "List of tabs" },
                { name: "onChange", type: "function", desc: "Callback on tab change" }
            ]
        },
        "Tooltip": {
            desc: "Additional information that appears on hover.",
            props: [
                { name: "tooltip", type: "string", desc: "Tooltip text (UiNode property)" },
                { name: "tooltipDelay", type: "number", desc: "Delay in ms before appearing" }
            ]
        },
        "Slider": {
            desc: "Allows selecting a value from a numeric range.",
            props: [
                { name: "value", type: "number", desc: "Current value" },
                { name: "min", type: "number", desc: "Minimum value" },
                { name: "max", type: "number", desc: "Maximum value" },
                { name: "step", type: "number", desc: "Minimum increment" },
                { name: "onChange", type: "function", desc: "Callback on value change" }
            ]
        },
        "Accordion": {
            desc: "Content sections that can be expanded or collapsed.",
            props: [
                { name: "text", type: "string", desc: "Header text" },
                { name: "collapsed", type: "boolean", desc: "Initial state (collapsed/expanded)" },
                { name: "spriteCollapsed", type: "sprite", desc: "Icon when collapsed" },
                { name: "spriteExpanded", type: "sprite", desc: "Icon when expanded" }
            ]
        },
        "Sprite": {
            desc: "Displays a GameMaker sprite resource.",
            props: [
                { name: "sprite", type: "sprite", desc: "Index of the sprite to display" },
                { name: "width", type: "number/string", desc: "Desired width" },
                { name: "height", type: "number/string", desc: "Desired height" }
            ]
        },
        "ContextMenu": {
            desc: "Popup menu activated by right-click.",
            props: [
                { name: "x", type: "number", desc: "Initial X position" },
                { name: "y", type: "number", desc: "Initial Y position" },
                { name: "addItem", type: "function", desc: "Method to add menu items" }
            ]
        },
        "Treeview": {
            desc: "Displays a hierarchical structure of expandable items.",
            props: [
                { name: "onItemSelected", type: "function", desc: "Callback on item selection" },
                { name: "onAssetDrop", type: "function", desc: "Handles drag & drop between items" },
                { name: "filter", type: "function", desc: "Filters items by name" }
            ]
        }
    };
}

function __ui_demo_get_performance_metadata() {
    var _default = {
        impact: "Medium",
        dominantCost: "Draw calls and dynamic UI allocations",
        bottlenecks: [
            "Complete node reconstruction when state changes frequently",
            "Intensive use of custom onDraw with primitives for each element",
            "Global layout updates even for micro-variations"
        ],
        optimizations: [
            "Reduce repeated destroy/create with node reuse and property updates",
            "Minimize global requestUpdate, preferring local updates when possible",
            "Group redraws and reduce text/primitives in loops"
        ],
        measurements: [
            "Measure average FPS and 1% low during rapid interactions",
            "Count total/rendered nodes (countAll + visible) per scene",
            "Compare frame time before/after optimizations with same dataset"
        ]
    };
    
    return {
        "__default": _default,
        "Colors": {
            impact: "Low-Medium",
            dominantCost: "Drawing many static cards with roundrect",
            bottlenecks: [
                "Many draw primitives in sequence",
                "Layout wrapping with many cards can increase recalculations"
            ],
            optimizations: [
                "Cache static blocks on surfaces when they don't change",
                "Reduce unnecessary redraws in static screens"
            ],
            measurements: [
                "Compare frame time with/without surface cache",
                "Verify number of redraws during hover/scroll"
            ]
        },
        "Typography": {
            impact: "Low",
            dominantCost: "Text rendering and font metrics",
            bottlenecks: [
                "Many UiText can cost on non-cached fonts",
                "Inconsistent heights can increase layout passes"
            ],
            optimizations: [
                "Standardize styles and fonts to improve renderer cache",
                "Avoid layout updates when only static content changes"
            ],
            measurements: [
                "Measure draw_text per frame in long views",
                "Verify tab opening time with many texts"
            ]
        },
        "Input": {
            impact: "Medium-High",
            dominantCost: "Step for caret management, selection, undo/redo, key repeat",
            bottlenecks: [
                "Character parsing every frame while focused",
                "String width calculation in cursor/selection operations",
                "Frequent RequestRedraw during editing"
            ],
            optimizations: [
                "Reduce string_width calls with incremental caching",
                "Separate input logic from redraw when value doesn't change",
                "Limit scissor/selection updates to necessary frames only"
            ],
            measurements: [
                "Profile frame time holding a key for 5s",
                "Count redraws per character inserted"
            ]
        },
        "Select": {
            impact: "Medium",
            dominantCost: "List opening, search filtering, and item recreation",
            bottlenecks: [
                "destroyChildren/createItems on every filter",
                "Many visible items increase draw + layout"
            ],
            optimizations: [
                "Virtualize list for large datasets",
                "Debounce search to reduce reconstructions"
            ],
            measurements: [
                "Measure dropdown opening time with 50/200/1000 items",
                "Track frame drops while typing in the filter"
            ]
        },
        "Treeview": {
            impact: "High",
            dominantCost: "Recursive traversing + drag/drop + hierarchical filtering",
            bottlenecks: [
                "Recursive filter on deep trees",
                "Node expansion with many children",
                "Visual update during drag"
            ],
            optimizations: [
                "Index names for fast filtering",
                "Lazy render of non-visible branches",
                "Batch update during mass operations"
            ],
            measurements: [
                "Filter time on 1k/5k node trees",
                "Frame time during continuous drag"
            ]
        },
        "Slider": {
            impact: "Low-Medium",
            dominantCost: "Continuous redraw during drag",
            bottlenecks: [
                "Animated onDraw every frame",
                "High-frequency value update"
            ],
            optimizations: [
                "Throttle onChange when used for expensive logic",
                "Reduce animation when value difference is minimal"
            ],
            measurements: [
                "Frame time during rapid 3s drag",
                "Number of onChange callbacks per second"
            ]
        }
    };
}
