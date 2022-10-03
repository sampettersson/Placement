import Foundation
import SwiftUI

struct VariadicLayouterContent<L: PlacementLayout>: _VariadicView_MultiViewRoot {
    var layout: L
    
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            child.modifier(PlacementModifier(id: child.id, layout: layout, children: children))
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
                layout: layout
            )
        ) {
            content()
        }
        .environmentObject(coordinator)
        .environmentObject(coordinator.placementsCoordinator)
        .environmentObject(coordinator.layoutSizingCoordinator)
    }
}
