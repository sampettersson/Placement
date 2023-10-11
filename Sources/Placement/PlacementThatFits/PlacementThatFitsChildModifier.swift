//
//  ThatFitsChildModifier.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2022-09-19.
//

import Foundation
import SwiftUI

struct PlacementThatFitsChildModifier: ViewModifier {
    var index: Int?
    @EnvironmentObject var placementsCoordinator: PlacementsCoordinator
    var coordinator: PlacementThatFitsCoordinator
    
    func body(content: Content) -> some View {
        if index == coordinator.indexToPlace {
            content
        } else {
            content.hidden().allowsHitTesting(false)
        }
    }
}
