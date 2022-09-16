import Foundation
import SwiftUI

@available(iOS 16.0, macCatalyst 16, *)
extension ProposedViewSize {
    var placement: PlacementProposedViewSize {
        PlacementProposedViewSize(width: width, height: height)
    }
}

@available(iOS 16.0, macCatalyst 16, *)
extension PlacementProposedViewSize {
    var proposedViewSize: ProposedViewSize {
        ProposedViewSize(width: width, height: height)
    }
}

@available(iOS 16.0, macCatalyst 16, *)
struct PlacementLayoutNative<L: PlacementLayout>: Layout {
    var layoutBP: L

    typealias Cache = L.Cache
    
    func makeSubviews(_ subviews: Subviews) -> PlacementLayoutSubviews {
        PlacementLayoutSubviews(subviews: subviews.map({ subview in
            subview as any PlacementLayoutSubview
        }))
    }
    
    func makeCache(subviews: Subviews) -> L.Cache {
        layoutBP.makeCache(subviews: makeSubviews(subviews))
    }
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        layoutBP.sizeThatFits(
            proposal: proposal.placement,
            subviews: makeSubviews(subviews),
            cache: &cache
        )
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        layoutBP.placeSubviews(
            in: bounds,
            proposal: proposal.placement,
            subviews: makeSubviews(subviews),
            cache: &cache
        )
    }
    
    func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout L.Cache
    ) -> CGFloat? {
        layoutBP.explicitAlignment(
            of: guide,
            in: bounds,
            proposal: proposal.placement,
            subviews: makeSubviews(subviews),
            cache: &cache
        )
    }
    
    func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout L.Cache
    ) -> CGFloat? {
        layoutBP.explicitAlignment(
            of: guide,
            in: bounds,
            proposal: proposal.placement,
            subviews: makeSubviews(subviews),
            cache: &cache
        )
    }
    
    func updateCache(_ cache: inout Cache, subviews: Subviews) {
        layoutBP.updateCache(&cache, subviews: makeSubviews(subviews))
    }
}
