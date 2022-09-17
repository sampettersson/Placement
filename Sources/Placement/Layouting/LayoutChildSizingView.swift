import Foundation
import SwiftUI

class LayoutChildSizingUIView: UIView {
    var previousProposal: CGSize? = nil
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

struct LayoutChildSizingView<L: PlacementLayout>: UIViewRepresentable {
    @Environment(\.childrenIntrinsicSizes) var childrenIntrinsicSizes
    @EnvironmentObject var coordinator: Coordinator<L>

    var layout: L
    var id: AnyHashable
    var children: _VariadicView.Children
        
    func makeUIView(context: Context) -> LayoutChildSizingUIView {
        return LayoutChildSizingUIView(frame: .zero)
    }
    
    func updateUIView(_ uiView: LayoutChildSizingUIView, context: Context) {
       
    }
    
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: LayoutChildSizingUIView
    ) {        
        coordinator.layoutContext(children: children) { subviews, cache in
            let proposal = PlacementProposedViewSize(coordinator.sizeCoordinator.size ?? .zero)
            
            layout.placeSubviews(
                in: CGRect(origin: .zero, size: proposal.replacingUnspecifiedDimensions(by: .zero)),
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )
                        
            let placementProposal = coordinator.placementsCoordinator.placements[id]?.proposal
                                                
            size = placementProposal?.replacingUnspecifiedDimensions(by: .zero) ?? .zero
        }
    }
}

