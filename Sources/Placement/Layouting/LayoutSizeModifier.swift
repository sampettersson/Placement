import Foundation
import SwiftUI

struct LayoutSizeModifier<L: PlacementLayout>: ViewModifier {
    @EnvironmentObject var placementsCoordinator: PlacementsCoordinator
    @EnvironmentObject var sizeCoordinator: SizeCoordinator
    
    var children: _VariadicView.Children
    var layout: L
    @State var accumulatedSize: CGSize? = nil
    
    func body(content: Content) -> some View {
        LayoutSizingView(
            layout: layout,
            accumulatedSize: accumulatedSize,
            placements: placementsCoordinator.placements,
            children: children
        )
        .allowsHitTesting(false)
        .overlay(
            ZStack(alignment: .topLeading) {
                content.onPreferenceChange(AccumulatedSizePreferenceKey.self) { size in
                    withTransaction(placementsCoordinator.transaction) {
                        self.accumulatedSize = size
                    }
                }
            }
        )
        .modifier(ExplicitAlignmentModifier(children: children, layout: layout))
    }
}
