# Interchange shared package

Shared set of code between the Interchange main application, widget extension,
and other targets (including tests).

This was created to address code duplication issues across different testing
targets and the widget extension (e.g. with `BundleClass`). It has since expanded
to include commonly-used protocols, entities, and basic networking.
