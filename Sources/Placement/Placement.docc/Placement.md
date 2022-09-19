# ``Placement``

A polyfill for the new Layout protocol from iOS 16. Supports iOS 14 and above, on iOS 16 Placement favors the built in Layout protocol and uses that instead of Placements own layouter.

## Overview

Placement provides ``PlacementLayout`` which is mostly a drop in replacement for the `Layout` protocol from `SwiftUI`.

## Differences from SwiftUI.Layout

- No way to get alignment guides on ``PlacementLayoutSubview`` currently.
- Some side-effects may be triggered twice like GeometryReaders on the children in a layout, this is due to Placement using a `UIHostingController` to evaluate `sizeThatFits`.
