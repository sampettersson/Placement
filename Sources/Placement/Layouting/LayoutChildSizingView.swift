import Foundation
import SwiftUI

struct LayoutChildSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator<L>
    var layout: L
    var id: AnyHashable
    var contentSize: CGSize? = nil
    var layoutSize: CGSize? = nil
    var placement: LayoutPlacement? = nil
    var children: _VariadicView.Children
    
    @State var hostingController = UIHostingController(rootView: AnyView(EmptyView()))
    
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

