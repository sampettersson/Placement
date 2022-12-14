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
                        
        return CGSize(width: maxWidth, height: totalHeight - 10)
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
    @State var insertView: Bool = false
    @State var textValue: String = ""
    
    var body: some View {
        BottomAttachedLayout {
            ScrollView {
                VStack {
                    Text("Hello").background(GeometryReader(content: { proxy in
                        Color.clear
                    }))
                    
                    Button("Insert view") {
                        withAnimation(.spring()) {
                            insertView.toggle()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
            }
            VStackLayout {
                TextField("hello", text: $textValue)
                Color.red.frame(width: 10, height: 10)
                VStackLayout {
                    Color.blue.frame(width: 10, height: 10)
                    VStackLayout {
                        ExpandingView()
                            .background(Color.red)
                            .frame(maxWidth: .infinity)
                        
                        if insertView {
                            ExpandingView()
                                .background(Color.red)
                                .frame(maxWidth: .infinity)
                            
                            ForEach(0..<10) { offset in
                                Color.blue.frame(width: 10, height: 10)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("BottomAttachedDemo")
    }
}
