import Foundation
import SwiftUI

extension SwiftUI._ProposedSize {
    public var height: CGFloat? {
        Mirror(reflecting: self).children.compactMap { label, value in
            label == "height" ? value as? CGFloat : nil
        }.first
    }
    
    public var width: CGFloat? {
        Mirror(reflecting: self).children.compactMap { label, value in
            label == "width" ? value as? CGFloat : nil
        }.first
    }
    
    var placementProposedViewSize: PlacementProposedViewSize {
        PlacementProposedViewSize(width: width, height: height)
    }
}

