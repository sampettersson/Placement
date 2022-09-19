//
//  PlacementThatFits.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2022-09-19.
//

import Foundation
import Placement
import SwiftUI

struct PlacementThatFitsDemo: View {
    @State var changeContainerWidth = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PlacementThatFits(in: [.horizontal], prefersViewThatFits: false) {
                    Text("Some longer text that wont fit initially")
                    Text("Some text")
                }
                .frame(maxWidth: changeContainerWidth ? .infinity : 150)
                
                Button("Change container width") {
                    changeContainerWidth.toggle()
                }
            }.frame(maxWidth: .infinity)
        }
    }
}
