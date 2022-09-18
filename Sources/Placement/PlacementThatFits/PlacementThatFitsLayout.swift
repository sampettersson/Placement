//
//  PlacementThatFitsLayout.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-17.
//

import Foundation
import SwiftUI

struct PlacementThatFitsLayout: PlacementLayout {    
    var coordinator: PlacementThatFitsCoordinator
    
    func makeCache(subviews: PlacementLayoutSubviews) -> Cache {
        Cache()
    }
    
    public var axes: Axis.Set
    
    func placeSubviews(in bounds: CGRect, proposal: PlacementProposedViewSize, subviews: PlacementLayoutSubviews, cache: inout Void) {
        for index in subviews.indices {
            subviews[index].place(
                at: bounds.origin,
                anchor: .topLeading,
                proposal: proposal
            )
        }
    }
    
    /// PlacementThatFitsLayout uses some internal properties of Placement to work, hence we need to always use Placements layouter
    var prefersLayoutProtocol: Bool {
        false
    }
    
    /// Layout protocol doesn't animate here, so Placement won't either
    var disablesAnimationsWhenPlacing: Bool {
        true
    }
    
    func sizeThatFits(proposal: PlacementProposedViewSize, subviews: PlacementLayoutSubviews, cache: inout Void) -> CGSize {
        for index in subviews.indices {
            let subview = subviews[index]
            let size = subview.sizeThatFits(proposal)
                        
            if axes.contains(.horizontal) && axes.contains(.vertical) {
                if size.width <= (proposal.width ?? 0) && size.height <= (proposal.height ?? 0) {
                    coordinator.indexToPlace = index
                    return size
                }
            } else if axes.contains(.horizontal) {
                if size.width <= (proposal.width ?? 0) {
                    coordinator.indexToPlace = index
                    return size
                }
            } else if axes.contains(.vertical) {
                if size.height <= (proposal.height ?? 0) {
                    coordinator.indexToPlace = index
                    return size
                }
            }
        }
        
        return .zero
    }
}
