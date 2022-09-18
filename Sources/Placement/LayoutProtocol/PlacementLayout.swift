import Foundation
import SwiftUI

/// A polyfill for Layout protocol, a type that defines the geometry of a collection of views.
public protocol PlacementLayout: Animatable {
    /// A collection of proxies for the subviews of a layout view.
    typealias Subviews = PlacementLayoutSubviews
    
    associatedtype Cache
    
    /// When true Placement uses the Native iOS 16+ placement protocol when available
    var prefersLayoutProtocol: Bool { get }
    
    /// Should Placement not use the same animation as current Transaction when placing views
    var disablesAnimationsWhenPlacing: Bool { get }
    
    /// Returns the size of the composite view, given a proposed size and the view’s subviews.
    func sizeThatFits(
        /// A size proposal for the container. The container’s parent view that calls this method might call the method more than once with different proposals to learn more about the container’s flexibility before deciding which proposal to use for placement.
        proposal: PlacementProposedViewSize,
        /// A collection of proxies that represent the views that the container arranges. You can use the proxies in the collection to get information about the subviews as you determine how much space the container needs to display them.
        subviews: Subviews,
        /// Optional storage for calculated data that you can share among the methods of your custom layout container. See makeCache(subviews:) for details.
        cache: inout Cache
    ) -> CGSize
    
    /// Assigns positions to each of the layout’s subviews.
    func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
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
