import Foundation
import SwiftUI

/// A key for accessing a layout value of a layout container’s subviews.
public protocol PlacementLayoutValueKey: _ViewTraitKey {
    /// The type of the key’s value.
    associatedtype Value
    
    /// The default value of the key.
    static var defaultValue: Value { get }
}

struct LayoutPriorityValueKey: PlacementLayoutValueKey {
    static var defaultValue: Double {
        0.0
    }
}

@available(iOS 16, OSX 13, *)
struct LayoutValueKeyMapper<K: PlacementLayoutValueKey> {
    struct Key: LayoutValueKey {
        static var defaultValue: K.Value {
            K.defaultValue
        }
        
        typealias Value = K.Value
    }
}

extension View {
    /// Associates a value with a custom layout property for PlacementLayout
    ///
    /// - parameter key: The type of the key that you want to set a value for. Create the key as a type that conforms to the PlacementLayoutValueKey protocol.
    /// - parameter value: The value to assign to the key for this view. The value must be of the type that you establish for the key’s associated value when you implement the key’s defaultValue property.
    public func placementLayoutValue<K>(
        key: K.Type,
        value: K.Value
    ) -> some View where K : PlacementLayoutValueKey {
        if #available(iOS 16.0, macCatalyst 16, *) {
            return self.layoutValue(key: LayoutValueKeyMapper<K>.Key.self, value: value)
        } else {
            return self._trait(key, value)
        }
    }
    
    /// Associates a layoutPriority for PlacementLayout
    ///
    /// - parameter value: The layoutPriority to use
    public func placementLayoutPriority(_ value: Double) -> some View {
        self._trait(LayoutPriorityValueKey.self, value).layoutPriority(value)
    }
}
