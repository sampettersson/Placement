import Foundation
import SwiftUI

struct ChildrenIntrinsicSizesKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGSize] = [:]

    static func reduce(value: inout [AnyHashable: CGSize], nextValue: () -> [AnyHashable: CGSize]) {
        let nextValue = nextValue()
        value = value.merging(nextValue, uniquingKeysWith: { _, rhs in
            rhs
        })
    }
}
