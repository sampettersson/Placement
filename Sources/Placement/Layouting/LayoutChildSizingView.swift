import Foundation
import SwiftUI

struct LayoutChildSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var placementsCoordinator: PlacementsCoordinator
    @EnvironmentObject var coordinator: Coordinator<L>

    var layout: L
    var id: AnyHashable
    var children: _VariadicView.Children
        
    func makeUIView(context: Context) -> TransactionView {
        let view = TransactionView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: TransactionView, context: Context) {
    }
    
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: TransactionView
    ) {
        let placementProposal = coordinator.placementsCoordinator.placements[id]?.proposal
        size = placementProposal?.replacingUnspecifiedDimensions(by: .zero) ?? .zero        
    }
}

