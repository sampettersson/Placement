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

class LayoutSizingUIView<L: PlacementLayout>: UIView {
    var coordinator: Coordinator<L>
    var children: _VariadicView.Children
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    init(coordinator: Coordinator<L>, children: _VariadicView.Children) {
        self.coordinator = coordinator
        self.children = children
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("placing")
        coordinator.placeSubviews(children: children)
    }
}

struct LayoutSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator<L>
    var layout: L
    var children: _VariadicView.Children
        
    func makeUIView(context: Context) -> LayoutSizingUIView<L> {
        let view = LayoutSizingUIView(coordinator: coordinator, children: children)
        return view
    }
    
    func updateUIView(_ uiView: LayoutSizingUIView<L>, context: Context) {}
        
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: LayoutSizingUIView<L>
    ) {
        coordinator.layoutContext(children: children) { subviews, cache in
            let proposal = proposedSize.placementProposedViewSize
            
            size = layout.sizeThatFits(
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )
            
            print("sizing layout", layout, size)
            
            uiView.setNeedsLayout()
        }
    }
}
