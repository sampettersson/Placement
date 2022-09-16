import Foundation
import SwiftUI

@available(iOS 16.0, macCatalyst 16, *)
extension ViewSpacing {
    var placement: PlacementViewSpacing {
        PlacementViewSpacing(underlyingViewSpacing: self)
    }
}

public struct PlacementViewSpacing {
    private var _underlyingViewSpacing: Any? = nil
    
    @available(iOS 16.0, macCatalyst 16, *)
    var underlyingViewSpacing: ViewSpacing {
        get {
            _underlyingViewSpacing as! ViewSpacing
        }
        set {
            _underlyingViewSpacing = newValue
        }
    }
    
    public init() {
        if #available(iOS 16.0, macCatalyst 16, *) {
            _underlyingViewSpacing = ViewSpacing()
        }
    }
    
    @available(iOS 16.0, macCatalyst 16, *)
    init(underlyingViewSpacing: ViewSpacing) {
        _underlyingViewSpacing = underlyingViewSpacing.placement
    }
    
    public static let zero = Self.init()
    
    public func distance(to next: PlacementViewSpacing, along axis: Axis) -> CGFloat {
        if #available(iOS 16.0, macCatalyst 16, *) {
            return underlyingViewSpacing.distance(
                to: next.underlyingViewSpacing,
                along: axis
            )
        } else {
            return 0
        }
    }
    
    public mutating func formUnion(_ other: PlacementViewSpacing, edges: Edge.Set = .all) {
        if #available(iOS 16.0, macCatalyst 16, *) {
            underlyingViewSpacing.formUnion(other.underlyingViewSpacing, edges: edges)
        }
    }
    
    public func union(_ other: PlacementViewSpacing, edges: Edge.Set = .all) -> PlacementViewSpacing {
        if #available(iOS 16.0, macCatalyst 16, *) {
            return underlyingViewSpacing.union(other.underlyingViewSpacing, edges: edges).placement
        } else {
            return PlacementViewSpacing()
        }
    }
}
