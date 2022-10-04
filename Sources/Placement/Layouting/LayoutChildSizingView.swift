import Foundation
import SwiftUI

class PlacementLayoutChildSizingUIView<L: PlacementLayout>: UIView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}

struct LayoutChildSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var placementsCoordinator: PlacementsCoordinator
    @EnvironmentObject var coordinator: Coordinator<L>

    var layout: L
    var id: AnyHashable
    var children: _VariadicView.Children
        
    func makeUIView(context: Context) -> PlacementLayoutChildSizingUIView<L> {
        let view = PlacementLayoutChildSizingUIView<L>(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: PlacementLayoutChildSizingUIView<L>, context: Context) {
    }
    
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: PlacementLayoutChildSizingUIView<L>
    ) {
        let placementProposal = coordinator.placementsCoordinator.placements[id]?.proposal
        size = placementProposal?.replacingUnspecifiedDimensions(by: .zero) ?? .zero        
    }
}

