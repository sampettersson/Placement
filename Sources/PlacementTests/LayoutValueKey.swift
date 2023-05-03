//
//  LayoutValueKey.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2023-05-03.
//

import Foundation
import XCTest
@testable import Placement
import ViewInspector
import SwiftUI

final class LayoutValueKeyTests: XCTestCase {
    func testThatSizingIsReportedCorrectly() {
        struct TestableLayout: PlacementLayout {
            var onSubviews: (_ subviews: Subviews) -> Void
            
            var prefersLayoutProtocol: Bool {
                false
            }
            
            func placeSubviews(
                in bounds: CGRect,
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) {
                onSubviews(subviews)
            }
            
            func sizeThatFits(
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) -> CGSize {
                return .zero
            }
        }
        
        struct TestValueKey: PlacementLayoutValueKey {
            typealias Value = Int
            static var defaultValue: Value = 0
        }
        
        let exp = XCTestExpectation(description: "Should get subviews")
        
        let sut = VStack {
            TestableLayout(onSubviews: { subviews in
                XCTAssertEqual(subviews.first![TestValueKey.self], 1)
                exp.fulfill()
            }) {
                Text("view 1").placementLayoutValue(key: TestValueKey.self, value: 1)
            }
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 0.1)
    }
}
