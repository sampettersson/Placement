import Foundation
import SwiftUI

extension SwiftUI._ProposedSize {
    public var height: CGFloat {
        Mirror(reflecting: self).children.compactMap { label, value in
            label == "height" ? value as? CGFloat : nil
        }.first ?? .zero
    }
    
    public var width: CGFloat {
        Mirror(reflecting: self).children.compactMap { label, value in
            label == "width" ? value as? CGFloat : nil
        }.first ?? .zero
    }
    
    public var cgSize: CGSize {
        CGSize(width: width, height: height)
    }
}

