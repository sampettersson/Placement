//
//  PlacementThatFits.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-17.
//

import Foundation
import SwiftUI

struct ThatFitsChildModifier: ViewModifier {
    var index: Int?
    @EnvironmentObject var placementsCoordinator: PlacementsCoordinator
    var coordinator: PlacementThatFitsCoordinator
    
    func body(content: Content) -> some View {
        if index == coordinator.indexToPlace {
            content
        } else {
            content.hidden()
        }
    }
}

struct ThatFitsVariadicRoot: _VariadicView_MultiViewRoot {
    var coordinator: PlacementThatFitsCoordinator
    
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            let index = children.firstIndex { $0.id == child.id }
            child
                .fixedSize()
                .modifier(ThatFitsChildModifier(index: index, coordinator: coordinator))
        }
    }
}

class PlacementThatFitsCoordinator: ObservableObject {
    var indexToPlace: Int? = nil
}

public struct PlacementThatFits<Content: View>: View {
    @StateObject var coordinator = PlacementThatFitsCoordinator()
    
    /// A set of axes to constrain children to. The set may contain Axis.horizontal, Axis.vertical, or both of these. PlacementThatFits chooses the first child whose size fits within the proposed size on these axes. If axes is an empty set, PlacementThatFits uses the first child view. By default, PlacementThatFits uses both axes.
    public var axes: Axis.Set
    
    /// A view builder that provides the child views for this container, in order of preference. The builder chooses the first child view that fits within the proposed width, height, or both, as defined by axes.
    public var content: () -> Content
    
    public var prefersLayoutProtocol: Bool
    
    /// Produces a view constrained in the given axes from one of several alternatives provided by a view builder.
    public init(
        in axes: Axis.Set = [.horizontal, .vertical],
        prefersLayoutProtocol: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.prefersLayoutProtocol = true
        self.content = content
    }
    
    public var body: some View {
        if #available(iOS 16.0, macCatalyst 16, *) {
            ViewThatFits(in: axes) {
                content()
            }
        } else {
            PlacementThatFitsLayout(coordinator: coordinator, axes: axes) {
                _VariadicView.Tree(
                    ThatFitsVariadicRoot(
                        coordinator: coordinator
                    )
                ) {
                    content()
                }
            }
        }
    }
}
