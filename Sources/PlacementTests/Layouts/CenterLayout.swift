//
//  CenterLayout.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2022-09-19.
//

import Foundation
@testable import Placement

public struct CenterLayout: PlacementLayout {
    var nativeImplementation: Bool
    
    public func sizeThatFits(
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout ()
    ) -> CGSize {
        return CGSize(
            width: proposal.width ?? 0,
            height: proposal.height ?? 0
        )
    }
    
    public func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout ()
    ) {
        for index in subviews.indices {
          print(index)

            let subview = subviews[index]
            let dimension = subview.dimensions(in: proposal)
            
            subview.place(
                at: CGPoint(x: bounds.midX, y: bounds.midY),
                anchor: .center,
                proposal: PlacementProposedViewSize(width: dimension.width, height: dimension.height)
            )
        }
    }
    
    public var prefersLayoutProtocol: Bool {
        nativeImplementation
    }
}
