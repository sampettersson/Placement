import Foundation
import SwiftUI

public struct PlacementLayoutProperties {
    var stackOrientation: Axis?
    
    public init() {
        self.stackOrientation = nil
    }
    
    @available(iOS 16.0, macCatalyst 16, *)
    var native: PlacementLayoutProperties {
        var properties = PlacementLayoutProperties()
        properties.stackOrientation = stackOrientation
        return properties
    }
}
