//
//  PlacementIntrinsicSizeReader.swift
//  Placement
//
//  Created by Sam Pettersson on 2022-10-04.
//

import Foundation
import SwiftUI

struct PlacementIntrinsicSizesPreferenceKey: PreferenceKey {
    typealias Value = [AnyHashable: CGSize]

    static var defaultValue: Value = [:]

    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = value.merging(nextValue()) { _, rhs in
            rhs
        }
    }
}

struct PlacementIntrinsicSizeReader: View {
    var id: AnyHashable
    
    var body: some View {
        GeometryReader(content: { proxy in
            Color.clear.preference(
                key: PlacementIntrinsicSizesPreferenceKey.self,
                value: [id: proxy.size]
            )
        }).animation(nil)
    }
}
