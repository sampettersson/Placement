//
//  PlacementThatFitsLayout.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-17.
//

import Foundation
import SwiftUI

struct PlacementThatFitsLayout: PlacementLayout {
    func makeCache(subviews: PlacementLayoutSubviews) -> Cache {
        Cache()
    }
    
    public var axes: Axis.Set
    
    struct Cache {
        var indexToPlace: Int? = nil
    }
    
    func placeSubviews(in bounds: CGRect, proposal: PlacementProposedViewSize, subviews: PlacementLayoutSubviews, cache: inout Cache) {
        if let indexToPlace = cache.indexToPlace {
            subviews[indexToPlace].place(
                at: CGPoint(x: 0, y: 0),
                anchor: .topLeading,
                proposal: proposal
            )
        }
    }
    
    var prefersNativeImplementationWhenAvailable: Bool {
        false
    }
    
    func sizeThatFits(proposal: PlacementProposedViewSize, subviews: PlacementLayoutSubviews, cache: inout Cache) -> CGSize {
        for index in subviews.indices {
            let subview = subviews[index]
            let size = subview.sizeThatFits(proposal)
            
            if axes.contains(.horizontal) && axes.contains(.vertical) {
                if size.width < (proposal.width ?? 0) && size.height < (proposal.height ?? 0) {
                    cache.indexToPlace = index
                    return size
                }
            } else if axes.contains(.horizontal) {
                if size.width < (proposal.width ?? 0) {
                    cache.indexToPlace = index
                    return size
                }
            } else if axes.contains(.vertical) {
                if size.height < (proposal.height ?? 0) {
                    cache.indexToPlace = index
                    return size
                }
            }
        }
        
        return .zero
    }
}
