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
    @EnvironmentObject var placementsCordinator: PlacementsCoordinator
    
    var children: _VariadicView.Children
    var layout: L
    @State var childrenIntrinsicSizes: [AnyHashable: CGSize] = [:]
    
    func body(content: Content) -> some View {
        LayoutSizingView(
            layout: layout,
            children: children,
            childrenIntrinsicSizes: childrenIntrinsicSizes
        )
        .allowsHitTesting(false)
        .overlay(
            ZStack(alignment: Alignment(horizontal: .placementLeading, vertical: .placementTop)) {
                content
                    .onPreferenceChange(ChildrenIntrinsicSizesKey.self) { sizes in
                        withTransaction(placementsCordinator.transaction) {
                            childrenIntrinsicSizes = sizes
                        }
                    }
                    .environment(\.childrenIntrinsicSizes, childrenIntrinsicSizes)
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
