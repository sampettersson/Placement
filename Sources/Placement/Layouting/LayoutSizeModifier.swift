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
    @Namespace private var namespace
    @EnvironmentObject var coordinator: Coordinator<L>
    @State var intrinsicSizes: [AnyHashable: CGSize] = [:]
    var children: _VariadicView.Children
    var layout: L
    
    func body(content: Content) -> some View {
        LayoutSizingView(
            layout: layout,
            children: children,
            intrinsicSizes: intrinsicSizes
        )
        .transaction({ transaction in
            coordinator.transaction = transaction
        })
        .allowsHitTesting(false)
        .overlay(
            ZStack(
                alignment: Alignment(
                    horizontal: .placementLeading,
                    vertical: .placementTop
                )
            ) {
                content
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
            }
        )
        .modifier(ExplicitAlignmentModifier(children: children, layout: layout))
        .overlayPreferenceValue(PlacementIntrinsicSizesPreferenceKey.self) { intrinsicSizes in
            FrameChangePlacer<L>(
                children: children,
                intrinsicSizes: intrinsicSizes
            )
            .animation(nil)
            .allowsHitTesting(false)
        }
        .onPreferenceChange(PlacementIntrinsicSizesPreferenceKey.self) { intrinsicSizes in
            withTransaction(coordinator.transaction) {
                self.intrinsicSizes = intrinsicSizes
            }
        }
    }
}
