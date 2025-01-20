//
//  PlacementThatFits.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-17.
//

import Foundation
import SwiftUI

/// A view that adapts to the available space by providing the first child view that fits.
public struct PlacementThatFits<Content: View>: View {
    @StateObject var coordinator = PlacementThatFitsCoordinator()
    
    /// A set of axes to constrain children to. The set may contain Axis.horizontal, Axis.vertical, or both of these. PlacementThatFits chooses the first child whose size fits within the proposed size on these axes. If axes is an empty set, PlacementThatFits uses the first child view. By default, PlacementThatFits uses both axes.
    public var axes: Axis.Set
    
    /// A view builder that provides the child views for this container, in order of preference. The builder chooses the first child view that fits within the proposed width, height, or both, as defined by axes.
    public var content: () -> Content
    
    /// Should Placement use ViewThatFits when available or always use PlacementLayout
    public var prefersViewThatFits: Bool
    
    /// Produces a view constrained in the given axes from one of several alternatives provided by a view builder.
    ///
    /// - parameter axes: A set of axes to constrain children to. The set may contain Axis.horizontal, Axis.vertical, or both of these. PlacementThatFits chooses the first child whose size fits within the proposed size on these axes. If axes is an empty set, PlacementThatFits uses the first child view. By default, PlacementThatFits uses both axes.
    /// - parameter prefersViewThatFits: Should Placement use ViewThatFits when available or always use PlacementLayout
    /// - parameter content: A view builder that provides the child views for this container, in order of preference. The builder chooses the first child view that fits within the proposed width, height, or both, as defined by axes.
    public init(
        in axes: Axis.Set = [.horizontal, .vertical],
        prefersViewThatFits: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.prefersViewThatFits = prefersViewThatFits
        self.content = content
    }
    
    public var body: some View {
        if #available(iOS 16.0, macCatalyst 16, tvOS 16.0, *), prefersViewThatFits {
            ViewThatFits(in: axes) {
                content()
            }
        } else {
            PlacementThatFitsLayout(coordinator: coordinator, axes: axes) {
                _VariadicView.Tree(
                    PlacementThatFitsVariadicRoot(
                        coordinator: coordinator
                    )
                ) {
                    content()
                }
            }
        }
    }
}
