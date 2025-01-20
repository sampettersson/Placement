import Foundation
import SwiftUI

/// Layout-specific properties of a layout container.
public struct PlacementLayoutProperties {
    /// The orientation of the containing stack-like container.
    var stackOrientation: Axis?
    
    /// Creates a default set of properties.
    public init() {
        self.stackOrientation = nil
    }
    
    @available(iOS 16.0, macCatalyst 16, tvOS 16.0, *)
    var native: PlacementLayoutProperties {
        var properties = PlacementLayoutProperties()
        properties.stackOrientation = stackOrientation
        return properties
    }
}
