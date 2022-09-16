import Foundation
import SwiftUI

public struct PlacementProposedViewSize: Equatable {
    public var width: CGFloat?
    public var height: CGFloat?
    
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    public func replacingUnspecifiedDimensions(by size: CGSize) -> CGSize {
        CGSize(width: width ?? size.width, height: height ?? size.height)
    }
    
    public static var zero: PlacementProposedViewSize {
        PlacementProposedViewSize(width: .zero, height: .zero)
    }
    
    public static var infinity: PlacementProposedViewSize {
        PlacementProposedViewSize(width: .infinity, height: .infinity)
    }
    
    public static var unspecified: PlacementProposedViewSize {
        PlacementProposedViewSize(width: nil, height: nil)
    }
}
