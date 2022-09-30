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
        
    func makeUIView(context: Context) -> TransactionView {
        let view = TransactionView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: TransactionView, context: Context) {}
        
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
        }
    }
}
