//
//  LayoutSizingTests.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2022-09-19.
//

import Foundation
import XCTest
@testable import Placement
import ViewInspector
import SwiftUI

final class LayoutSizingTests: XCTestCase {
    func testThatSizingIsReportedCorrectly() {
        struct TestableLayout: PlacementLayout {
            var nativeImplementation: Bool
            var onSize: (_ size: CGSize) -> Void
            
            var prefersLayoutProtocol: Bool {
                nativeImplementation
            }
            
            func placeSubviews(
                in bounds: CGRect,
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) {
                
            }
            
            func sizeThatFits(
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) -> CGSize {
                
                for index in subviews.indices {
                    onSize(subviews[index].sizeThatFits(.infinity))
                }
                
                return .zero
            }
        }
        
        let nativeSizeExp = XCTestExpectation(description: "expect sizes to be determined")
        let placementSizeExp = XCTestExpectation(description: "expect sizes to be determined")
        
        var nativeSize: CGSize? = nil
        var placementSize: CGSize? = nil
        
        struct Content: View, Inspectable {
            var didAppear: ((Self) -> Void)?
            var onNativeSize: (_ size: CGSize) -> Void
            var onPlacementSize: (_ size: CGSize) -> Void
            
            var body: some View {
                VStack {
                    TestableLayout(
                        nativeImplementation: true,
                        onSize: { size in
                            onNativeSize(size)
                        }
                    ) {
                        Text("Content")
                    }
                    
                    TestableLayout(
                        nativeImplementation: false,
                        onSize: { size in
                            onPlacementSize(size)
                        }
                    ) {
                        Text("Content")
                    }
                }.onAppear {
                    didAppear?(self)
                }
            }
        }
        
        var sut = Content { size in
            nativeSize = size
            nativeSizeExp.fulfill()
        } onPlacementSize: { size in
            placementSize = size
            placementSizeExp.fulfill()
        }
        
        let didAppearExp = sut.on(\.didAppear) { view in
            XCTAssertEqual(nativeSize, placementSize)
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [nativeSizeExp, placementSizeExp, didAppearExp], timeout: 0.1)
    }
}
