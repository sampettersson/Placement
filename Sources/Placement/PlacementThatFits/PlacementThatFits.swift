//
//  PlacementThatFits.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-17.
//

import Foundation
import SwiftUI

public struct PlacementThatFits<Content: View>: View {
    /// A set of axes to constrain children to. The set may contain Axis.horizontal, Axis.vertical, or both of these. ViewThatFits chooses the first child whose size fits within the proposed size on these axes. If axes is an empty set, ViewThatFits uses the first child view. By default, ViewThatFits uses both axes.
    public var axes: Axis.Set
    
    /// A view builder that provides the child views for this container, in order of preference. The builder chooses the first child view that fits within the proposed width, height, or both, as defined by axes.
    public var content: () -> Content
    
    /// Produces a view constrained in the given axes from one of several alternatives provided by a view builder.
    public init(
        in axes: Axis.Set = [.horizontal, .vertical],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.content = content
    }
    
    public var body: some View {
        PlacementThatFitsLayout(axes: axes) {
            content()
        }
    }
}
