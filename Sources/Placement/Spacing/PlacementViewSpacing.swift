import Foundation
import SwiftUI

@available(iOS 16.0, macCatalyst 16, *)
extension ViewSpacing {
    var placement: PlacementViewSpacing {
        PlacementViewSpacing(underlyingViewSpacing: self)
    }
}

/// A collection of the geometric spacing preferences of a view.
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
    
    /// Initializes an instance with default spacing values.
    public init() {
        if #available(iOS 16.0, macCatalyst 16, *) {
            _underlyingViewSpacing = ViewSpacing()
        }
    }
    
    @available(iOS 16.0, macCatalyst 16, *)
    init(underlyingViewSpacing: ViewSpacing) {
        _underlyingViewSpacing = underlyingViewSpacing.placement
    }
    
    /// A view spacing instance that contains zero on all edges.
    public static let zero = Self.init()
    
    /// Gets the preferred spacing distance along the specified axis to the view that returns a specified spacing preference.
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
    
    /// Merges the spacing preferences of another spacing instance with this instance for a specified set of edges.
    public mutating func formUnion(_ other: PlacementViewSpacing, edges: Edge.Set = .all) {
        if #available(iOS 16.0, macCatalyst 16, *) {
            underlyingViewSpacing.formUnion(other.underlyingViewSpacing, edges: edges)
        }
    }
    
    /// Gets a new value that merges the spacing preferences of another spacing instance with this instance for a specified set of edges.
    public func union(_ other: PlacementViewSpacing, edges: Edge.Set = .all) -> PlacementViewSpacing {
        if #available(iOS 16.0, macCatalyst 16, *) {
            return underlyingViewSpacing.union(other.underlyingViewSpacing, edges: edges).placement
        } else {
            return PlacementViewSpacing()
        }
    }
}
