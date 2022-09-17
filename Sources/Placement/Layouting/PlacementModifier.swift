import Foundation
import SwiftUI

struct PlacementEffect: GeometryEffect {
    var positionX: CGFloat
    var positionY: CGFloat
    var anchorX: CGFloat
    var anchorY: CGFloat
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get {
           AnimatablePair(AnimatablePair(positionX, positionY), AnimatablePair(anchorX, anchorY))
        }

        set {
            positionX = newValue.first.first
            positionY = newValue.first.second
            anchorX = newValue.second.first
            anchorY = newValue.second.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let anchorPointY = size.height * anchorY
        let translationY = positionY - anchorPointY
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
        let placement = placementsCoordinator.placements[id]
        
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
                        Color.clear.preference(key: ChildrenIntrinsicSizesKey.self, value: [
                            id: proxy.size
                        ])
                    })
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
        )
        .modifier(
            PlacementEffect(
                positionX: placement?.position.x ?? 0,
                positionY: placement?.position.y ?? 0,
                anchorX: placement?.anchor.x ?? 0,
                anchorY: placement?.anchor.y ?? 0
            )
        )
    }
}
