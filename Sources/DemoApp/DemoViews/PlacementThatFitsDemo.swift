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
                PlacementThatFits(prefersViewThatFits: false) {
                    Button("Some longer text that wont fit initially") {
                      print("tap index 0")
                    }.onAppear(perform: {
                      print("did appear index 0")
                    })
                    Button("A button") {
                      print("tap index 1")
                    }.onAppear(perform: {
                      print("did appear index 1")
                    })
                }
                .border(.red)
                .frame(maxWidth: changeContainerWidth ? .infinity : 150)
                
                Button("Change container width") {
                    changeContainerWidth.toggle()
                }
            }.frame(maxWidth: .infinity)
        }
    }
}
