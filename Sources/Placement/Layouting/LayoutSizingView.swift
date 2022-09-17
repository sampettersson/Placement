import Foundation
import SwiftUI

struct LayoutSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator<L>
    var layout: L
    var children: _VariadicView.Children
    var childrenIntrinsicSizes: [AnyHashable: CGSize]
        
    func makeUIView(context: Context) -> ZeroSizeView {
        return ZeroSizeView(frame: .zero)
    }
    
    func updateUIView(_ uiView: ZeroSizeView, context: Context) {}
    
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: ZeroSizeView
    ) {
        guard proposedSize.cgSize != .zero else {
            return
        }
        
        coordinator.layoutContext(children: children) { subviews, cache in
            let proposal = PlacementProposedViewSize(
                width: proposedSize.width,
                height: proposedSize.height
            )
            
            size = layout.sizeThatFits(
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )
            
            coordinator.sizeCoordinator.size = size
                        
            layout.placeSubviews(
                in: CGRect(origin: .zero, size: proposal.replacingUnspecifiedDimensions(by: .zero)),
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )            
        }
    }
}
