//
//  ShouldAdjustToKeyboard.swift
//  Placement
//
//  Created by Sam Pettersson on 2022-10-06.
//

import Foundation
import SwiftUI

private struct PlacementShouldAdjustToKeyboardKey: EnvironmentKey {
  static let defaultValue = true
}

extension EnvironmentValues {
  var placementShouldAdjustToKeyboard: Bool {
    get { self[PlacementShouldAdjustToKeyboardKey.self] }
    set { self[PlacementShouldAdjustToKeyboardKey.self] = newValue }
  }
}
