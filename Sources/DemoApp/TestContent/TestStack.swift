import Foundation
import SwiftUI
import Placement

struct OtherStack: PlacementLayout {
    /// Returns a size that the layout container needs to arrange its subviews
    /// horizontally.
    /// - Tag: sizeThatFitsHorizontal
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
                        
            let size = subview.sizeThatFits(PlacementProposedViewSize(proposal))
                                    
            totalHeight += size.height
            maxWidth = max(maxWidth, size.width)
        }
                                
        return CGSize(
            width: maxWidth,
            height: totalHeight
        )
    }

    /// Places the subviews in a horizontal stack.
    /// - Tag: placeSubviewsHorizontal
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
                at: CGPoint(x: bounds.minX, y: bounds.minY),
                anchor: .topLeading,
                proposal: PlacementProposedViewSize(size)
            )
                        
            nextY += size.height
        }
    }
}

struct TestStack: PlacementLayout {
    
    /// Returns a size that the layout container needs to arrange its subviews
    /// horizontally.
    /// - Tag: sizeThatFitsHorizontal
    func sizeThatFits(
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Void
    ) -> CGSize {
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
                        
        subviews.forEach { subview in
            let proposal = proposal.replacingUnspecifiedDimensions(
                by: CGSize(width: 100, height: CGFloat.infinity)
            )
                        
            let size = subview.sizeThatFits(PlacementProposedViewSize(proposal))
                                    
            totalHeight = size.height
            maxWidth = maxWidth
        }
                                
        return CGSize(
            width: proposal.width ?? .zero,
            height: totalHeight
        )
    }

    /// Places the subviews in a horizontal stack.
    /// - Tag: placeSubviewsHorizontal
    func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Void
    ) {
        var nextX = bounds.minX
        
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(
                PlacementProposedViewSize(width: (proposal.width ?? 2) / 2, height: proposal.height)
            )
            
            subviews[index].place(
                at: CGPoint(x: nextX + CGFloat(20 * index), y: 0),
                anchor: .topLeading,
                proposal: PlacementProposedViewSize(size)
            )
                        
            nextX += size.width
        }
    }
}
