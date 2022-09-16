import Foundation
import SwiftUI

public struct PlacementLayoutProperties {
    var stackOrientation: Axis?
    
    public init() {
        self.stackOrientation = nil
    }
    
    @available(iOS 16, *)
    var native: LayoutProperties {
        var properties = LayoutProperties()
        properties.stackOrientation = stackOrientation
        return properties
    }
}
