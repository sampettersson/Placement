import Foundation
import SwiftUI

public protocol PlacementLayoutValueKey: _ViewTraitKey {
    static var defaultValue: Value { get }
}

struct LayoutPriorityValueKey: PlacementLayoutValueKey {
    static var defaultValue: Double {
        0.0
    }
}

@available(iOS 16, OSX 13, *)
struct LayoutValueKeyMapper<K: PlacementLayoutValueKey> {
    struct Key: PlacementLayoutValueKey {
        static var defaultValue: K.Value {
            K.defaultValue
        }
        
        typealias Value = K.Value
    }
}

extension View {
    public func layoutValue<K>(
        key: K.Type,
        value: K.Value
    ) -> some View where K : PlacementLayoutValueKey {
        if #available(iOS 16.0, macCatalyst 16, *) {
            return self.layoutValue(key: LayoutValueKeyMapper<K>.Key.self, value: value)
        } else {
            return self._trait(key, value)
        }
    }
    
    public func placementLayoutPriority(_ value: Double) -> some View {
        self._trait(LayoutPriorityValueKey.self, value).layoutPriority(value)
    }
}
