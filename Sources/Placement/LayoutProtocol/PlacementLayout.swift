import Foundation
import SwiftUI

/// A drop in replacement for Layout protocol, a type that defines the geometry of a collection of views.
public protocol PlacementLayout: Animatable {
    /// A collection of proxies for the subviews of a layout view.
    typealias Subviews = PlacementLayoutSubviews
    
    /// Cached values associated with the layout instance.
    associatedtype Cache
    
    /// When true Placement uses the Native iOS 16+ placement protocol when available
    var prefersLayoutProtocol: Bool { get }
    
    /// Should Placement not use the same animation as current Transaction when placing views
    var disablesAnimationsWhenPlacing: Bool { get }
    
    /// Returns the size of the composite view, given a proposed size and the view’s subviews.
    ///
    /// - parameter proposal: A size proposal for the container. The container’s parent view that calls this method might call the method more than once with different proposals to learn more about the container’s flexibility before deciding which proposal to use for placement.
    /// - parameter subviews: A collection of proxies that represent the views that the container arranges. You can use the proxies in the collection to get information about the subviews as you determine how much space the container needs to display them.
    /// - parameter cache: Optional storage for calculated data that you can share among the methods of your custom layout container. See makeCache(subviews:) for details.
    func sizeThatFits(
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize
    
    /// Assigns positions to each of the layout’s subviews.
    ///
    ///  - parameter bounds: The region that the container view’s parent allocates to the container view, specified in the parent’s coordinate space. Place all the container’s subviews within the region. The size of this region matches a size that your container previously returned from a call to the ``sizeThatFits(proposal:subviews:cache:)`` method.
    ///  - parameter proposal: The size proposal from which the container generated the size that the parent used to create the bounds parameter. The parent might propose more than one size before calling the placement method, but it always uses one of the proposals and the corresponding returned size when placing the container.
    ///  - parameter subviews: A collection of proxies that represent the views that the container arranges. Use the proxies in the collection to get information about the subviews and to tell the subviews where to appear.
    ///  - parameter cache: Optional storage for calculated data that you can share among the methods of your custom layout container. See ``makeCache(subviews:)`` for details.
    func placeSubviews(
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    )
    
    /// Creates and initializes a cache for a layout instance.
    ///
    /// - parameter subviews: A collection of proxy instances that represent the views that the container arranges. You can use the proxies in the collection to get information about the subviews as you calculate values to store in the cache.
    func makeCache(subviews: Subviews) -> Cache
    
    /// Updates the layout’s cache when something changes.
    ///
    /// - parameter cache: Storage for calculated data that you share among the methods of your custom layout container.
    /// - parameter subviews: A collection of proxy instances that represent the views arranged by the container. You can use the proxies in the collection to get information about the subviews as you calculate values to store in the cache.
    func updateCache(_ cache: inout Cache, subviews: Subviews)
    
    /// Returns the preferred spacing values of the composite view.
    ///
    /// - parameter subviews: A collection of proxy instances that represent the views that the container arranges. You can use the proxies in the collection to get information about the subviews as you determine how much spacing the container prefers around it.
    ///  - parameter Optional storage for calculated data that you can share among the methods of your custom layout container. See ``makeCache(subviews:)-4mrb3`` for details.
    func spacing(
        subviews: Subviews,
        cache: inout Cache
    ) -> PlacementViewSpacing
    
    /// Returns the position of the specified horizontal alignment guide along the y axis.
    ///
    /// - parameter guide: The VerticalAlignment guide that the method calculates the position of.
    /// - parameter bounds: The region that the container view’s parent allocates to the container view, specified in the parent’s coordinate space.
    /// - parameter proposal: A proposed size for the container.
    /// - parameter subviews: A collection of proxy instances that represent the views arranged by the container. You can use the proxies in the collection to get information about the subviews as you determine where to place the guide.
    /// - parameter cache: storage for calculated data that you can share among the methods of your custom layout container. See ``makeCache(subviews:)-4mrb3`` for details.
    func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat?
    
    /// Returns the position of the specified horizontal alignment guide along the x axis.
    ///
    /// - parameter guide: The HorizontalAlignment guide that the method calculates the position of.
    /// - parameter bounds: The region that the container view’s parent allocates to the container view, specified in the parent’s coordinate space.
    /// - parameter proposal: A proposed size for the container.
    /// - parameter subviews: A collection of proxy instances that represent the views arranged by the container. You can use the proxies in the collection to get information about the subviews as you determine where to place the guide.
    /// - parameter cache: storage for calculated data that you can share among the methods of your custom layout container. See ``makeCache(subviews:)-6gvgo`` for details.
    func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat?
    
    /// Properties of a layout container.
    static var layoutProperties: PlacementLayoutProperties { get }
}

extension PlacementLayout {
    /// Combines the specified views into a single composite view using the layout algorithms of the custom layout container.
    ///
    /// - parameter content: A composite view that combines all the input views.
    @ViewBuilder public func callAsFunction<V: View>(
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
