import Foundation
import SwiftUI

struct PlacementEffect: GeometryEffect {
    var id: AnyHashable
    var placementsCoordinator: PlacementsCoordinator
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let placement = placementsCoordinator.placements[id]
        
        let positionY = (placement?.position.y ?? 0)
        let anchorY = placement?.anchor.y ?? 0
                    
        let anchorPointY = size.height * anchorY
                        
        let translationY = positionY - anchorPointY
        
        let positionX = (placement?.position.x ?? 0)
        let anchorX = placement?.anchor.x ?? 0
                    
        let anchorPointX = size.width * anchorX
        
        let translationX = positionX - anchorPointX
                                                        
        return ProjectionTransform(CGAffineTransform(translationX: translationX, y: translationY))
    }
}

struct PlacementModifier<L: PlacementLayout>: ViewModifier {
    @EnvironmentObject var placementsCoordinator: PlacementsCoordinator
    var id: AnyHashable
    var layout: L
    var children: _VariadicView.Children
    
    func body(content: Content) -> some View {        
        LayoutChildSizingView(
            layout: layout,
            id: id,
            children: children
        )
        .overlay(
            content
            .transaction { transaction in
                placementsCoordinator.transaction = transaction
            }
            .background(
                GeometryReader(content: { proxy in
                    let placementSize = placementsCoordinator.placements[id]?
                        .proposal
                        .replacingUnspecifiedDimensions(by: .zero) ?? .zero
                    
                    Color.clear.preference(key: ChildrenIntrinsicSizesKey.self, value: [
                        id: CGSize(
                            width: placementSize.width - proxy.size.width,
                            height: placementSize.height - proxy.size.height
                        )
                    ])
                })
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        )
        .modifier(PlacementEffect(id: id, placementsCoordinator: placementsCoordinator).ignoredByLayout())
    }
}
