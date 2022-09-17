import Foundation
import SwiftUI

public protocol PlacementLayoutSubview: Equatable {
    func dimensions(in proposal: PlacementProposedViewSize) -> PlacementViewDimensions
    func place(at: CGPoint, anchor: UnitPoint, proposal: PlacementProposedViewSize)
    func sizeThatFits(_ size: PlacementProposedViewSize) -> CGSize
    var priority: Double { get }
    var spacing: PlacementViewSpacing { get }
    
    subscript<K>(key: K.Type) -> K.Value where K : PlacementLayoutValueKey { get }
}

struct LayoutSubviewPolyfill: PlacementLayoutSubview {
    var id: AnyHashable
    var onPlacement: (_ placement: LayoutPlacement) -> Void
    var getSizeThatFits: (_ size: PlacementProposedViewSize) -> CGSize
    
    public static func == (lhs: LayoutSubviewPolyfill, rhs: LayoutSubviewPolyfill) -> Bool {
        return lhs.priority == rhs.priority
    }
    
    public subscript<K>(key: K.Type) -> K.Value where K : PlacementLayoutValueKey {
        return child[key]                
    }
    
    public func place(at: CGPoint, anchor: UnitPoint, proposal: PlacementProposedViewSize) {
        onPlacement(LayoutPlacement(
            subview: self,
            position: at,
            anchor: anchor,
            proposal: proposal
        ))
    }
    
    public func dimensions(in proposal: PlacementProposedViewSize) -> PlacementViewDimensions {
        let size = sizeThatFits(proposal)
        return PlacementViewDimensions(height: size.height, width: size.width)
    }
    
    public func sizeThatFits(_ size: PlacementProposedViewSize) -> CGSize {
        return getSizeThatFits(size)        
    }
    
    public var spacing: PlacementViewSpacing
    public var priority: Double {
        return child[LayoutPriorityValueKey.self]
    }
    
    var child: _VariadicView_Children.Element
}

@available(iOS 16.0, macCatalyst 16, *)
extension LayoutSubview: PlacementLayoutSubview {
    public func dimensions(in proposal: PlacementProposedViewSize) -> PlacementViewDimensions {
        let dimension = dimensions(in: proposal.proposedViewSize)
        return PlacementViewDimensions(height: dimension.height, width: dimension.width)
    }
    
    public func place(at: CGPoint, anchor: UnitPoint, proposal: PlacementProposedViewSize) {
        place(at: at, anchor: anchor, proposal: proposal.proposedViewSize)
    }
    
    public func sizeThatFits(_ size: PlacementProposedViewSize) -> CGSize {
        sizeThatFits(size.proposedViewSize)
    }
    
    public var spacing: PlacementViewSpacing {
        PlacementViewSpacing()
    }
    
    public subscript<K>(key: K.Type) -> K.Value where K : PlacementLayoutValueKey {
        return self[LayoutValueKeyMapper<K>.Key.self]
    }
}
