import Foundation
import SwiftUI

class PlacementsCoordinator: ObservableObject {
    var placements: [AnyHashable: LayoutPlacement] = [:]
    var unspecifiedSize: [AnyHashable: CGSize] = [:]
}

class Coordinator<L: PlacementLayout>: ObservableObject {
    var keyboardFrame: CGRect = .zero
    var globalFrame: CGRect? = nil
    var layout: L? = nil
    public var subviews: PlacementLayoutSubviews? = nil
    var children: _VariadicView.Children? = nil
    
    private var _cache: L.Cache?
    
    public var cache: L.Cache {
        get {
            return _cache!
        }
        set {
            _cache = newValue
        }
    }
    
    func placeSubviews() {
        guard let globalFrame = globalFrame, let children = children else {
            return
        }
        
        layoutContext() { subviews, cache in
            let proposal = PlacementProposedViewSize(globalFrame.size)
                                    
            self.placementsCoordinator.placements = [:]
            
            let keyboardFrameIntersection = globalFrame.intersection(keyboardFrame)
                                                            
            layout?.placeSubviews(
                in: CGRect(
                    origin: CGPoint(
                        x: globalFrame.origin.x,
                        y: globalFrame.origin.y
                    ),
                    size: CGSize(
                        width: globalFrame.width,
                        height: globalFrame.height - keyboardFrameIntersection.height
                    )
                ),
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )
            
            children.forEach { child in
                if
                    !self.placementsCoordinator.placements.contains(where: { id, _ in
                        child.id == id
                    }),
                    let subview = subviews.compactMap({ subview in
                        subview as? LayoutSubviewPolyfill
                    }).first(where: { subview in
                        subview.child.id == child.id
                    })
                {
                    let size = subview.sizeThatFits(proposal)
                    
                    self.placementsCoordinator.placements[child.id] = LayoutPlacement(
                        subview: subview,
                        position: CGPoint(
                            x: globalFrame.midX,
                            y: globalFrame.midY
                        ),
                        anchor: .center,
                        proposal: PlacementProposedViewSize(size)
                    )
                }
            }
            
            placementsCoordinator.placements.forEach { id, placement in
                hostingControllers[id]?.view.frame = CGRect(
                    origin: .zero,
                    size: placement.proposal.replacingUnspecifiedDimensions(by: .zero)
                )
            }
            
            withTransaction(self.transaction) {
                self.placementsCoordinator.objectWillChange.send()
            }
        }
    }
            
    func layoutContext<T>(context: (PlacementLayoutSubviews, inout L.Cache) -> T) -> T {
        let subviews = makeSubviews(children: children!)
        return context(subviews, &cache)
    }
        
    func makeSubviews(children: _VariadicView.Children) -> PlacementLayoutSubviews {
        if let subviews = subviews {
            let childrenIds = children.map { child in
                child.id
            }
            
            let subviewsIds = subviews.compactMap { subview in
                subview as? LayoutSubviewPolyfill
            }.map { subview in
                subview.id
            }
            
            if childrenIds == subviewsIds {
                return subviews
            }
        }
        
        let subviews = PlacementLayoutSubviews(subviews: children.map({ child in
            LayoutSubviewPolyfill(
                id: child.id,
                onPlacement: { placement in
                    self.placementsCoordinator.placements[child.id] = LayoutPlacement(
                        subview: placement.subview,
                        position: CGPoint(
                            x: placement.position.x,
                            y: placement.position.y
                        ),
                        anchor: placement.anchor,
                        proposal: placement.proposal
                    )
                },
                getSizeThatFits: { size in
                    let hostingController = self.makeHostingController(id: child.id)
                    hostingController.rootView = AnyView(child)
                                                            
                    let sizeThatFits = hostingController.sizeThatFits(
                        in: CGSize(
                            width: size.width ?? UIView.layoutFittingCompressedSize.width,
                            height: size.height ?? UIView.layoutFittingCompressedSize.height
                        )
                    )
                                                            
                    return sizeThatFits
                },
                spacing: .zero,
                child: child
            )
        }))
        
        let subviewsIds = subviews.compactMap { subview in
            subview as? LayoutSubviewPolyfill
        }.map { $0.id }
                
        self.hostingControllers = self.hostingControllers.filter { id, _ in
            subviewsIds.contains(id)
        }
        
        self.placementsCoordinator.placements = self.placementsCoordinator.placements.filter { id, _ in
            subviewsIds.contains(id)
        }
                
        if self._cache != nil {
            layout?.updateCache(&cache, subviews: subviews)
        } else {
            self._cache = layout?.makeCache(subviews: subviews)
        }
        
        self.subviews = subviews
        
        return subviews
    }
    
    func makeHostingController(id: AnyHashable) -> UIHostingController<AnyView> {
        if let hostingController = self.hostingControllers[id] {
            return hostingController
        }
        
        let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        hostingController._disableSafeArea = true
        self.hostingControllers[id] = hostingController
        
        return hostingController
    }
        
    public var transaction = Transaction()
    public var placementsCoordinator = PlacementsCoordinator()
    public var hostingControllers: [AnyHashable: UIHostingController<AnyView>] = [:]
}
