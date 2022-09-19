//
//  PlacementLayoutTests.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2022-09-19.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import Placement

final class PlacementLayoutTests: XCTestCase {
    func testThatLayoutMethodsAreCalled() {
        let placeSubviewsExp = XCTestExpectation(description: "Expect placeSubviews to be called")
        let sizeThatFitsExp = XCTestExpectation(description: "Expect placeSubviews to be called")
        
        struct TestableLayout: PlacementLayout {
            var placeSubviewsExp: XCTestExpectation
            var sizeThatFitsExp: XCTestExpectation
            
            var prefersLayoutProtocol: Bool {
                false
            }
            
            func placeSubviews(
                in bounds: CGRect,
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) {
                placeSubviewsExp.fulfill()
            }
            
            func sizeThatFits(
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) -> CGSize {
                sizeThatFitsExp.fulfill()
                return .zero
            }
        }
        
        let sut = TestableLayout(
            placeSubviewsExp: placeSubviewsExp,
            sizeThatFitsExp: sizeThatFitsExp
        ) {
            Text("Content")
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [placeSubviewsExp, sizeThatFitsExp], timeout: 0.1)
    }
    
    func testThatProposalIsParentSize() {
        let proposalIsParentSizeExp = XCTestExpectation(description: "Expect proposal to be parent size")
        let size = CGSize(width: 100, height: 100)
        
        struct TestableLayout: PlacementLayout {
            var expectSize: CGSize
            var proposalIsParentSizeExp: XCTestExpectation
            
            var prefersLayoutProtocol: Bool {
                false
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
                if proposal.height == expectSize.height && proposal.width == expectSize.width {
                    proposalIsParentSizeExp.fulfill()
                }
                
                return .zero
            }
        }
        
        let sut = TestableLayout(
            expectSize: size,
            proposalIsParentSizeExp: proposalIsParentSizeExp
        ) {
            Text("Content")
        }.frame(width: size.width, height: size.height)
        
        ViewHosting.host(view: sut)
        
        wait(for: [proposalIsParentSizeExp], timeout: 0.1)
    }
    
    func testThatUpdateCacheIsCalled() {
        let updateCacheIsCalledExp = XCTestExpectation(description: "Expect update cache to be called")
        
        struct TestableLayout: PlacementLayout {
            var updateCacheIsCalledExp: XCTestExpectation
            
            var prefersLayoutProtocol: Bool {
                false
            }
            
            func placeSubviews(
                in bounds: CGRect,
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) {
            }
            
            func updateCache(_ cache: inout (), subviews: Subviews) {
                updateCacheIsCalledExp.fulfill()
            }
            
            func sizeThatFits(
                proposal: PlacementProposedViewSize,
                subviews: Subviews,
                cache: inout Void
            ) -> CGSize {
                return .zero
            }
        }
        
        struct UpdateContentView<Content: View>: View, Inspectable {
            @State var flag: Bool = false
            var content: (_ flag: Bool) -> Content
            internal var didAppear: ((Self) -> Void)?
            
            var body: some View {
                VStack {
                    Button(action: {
                        self.flag.toggle()
                    }, label: { EmptyView() })
                    .onAppear { self.didAppear?(self) }
                    content(flag)
                }
            }
        }
        
        var sut = UpdateContentView { flag in
            TestableLayout(
                updateCacheIsCalledExp: updateCacheIsCalledExp
            ) {
                Text("Content")
                
                if flag {
                    Color.red
                }
            }
        }
        
        let didAppearExp = sut.on(\.didAppear) { view in
            try view.vStack().first?.button().tap()
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [updateCacheIsCalledExp, didAppearExp], timeout: 0.1)
    }
}
