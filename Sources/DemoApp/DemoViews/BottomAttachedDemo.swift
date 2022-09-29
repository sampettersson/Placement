//
//  BottomAttachedDemo.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-29.
//

import Foundation
import SwiftUI

struct BottomAttachedDemo: View {
    var body: some View {
        BottomAttachedLayout {
            ScrollView {
                Text("Hello")
            }
            Text("sjlkjklfdsjkldfjklfkjlsdfjlkfdjksdjklfdjkfdjldsfjlfdsljfsd")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
