import Foundation
import SwiftUI

struct VariadicLayouterContent<L: PlacementLayout>: _VariadicView_MultiViewRoot {
    var coordinator: Coordinator<L>
    var layout: L
    
    func body(children: _VariadicView.Children) -> some View {
        coordinator.children = children
        
        return ForEach(children) { child in
            child.modifier(
                PlacementModifier(id: child.id, layout: layout, children: children)
            ).onDisappear {
                coordinator.placementsCoordinator.placements.removeValue(
                    forKey: child.id
                )
            }
        }.modifier(LayoutSizeModifier(children: children, layout: layout))
    }
}

struct Layouter<Content: View, L: PlacementLayout>: View {
    @StateObject var coordinator = Coordinator<L>()
    var layout: L
    var content: () -> Content
 
    var body: some View {
        coordinator.layout = layout
        
        return _VariadicView.Tree(
            VariadicLayouterContent(
                coordinator: coordinator,
                layout: layout
            )
        ) {
            content().environment(\.placementShouldAdjustToKeyboard, false)
        }
        .environmentObject(coordinator)
        .environmentObject(coordinator.placementsCoordinator)
        .transformPreference(PlacementIntrinsicSizesPreferenceKey.self) { intrinsicSizes in
            intrinsicSizes = [:]
        }
        .ignoresSafeArea(.keyboard)
    }
}
