import Foundation
import SwiftUI

class PlacementLayoutContainer: UIView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}

struct LayoutSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator<L>
    var layout: L
    var children: _VariadicView.Children
    @Binding var intrinsicSizes: [AnyHashable: CGSize]
    @Binding var keyboardFrame: CGRect
        
    func makeUIView(context: Context) -> PlacementLayoutContainer {
        let view = PlacementLayoutContainer()
        return view
    }
    
    func updateUIView(_ uiView: PlacementLayoutContainer, context: Context) {}
        
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: PlacementLayoutContainer
    ) {
        coordinator.layoutContext { subviews, cache in
            let proposal = proposedSize.placementProposedViewSize
            
            size = layout.sizeThatFits(
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )            
        }
    }
}
