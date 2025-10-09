# Interchange Widgets

Overview of the Interchange widget extension.

This extension is in active development and may change quickly. Timeline entries
may receive additional protocols or definitions, and views may receive
more wrapper views over time.

## App groups and data sharing

The app group `group.dev.bchen.Inter` contains shared `UserDefaults` values set by the user
in the main app. For instance, the "Mirror app" option present on some widgets reads
a selected ID from the main app.

![Sketch of how data sharing works.](Documentation/sketch.png)

## Tests

Tests need more research, namely because some required parameters of `TimelineProvider`
have no usable initializers.

