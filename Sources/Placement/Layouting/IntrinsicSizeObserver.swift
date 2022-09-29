//
//  IntrinsicSizeObserver.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-29.
//

import Foundation
import SwiftUI

class IntrinsicObserverView: UIView {
    var transaction = Transaction()
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

struct IntrinsicSizeObserver<L: PlacementLayout>: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator<L>
        
    func makeUIView(context: Context) -> IntrinsicObserverView {
        let view = IntrinsicObserverView(frame: .zero)
        view.transaction = context.transaction
        return view
    }
    
    func updateUIView(_ uiView: IntrinsicObserverView, context: Context) {
        uiView.transaction = context.transaction
    }
    
    func _overrideSizeThatFits(
        _ size: inout CoreGraphics.CGSize,
        in proposedSize: SwiftUI._ProposedSize,
        uiView: IntrinsicObserverView
    ) {
       print(proposedSize)
    }
}
