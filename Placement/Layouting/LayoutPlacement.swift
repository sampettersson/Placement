import Foundation
import SwiftUI

struct LayoutPlacement: Equatable {
    static func == (lhs: LayoutPlacement, rhs: LayoutPlacement) -> Bool {
        if let lhsSubview = lhs.subview as? LayoutSubviewPolyfill,
           let rhsSubview = rhs.subview as? LayoutSubviewPolyfill {
            if lhsSubview.id != rhsSubview.id {
                return false
            }
        }
        
        if lhs.position != rhs.position {
            return false
        }
        
        if lhs.anchor != rhs.anchor {
            return false
        }
        
        if lhs.proposal != rhs.proposal {
            return false
        }
        
        return true
    }
    
    var subview: any PlacementLayoutSubview
    var position: CGPoint
    var anchor: UnitPoint
    var proposal: PlacementProposedViewSize
}
