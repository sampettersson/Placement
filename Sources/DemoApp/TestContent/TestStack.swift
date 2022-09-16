import Foundation
import SwiftUI
import Placement

struct OtherStack: PlacementLayout {
    /// Returns a size that the layout container needs to arrange its subviews
    /// horizontally.
    /// - Tag: sizeThatFitsHorizontal
    func sizeThatFits(
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
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
                at: CGPoint(x: bounds.minX + (size.width / 2), y: bounds.minY),
                anchor: .top,
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
                at: CGPoint(x: bounds.midX, y: nextY),
                anchor: .top,
                proposal: PlacementProposedViewSize(size)
            )
                        
            nextY += size.height
        }
    }
}
