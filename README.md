# Placement

A polyfill for the new Layout protocol from iOS 16. Supports iOS 14 and above, on iOS 16 Placement favors the built in Layout protocol and uses that instead of Placements own layouter.

## API

### PlacementLayout

Mimics the Layout protocol and has the same requirements and defaults.

#### prefersLayoutProtocol

Implement this property and set to false if you want to always use Placements layouter irregardles of availability of the Layout protocol on the platform.

### PlacementLayoutValueKey

Mimics the LayoutValueKey

### Notable differences

- Layout priority needs to be set with `placementLayoutPriority` instead of SwiftUIs inbuilt `layoutPriority`

## Known bugs

- Animations are currently somewhat buggy on iOS 14, but end layout is correct

## Example

```swift
struct ExampleStack: PlacementLayout {
    func sizeThatFits(
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Void
    ) -> CGSize {
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
                        
        subviews.forEach { subview in
            let proposal = proposal.replacingUnspecifiedDimensions(
                by: CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
            )
                        
            let size = subview.sizeThatFits(ProposedViewSize(proposal))
                                    
            totalHeight += size.height
            maxWidth = max(maxWidth, size.width)
        }
                        
        return CGSize(
            width: maxWidth,
            height: totalHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Void
    ) {
        var nextY = bounds.minY
        
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(
                proposal
            )
                        
            subviews[index].place(
                at: CGPoint(x: bounds.midX, y: nextY),
                anchor: .top,
                proposal: PlacementProposedViewSize(size)
            )
                        
            nextY += size.height
        }
    }
}
```


