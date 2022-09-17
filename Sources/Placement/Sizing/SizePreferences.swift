import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ChildrenIntrinsicSizesKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGSize] = [:]

    static func reduce(value: inout [AnyHashable: CGSize], nextValue: () -> [AnyHashable: CGSize]) {
        let nextValue = nextValue()
        value = value.merging(nextValue, uniquingKeysWith: { _, rhs in
            rhs
        })
    }
}

struct AccumulatedSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let nextValue = nextValue()
        value = CGSize(width: value.width + nextValue.width, height: value.height + nextValue.height)
    }
}
