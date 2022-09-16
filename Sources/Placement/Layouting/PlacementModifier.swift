import Foundation
import SwiftUI

struct PlacementModifier<L: PlacementLayout>: ViewModifier {
    @EnvironmentObject var placementsCoordinator: PlacementsCoordinator
    @State var contentSize: CGSize? = nil
    @State var layoutSize: CGSize? = nil
    var id: AnyHashable
    var layout: L
    var children: _VariadicView.Children
    
    var placement: LayoutPlacement? {
        if let placement = placementsCoordinator.placements[id] {
            return placement
        }
        
        return nil
    }
    
    var verticalAlignment: VerticalAlignment {
        if let anchorY = placement?.anchor.y {
            switch anchorY {
                case UnitPoint.top.y: return .top
                case UnitPoint.center.y: return .center
                case UnitPoint.bottom.y: return.bottom
                default:
                    return .center
            }
        }
        
        return .center
    }
    
    var horizontalAlignment: HorizontalAlignment {
        if let anchorX = placement?.anchor.x {
            switch anchorX {
            case UnitPoint.center.x: return .center
            case UnitPoint.leading.x: return .leading
            case UnitPoint.trailing.x: return .trailing
            default:
                return .center
            }
        }
        
        return .center
    }
    
    func body(content: Content) -> some View {
        LayoutChildSizingView(
            layout: layout,
            id: id,
            contentSize: contentSize,
            layoutSize: layoutSize,
            placement: placement,
            children: children
        )
        .overlay(
            content.background(
                GeometryReader(content: { proxy in
                    Color.clear.preference(
                        key: SizePreferenceKey.self,
                        value: proxy.size
                    ).onPreferenceChange(SizePreferenceKey.self) { size in
                        withTransaction(placementsCoordinator.transaction) {
                            self.contentSize = size
                        }
                    }
                })
            )
        )
        .alignmentGuide(.placementTop) { d in
            let positionY = placement?.position.y ?? 0
            return d[verticalAlignment] - positionY
        }.alignmentGuide(.placementLeading) { d in
            let positionX = placement?.position.x ?? 0
            return d[horizontalAlignment] - positionX
        }.transaction { transaction in
            placementsCoordinator.transaction = transaction
        }
        .preference(key: AccumulatedSizePreferenceKey.self, value: contentSize ?? .zero)
    }
}
