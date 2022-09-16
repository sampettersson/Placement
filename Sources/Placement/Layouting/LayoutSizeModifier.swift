import Foundation
import SwiftUI

extension VerticalAlignment {
    struct PlacementTop: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }

    static let placementTop = VerticalAlignment(PlacementTop.self)
}

extension HorizontalAlignment {
    struct PlacementLeading: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.leading]
        }
    }

    static let placementLeading = HorizontalAlignment(PlacementLeading.self)
}

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
            ZStack(alignment: Alignment(horizontal: .placementLeading, vertical: .placementTop)) {
                Color.clear.frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                
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
