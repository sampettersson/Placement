import Foundation
import SwiftUI

struct LayoutChildSizingView<L: PlacementLayout>: UIViewRepresentable {
    @Environment(\.childrenIntrinsicSizes) var childrenIntrinsicSizes
    @EnvironmentObject var coordinator: Coordinator<L>

    var layout: L
    var id: AnyHashable
    var children: _VariadicView.Children
        
    func makeUIView(context: Context) -> TransactionView {
        let view = TransactionView(frame: .zero)
        view.transaction = context.transaction
        return view
    }
    
    func updateUIView(_ uiView: TransactionView, context: Context) {
        uiView.transaction = context.transaction
    }
    
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: TransactionView
    ) {
        print("child got proposal", proposedSize)
        
        coordinator.layoutContext(children: children) { subviews, cache in
            let proposal = proposedSize.placementProposedViewSize

            let sizeReplacingUnspecifiedDimensions = proposal.replacingUnspecifiedDimensions(by: .zero)

            layout.placeSubviews(
                in: CGRect(origin: uiView.placementOrigin, size: sizeReplacingUnspecifiedDimensions),
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )

            let placementProposal = coordinator.placementsCoordinator.placements[id]?.proposal
            size = placementProposal?.replacingUnspecifiedDimensions(by: .zero) ?? .zero
        }
    }
}

