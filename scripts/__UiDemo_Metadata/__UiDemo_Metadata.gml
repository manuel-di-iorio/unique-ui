function __ui_demo_get_component_metadata() {
    return {
        "Introduction": {
            desc: "Learn the core concepts of UniqueUI: UiRoot, UiNode, container structures, custom drawing, and event handling."
        },
        "Store": {
            desc: "Lightweight reactive state management: subscribe to changes, batch updates with setState, and bind UI components to shared state."
        },
        "Button": {
            desc: "Allows users to perform an action with a single click.",
            props: [
                { name: "variant", type: "string", desc: "Visual appearance: 'primary', 'secondary', 'outline', 'ghost', 'danger'" },
                { name: "halign", type: "constant", desc: "Horizontal alignment: fa_left, fa_center, fa_right" },
                { name: "outline", type: "boolean", desc: "Shows a thin border" },
                { name: "enableRipple", type: "boolean", desc: "Enables ripple effect on click" },
                { name: "label", type: "string", desc: "Text to show next to the sprite" },
                { name: "autoResize", type: "boolean", desc: "Automatically resizes based on content" },
                { name: "spriteWidth", type: "number", desc: "Custom width for the sprite icon" },
                { name: "spriteHeight", type: "number", desc: "Custom height for the sprite icon" },
                { name: "enabled", type: "boolean", desc: "Enables button interaction" },
                { name: "selected", type: "boolean", desc: "Indicates selection state for toggle-like buttons" }
            ]
        },
        "Textbox": {
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
        "Textarea": {
            desc: "Multiline text field with cursor navigation, selection, and scrolling.",
            props: [
                { name: "label", type: "string", desc: "Descriptive label above the field" },
                { name: "value", type: "string", desc: "Current multiline value of the field" },
                { name: "placeholder", type: "string", desc: "Placeholder text when the field is empty" },
                { name: "maxLength", type: "number", desc: "Maximum number of characters allowed" },
                { name: "lineHeight", type: "number", desc: "Height in pixels used for each text line" },
                { name: "onChange", type: "function", desc: "Callback called when the value changes" },
                { name: "onBlur", type: "function", desc: "Callback called when focus leaves the field" }
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
        "ColorPicker": {
            desc: "Color picker with HSV panel and hex input.",
            props: [
                { name: "value", type: "color", desc: "Currently selected color" },
                { name: "label", type: "string", desc: "Optional label next to the trigger swatch" },
                { name: "onChange", type: "function", desc: "Callback: function(color, picker) on change" }
            ]
        },
        "Badge": {
            desc: "Small pill-shaped status indicator with six semantic color variants.",
            props: [
                { name: "variant", type: "string", desc: "Color scheme: 'default', 'primary', 'success', 'warning', 'danger', 'info'" },
                { name: "dot",     type: "boolean", desc: "Renders a small colored dot instead of a label (default false)" }
            ]
        },
        "Alert": {
            desc: "Contextual feedback banner for the user with optional title and dismiss button.",
            props: [
                { name: "type",        type: "string",   desc: "Semantic type: 'info', 'success', 'warning', 'error'" },
                { name: "title",       type: "string",   desc: "Optional bold title shown above the message" },
                { name: "dismissible", type: "boolean",  desc: "Shows a close (x) button that hides the alert" },
                { name: "onDismiss",   type: "function", desc: "Callback fired when the dismiss button is clicked" }
            ]
        },
        "Toast": {
            desc: "A floating notification container stacking alerts top-right from newest to oldest. Can be instantiated or called globally via helpers.",
            props: [
                { name: "show(msg, type, title, duration)", type: "method", desc: "Spawns a toast notification alert. Auto-dismisses if duration > 0 (ms)." },
                { name: "success(msg, title, duration)", type: "method", desc: "Spawns a success toast notification." },
                { name: "error(msg, title, duration)", type: "method", desc: "Spawns an error toast notification." },
                { name: "warning(msg, title, duration)", type: "method", desc: "Spawns a warning toast notification." },
                { name: "info(msg, title, duration)", type: "method", desc: "Spawns an informational toast notification." },
                { name: "destroyChildren()", type: "method", desc: "Dismisses and destroys all active toast alerts." }
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
            desc: "Tab navigation strip that switches between content panels. Supports underline and pills variants.",
            props: [
                { name: "items",         type: "array",    desc: "Array of { label, content } structs" },
                { name: "selectedIndex", type: "number",   desc: "Zero-based index of the active tab (default 0)" },
                { name: "variant",       type: "string",   desc: "Visual style: 'underline' (default) or 'pills'" },
                { name: "onChange",      type: "function", desc: "Callback: function(index, label) on tab change" }
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
            desc: "Allows selecting a value from a numeric range. Supports dual-thumb range mode.",
            props: [
                { name: "value", type: "number", desc: "Current value (single mode)" },
                { name: "valueStart", type: "number", desc: "Start value (range mode)" },
                { name: "valueEnd", type: "number", desc: "End value (range mode)" },
                { name: "min", type: "number", desc: "Minimum value" },
                { name: "max", type: "number", desc: "Maximum value" },
                { name: "step", type: "number", desc: "Minimum increment" },
                { name: "onChange", type: "function", desc: "Callback on value change (returns value or [valueStart, valueEnd])" }
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
            desc: "Displays a GameMaker sprite resource inside an UI element.",
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
        "MenuBar": {
            desc: "Horizontal application menu bar with dropdown panels, shortcuts, separators, and hover-to-switch behavior.",
            props: [
                { name: "menus", type: "array", desc: "Array of { label, items } top-level menu entries" },
                { name: "itemPadding", type: "number", desc: "Horizontal padding for trigger labels (props)" },
                { name: "closeAll()", type: "method", desc: "Closes any open dropdown panel" }
            ]
        },
        "Modal": {
            desc: "Overlay dialog box that interrupts user workflow to ask for a decision or display information.",
            props: [
                { name: "title", type: "string", desc: "Title text shown in the header" },
                { name: "backdropColor", type: "color", desc: "Color of the background overlay" },
                { name: "backdropAlpha", type: "number", desc: "Opacity of the background overlay" },
                { name: "dismissOnBackdropClick", type: "boolean", desc: "Whether clicking outside closes the modal" },
                { name: "showCloseButton", type: "boolean", desc: "Whether to show the top-right close button" },
                { name: "onClose", type: "function", desc: "Callback executed when modal closes" }
            ]
        },
        "Treeview": {
            desc: "Displays a hierarchical structure of expandable items.",
            props: [
                { name: "onItemSelected", type: "function", desc: "Callback on item selection" },
                { name: "onAssetDrop", type: "function", desc: "Handles drag & drop between items" },
                { name: "filter", type: "function", desc: "Filters items by name" }
            ]
        },
        "VirtualList (beta)": {
            desc: "Virtual-scrolling list with fixed pool, lazy offset cache, and binary search. Renders only the visible window.",
            props: [
                { name: "value", type: "array", desc: "Array of raw data items to display" },
                { name: "estimatedItemHeight", type: "number", desc: "Fallback height for unmeasured items (default 40)" },
                { name: "buffer", type: "number", desc: "Extra items above/below the visible window (default 5)" },
                { name: "renderItem", type: "function", desc: "function(index) → UiNode; called once per pool slot during construction" },
                { name: "onBind", type: "function", desc: "function(index, node) updates an existing pool node to show value[index]" },
                { name: "onChange", type: "function", desc: "function(newValue, node) fired when the dataset is replaced via setValue()" },
                { name: "scrollbarColor", type: "color/function", desc: "Colour for the scrollbar thumb" },
                { name: "getContentSize()", type: "method", desc: "Returns total virtual content height (O(1))" },
                { name: "scrollToIndex(index)", type: "method", desc: "Scrolls so that the given data index is at the top" },
                { name: "setValue(newValue)", type: "method", desc: "Replaces the dataset and resets scroll + cache" }
            ]
        }
    };
}

