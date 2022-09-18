import Foundation
import SwiftUI

public protocol PlacementLayout: Animatable {
    associatedtype Cache
    
    /// When true Placement uses the Native iOS 16+ placement protocol when available
    var prefersLayoutProtocol: Bool { get }
    
    /// Should Placement not use the same animation as current Transaction when placing views
    var disablesAnimationsWhenPlacing: Bool { get }
    
    func sizeThatFits(
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Cache
    ) -> CGSize
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Cache
    )
    
    func makeCache(subviews: PlacementLayoutSubviews) -> Cache
    func updateCache(_ cache: inout Cache, subviews: PlacementLayoutSubviews)
    
    func spacing(
        subviews: PlacementLayoutSubviews,
        cache: inout Cache
    ) -> PlacementViewSpacing
    
    func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Cache
    ) -> CGFloat?
    
    func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Cache
    ) -> CGFloat?
    
    static var layoutProperties: PlacementLayoutProperties { get }
}

extension PlacementLayout where Cache == Void {
    public func makeCache(subviews: PlacementLayoutSubviews) -> Cache {
        return ()
    }
}

extension PlacementLayout {
    public func updateCache(_ cache: inout Cache, subviews: PlacementLayoutSubviews) {}
    public func spacing(subviews: PlacementLayoutSubviews, cache: inout Cache) -> PlacementViewSpacing {
        PlacementViewSpacing()
    }
    
    public func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Cache
    ) -> CGFloat? {
        return nil
    }
    
    public func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Cache
    ) -> CGFloat? {
        return nil
    }
    
    public var prefersLayoutProtocol: Bool {
        true
    }
    
    public var disablesAnimationsWhenPlacing: Bool {
        false
    }
    
    public static var layoutProperties: PlacementLayoutProperties {
        PlacementLayoutProperties()
    }
}

extension PlacementLayout {
    @ViewBuilder
    public func callAsFunction<V: View>(
        @ViewBuilder _ content: @escaping () -> V
    ) -> some View {
        if #available(iOS 16, macCatalyst 16, *) {
            if prefersLayoutProtocol {
                PlacementLayoutNative(layoutBP: self).callAsFunction {
                    content()
                }
            } else {
                Layouter(layout: self, content: content)
            }
        } else {
            Layouter(layout: self, content: content)
        }
    }
}
