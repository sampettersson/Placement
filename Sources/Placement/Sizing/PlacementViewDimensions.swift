import Foundation

/// A view’s size in its own coordinate space.
public struct PlacementViewDimensions: Equatable {
    /// The view’s height.
    public var height: CGFloat
    /// The view’s width.
    public var width: CGFloat
    
    /// Indicates whether two view dimensions are equal.
    public static func ==(lhs: PlacementViewDimensions, rhs: PlacementViewDimensions) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height
    }
    
    /// Indicates whether two view dimensions are unequal.
    public static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.width != rhs.width || lhs.height != rhs.height
    }
}
