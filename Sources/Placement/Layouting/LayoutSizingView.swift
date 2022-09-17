import Foundation
import SwiftUI

class TransactionView: UIView {
    var transaction = Transaction()
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

struct LayoutSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator<L>
    var layout: L
    var children: _VariadicView.Children
    var childrenIntrinsicSizes: [AnyHashable: CGSize]
        
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
        coordinator.layoutContext(children: children) { subviews, cache in
            let proposal = proposedSize.placementProposedViewSize
            
            size = layout.sizeThatFits(
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )
            
            coordinator.sizeCoordinator.size = size
            
            let previousPlacements = coordinator.placementsCoordinator.placements
                        
            layout.placeSubviews(
                in: CGRect(origin: .zero, size: proposal.replacingUnspecifiedDimensions(by: .zero)),
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )
            
            if previousPlacements != coordinator.placementsCoordinator.placements {
                DispatchQueue.main.async {
                    withTransaction(uiView.transaction) {
                        coordinator.placementsCoordinator.objectWillChange.send()
                    }
                }
            }
        }
    }
}
