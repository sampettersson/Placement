import Foundation
import SwiftUI

class TransactionView: UIView {
    var transaction = Transaction()
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("frame is", self.frame)
    }
    
    var placementOrigin: CGPoint {
        let window = self.window
        let originInWindow = self.convert(self.bounds.origin, to: window)
        let safeAreaTop = (window?.safeAreaInsets.top ?? 0)
        let safeAreaLeft = (window?.safeAreaInsets.left ?? 0)
                
        return CGPoint(
            x: originInWindow.x - safeAreaLeft,
            y: originInWindow.y - safeAreaTop
        )
    }
}

class LayoutSizingViewUIKit: UIView {
    var transaction = Transaction()
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("frame is", self.frame)
    }
    
    var placementOrigin: CGPoint {
        let window = self.window
        let originInWindow = self.convert(self.bounds.origin, to: window)
        let safeAreaTop = (window?.safeAreaInsets.top ?? 0)
        let safeAreaLeft = (window?.safeAreaInsets.left ?? 0)
                
        return CGPoint(
            x: originInWindow.x - safeAreaLeft,
            y: originInWindow.y - safeAreaTop
        )
    }
}

struct LayoutSizingView<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator<L>
    var layout: L
    var children: _VariadicView.Children
    var childrenIntrinsicSizes: [AnyHashable: CGSize]
        
    func makeUIView(context: Context) -> LayoutSizingViewUIKit {
        let view = LayoutSizingViewUIKit(frame: .zero)
        view.transaction = context.transaction
        return view
    }
    
    func updateUIView(_ uiView: LayoutSizingViewUIKit, context: Context) {
        uiView.transaction = context.transaction
    }
        
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: LayoutSizingViewUIKit
    ) {
        coordinator.sizeCoordinator.origin = uiView.placementOrigin
                
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
