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

private struct ChildrenIntrinsicSizesEnvironmentKey: EnvironmentKey {
    static let defaultValue: [AnyHashable: CGSize] = [:]
}

extension EnvironmentValues {
  var childrenIntrinsicSizes: [AnyHashable: CGSize] {
    get { self[ChildrenIntrinsicSizesEnvironmentKey.self] }
    set { self[ChildrenIntrinsicSizesEnvironmentKey.self] = newValue }
  }
}

struct LayoutSizeModifier<L: PlacementLayout>: ViewModifier {
    @EnvironmentObject var coordinator: Coordinator<L>
    var children: _VariadicView.Children
    var layout: L
    
    func updateLayout(proxy: GeometryProxy) -> some View {
        coordinator.layoutProxy = proxy
        coordinator.placeSubviews(children: children)
        return Color.clear
    }
    
    func body(content: Content) -> some View {
        LayoutSizingView(
            layout: layout,
            children: children
        )
        .background(GeometryReader(content: { proxy in
            updateLayout(proxy: proxy)
        }))
        .transaction({ transaction in
            coordinator.transaction = transaction
        })
        .allowsHitTesting(false)
        .overlay(
            ZStack(alignment: Alignment(horizontal: .placementLeading, vertical: .placementTop)) {
                content
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
            }
        )
        .modifier(ExplicitAlignmentModifier(children: children, layout: layout))
    }
}
