//
//  CenterLayout.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-17.
//

import Foundation
import SwiftUI
import Placement

public struct CenterLayout: PlacementLayout {
    var nativeImplementation: Bool
    
    public func sizeThatFits(
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout ()
    ) -> CGSize {
        return CGSize(
            width: proposal.width ?? 0,
            height: proposal.height ?? 0
        )
    }
    
    public func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout ()
    ) {        
        for index in subviews.indices {
            let subview = subviews[index]
            let dimension = subview.dimensions(in: proposal)
            
            subview.place(
                at: CGPoint(x: bounds.midX, y: bounds.midY),
                anchor: .center,
                proposal: PlacementProposedViewSize(width: dimension.width, height: dimension.height)
            )
        }
    }
    
    public var prefersLayoutProtocol: Bool {
        nativeImplementation
    }
}

struct CenterLayoutDemo: View {
    @State var changeLayout = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Layout below uses SwiftUI.Layout (on iOS 16)")
                
                CenterLayout(nativeImplementation: true) {
                    Text("View 1")
                        .padding(changeLayout ? 10 : 20)
                        .border(.red)
                }
                .border(.blue)
                .padding()
                .frame(width: 300, height: 200)
                
                Text("Layout below uses Placement")
                
                CenterLayout(nativeImplementation: false) {
                    Text("View 1")
                        .padding(changeLayout ? 10 : 20)
                        .border(.red)
                }
                .border(.blue)
                .padding()
                .frame(width: 300, height: changeLayout ? 150 : 200)
                
                Button("Change layout") {
                    withAnimation(.spring()) {
                        changeLayout.toggle()
                    }
                }
            }
        }
    }
}
