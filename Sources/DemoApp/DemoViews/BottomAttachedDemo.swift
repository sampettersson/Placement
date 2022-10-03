//
//  BottomAttachedDemo.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-29.
//

import Foundation
import SwiftUI
import Placement

struct VStackLayout: PlacementLayout {
    func sizeThatFits(proposal: PlacementProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(PlacementProposedViewSize(width: proposal.width, height: .zero))
            totalHeight += subviewSize.height + 10
            maxWidth = max(maxWidth, subviewSize.width)
        }
                        
        return CGSize(width: maxWidth, height: totalHeight)
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout ()) {
            var nextY = bounds.origin.y
                                
            for subview in subviews {
                let subviewSize = subview.sizeThatFits(PlacementProposedViewSize(width: proposal.width, height: .zero))
                
                subview.place(
                    at: CGPoint(x: bounds.origin.x, y: nextY),
                    anchor: .topLeading,
                    proposal: PlacementProposedViewSize(subviewSize)
                )
                
                nextY += subviewSize.height + 10
            }
    }
}

struct ExpandingView: View {
    @State var isOpen: Bool = false
    
    var body: some View {
        Button("Click me") {
            withAnimation(.spring()) {
                isOpen.toggle()
            }
        }
        .padding(.bottom, isOpen ? 100 : 0)
    }
}

struct BottomAttachedDemo: View {
    var body: some View {
        BottomAttachedLayout {
            ScrollView {
                VStack {
                    Text("Hello").background(GeometryReader(content: { proxy in
                        Color.clear
                    }))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
            }
            VStackLayout {
                VStackLayout {
                    ExpandingView()
                        .background(Color.red)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("BottomAttachedDemo")
    }
}
