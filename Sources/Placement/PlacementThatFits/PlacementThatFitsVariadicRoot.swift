//
//  PlacementThatFitsVariadicRoot.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2022-09-19.
//

import Foundation
import SwiftUI

struct PlacementThatFitsVariadicRoot: _VariadicView_MultiViewRoot {
    var coordinator: PlacementThatFitsCoordinator
    
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            let index = children.firstIndex { $0.id == child.id }
            child
                .fixedSize()
                .modifier(PlacementThatFitsChildModifier(index: index, coordinator: coordinator))
        }
    }
}
