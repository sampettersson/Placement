import Foundation
import SwiftUI

/// A proposal for the size of a view.
public struct PlacementProposedViewSize: Equatable, Sendable {
    /// The proposed horizontal size measured in points.
    public var width: CGFloat?
    
    /// The proposed vertical size measured in points.
    public var height: CGFloat?
    
    /// Creates a new proposed size using the specified width and height.
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    /// Creates a new proposed size from a specified size.
    public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    /// Creates a new proposal that replaces unspecified dimensions in this proposal with the corresponding dimension of the specified size.
    public func replacingUnspecifiedDimensions(by size: CGSize) -> CGSize {
        CGSize(width: width ?? size.width, height: height ?? size.height)
    }
    
    /// A size proposal that contains zero in both dimensions.
    public static var zero: PlacementProposedViewSize {
        PlacementProposedViewSize(width: .zero, height: .zero)
    }
    
    /// A size proposal that contains infinity in both dimensions.
    public static var infinity: PlacementProposedViewSize {
        PlacementProposedViewSize(width: .infinity, height: .infinity)
    }
    
    /// The proposed size with both dimensions left unspecified.
    public static var unspecified: PlacementProposedViewSize {
        PlacementProposedViewSize(width: nil, height: nil)
    }
    
    /// Indicates whether two proposed view sizes are equal.
    public static func == (lhs: PlacementProposedViewSize, rhs: PlacementProposedViewSize) -> Bool {
        lhs.width == rhs.width && lhs.height == lhs.height
    }
    
    /// Indicates whether two proposed view sizes are unequal.
    public static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.width != rhs.width || lhs.height != rhs.height
    }
}
