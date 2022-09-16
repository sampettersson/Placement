import Foundation
import SwiftUI

public struct PlacementLayoutSubviews: BidirectionalCollection, Collection, Comparable {
    public subscript(position: Int) -> any PlacementLayoutSubview {
        subviews[position]
    }
    
    public func index(before i: Int) -> Int {
        subviews.index(before: i)
    }
    
    public func index(after i: Int) -> Int {
        subviews.index(after: i)
    }
    
    public var startIndex: Int {
        subviews.startIndex
    }
    
    public var endIndex: Int {
        subviews.endIndex
    }
    
    public static func < (lhs: PlacementLayoutSubviews, rhs: PlacementLayoutSubviews) -> Bool {
        lhs.subviews.count < rhs.subviews.count
    }
    
    public static func == (lhs: PlacementLayoutSubviews, rhs: PlacementLayoutSubviews) -> Bool {
        if #available(iOS 16.0, macCatalyst 16, *) {
            let castedLhs = lhs.subviews as? [LayoutSubview]
            let castedRhs = rhs.subviews as? [LayoutSubview]
            return castedLhs == castedRhs
        } else {
            let castedLhs = lhs.subviews as? [LayoutSubviewPolyfill]
            let castedRhs = rhs.subviews as? [LayoutSubviewPolyfill]
            return castedLhs == castedRhs
        }
    }
    
    private var subviews: [any PlacementLayoutSubview]
    
    public typealias Index = Int
    public typealias Element = any PlacementLayoutSubview
    
    var layoutDirection: LayoutDirection
    
    public var count: Int {
        subviews.count
    }
    
    public var first: Element? {
        subviews.first
    }
    
    public var isEmpty: Bool {
        subviews.isEmpty
    }
    
    public var underestimatedCount: Int {
        subviews.underestimatedCount
    }
    
    init(subviews: [any PlacementLayoutSubview]) {
        self.subviews = subviews
        self.layoutDirection = .leftToRight
    }
}
