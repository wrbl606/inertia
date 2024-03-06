# scrollable_inertia

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A set of easy to apply scroll list customizations to make your Flutter application stand out in the crowd.

## Usage

Each interia effect is based on Scrollable's (i.e. ListView, SingleChildScrollView, GridView, ...) ability to notify parent widgets about the current speed and axis of the current scroll action. `InertiaListener` is the widget that will pick up the information and pass it down to specific effects to apply the inertia-based animation.

### Inertia-based spacing

Make the list's items be affected by inertia of the scroll:

<img src="https://wrbl.xyz/spacing.webp" alt="Inertia-based spacing demo" width=400>

Wrap _**each**_ child of the scrollable with the `InertiaSpacing` widget, e.g.:

```dart
InertiaListener(
  child: ListView.builder(
    itemBuilder: (_, __) => InertiaSpacing(
      child: YourListItem()
    ),
  ),
)...
```

### Motion blur

Make the list's items be affected by inertia of the scroll:

<img src="https://wrbl.xyz/blur.webp" alt="Motion blur demo" width=400>

Wrap the whole scrollable with the `MotionBlur`, e.g.:

```dart
InertiaListener(
  child: MotionBlur(
    child: GridView.builder(...)
  ),
)...
```
