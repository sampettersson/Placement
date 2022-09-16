import Foundation
import SwiftUI

public protocol PlacementLayout: Animatable {
    typealias Subviews = PlacementLayoutSubviews
    typealias ProposedViewSize = PlacementProposedViewSize
    associatedtype Cache
    
    /// When true Placement uses the Native iOS 16+ placement protocol when available
    var prefersNativeImplementationWhenAvailable: Bool { get }
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    )
    
    func makeCache(subviews: Subviews) -> Cache
    func updateCache(_ cache: inout Cache, subviews: Subviews)
    
    func spacing(
        subviews: Subviews,
        cache: inout Cache
    ) -> PlacementViewSpacing
    
    func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat?
    
    func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat?
    
    static var layoutProperties: PlacementLayoutProperties { get }
}

extension PlacementLayout where Cache == Void {
    public func makeCache(subviews: Subviews) -> Cache {
        return ()
    }
}

extension PlacementLayout {
    public func updateCache(_ cache: inout Cache, subviews: Subviews) {}
    public func spacing(subviews: Subviews, cache: inout Cache) -> PlacementViewSpacing {
        PlacementViewSpacing()
    }
    
    public func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat? {
        return nil
    }
    
    public func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat? {
        return nil
    }
    
    public var prefersNativeImplementationWhenAvailable: Bool {
        true
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
            if prefersNativeImplementationWhenAvailable {
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
