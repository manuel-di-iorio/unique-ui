# Modal

Overlay dialog box that interrupts user workflow to ask for a decision or display information.

## Usage

```gml
var modal = new UiModal({}, {
    title: "Basic Modal"
});

modal.add(new UiText("This is a basic modal. You can close it by clicking the X or clicking outside.", {}, { wrap: true }));

modal.open();
```

## Props

| Prop | Type | Description |
| ---- | ---- | ----------- |
| `title` | `string` | Title text shown in the header |
| `backdropColor` | `color` | Color of the background overlay (default `c_black`) |
| `backdropAlpha` | `number` | Opacity of the background overlay (default `0.5`) |
| `dismissOnBackdropClick` | `boolean` | Whether clicking outside closes the modal (default `true`) |
| `showCloseButton` | `boolean` | Whether to show the top-right close button (default `true`) |
| `panelStyle` | `struct` | Styling properties for the modal panel itself |
| `onClose` | `function` | Callback executed when modal closes |

## Methods

- `open()`: Adds the modal to the root overlay, rendering it on the screen.
- `close()`: Closes and destroys the modal, running the `onClose` callback.
- `add(child)`: Appends a child component to the modal's `Body` section.
