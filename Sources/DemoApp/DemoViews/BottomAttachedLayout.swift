//
//  BottomAttachedView.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-29.
//

import Foundation

//
//  BottomAttachedLayout.swift
//  OdysseyKit
//
//  Created by Sam Pettersson on 2022-09-29.
//

import Foundation
import Placement
import SwiftUI

struct BottomAttachedLayoutHeightKey: PlacementLayoutValueKey {
    static var defaultValue: Binding<CGFloat>? = nil
}

/// A layout that attaches second view on bottom and makes top view smaller
struct BottomAttachedLayout: PlacementLayout {
    func sizeThatFits(proposal: PlacementProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions(by: .zero)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: PlacementProposedViewSize, subviews: Subviews, cache: inout ()) {
        if let mainContent = subviews.first {
            mainContent.place(at: bounds.origin, anchor: .topLeading, proposal: proposal)
        }
        
        if let bottomAttachedContent = subviews.last {
            let bottomAttachedViewSize = bottomAttachedContent.sizeThatFits(
                PlacementProposedViewSize(
                    CGSize(width: proposal.width ?? .zero, height: UIView.layoutFittingCompressedSize.height)
                )
            )
            
            print("bottom attached size", bottomAttachedViewSize)
            
            DispatchQueue.main.async {
                //subviews.first?[BottomAttachedLayoutHeightKey.self]?.wrappedValue = bottomAttachedViewSize.height
            }
                                    
            bottomAttachedContent.place(
                at: CGPoint(x: 0, y: bounds.maxY - bottomAttachedViewSize.height),
                anchor: .topLeading,
                proposal: PlacementProposedViewSize(bottomAttachedViewSize)
            )
        }
    }
}
