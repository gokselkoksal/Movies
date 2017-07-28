//
//  Core.swift
//  Core
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public final class Core {
    
    public let navigationTree: Tree<AnyComponent>
    fileprivate var middlewares: [Middleware]
    
    public init(rootComponent: AnyComponent, middlewares: [Middleware] = []) {
        self.navigationTree = Tree(rootComponent, equalityChecker: { $0 === $1 })
        self.middlewares = middlewares
        rootComponent.navigationDelegate = self
    }
    
    public func dispatch(_ action: Action) {
        willProcess(action)
        navigationTree.forEach { $0.process(action) }
        didProcess(action)
    }
    
    public func dispatch<C: Command>(_ command: C) {
        navigationTree.forEach { (component) in
            if let specificComponent = component as? Component<C.StateType> {
                command.execute(on: specificComponent, core: self)
            }
        }
    }
}

private extension Core {
    
    func willProcess(_ action: Action) {
        middlewares.forEach { $0.willProcess(action) }
    }
    
    func didProcess(_ action: Action) {
        middlewares.forEach { $0.didProcess(action) }
    }
}

extension Core: ComponentNavigationDelegate {
    
    public func component(_ component: AnyComponent, willFireNavigation navigation: Navigation) {
        for componentToDelete in navigation.deletions {
            self.navigationTree.remove(componentToDelete)
        }
        for (parent, newComponent) in navigation.creations {
            newComponent.navigationDelegate = self
            newComponent.parent = parent
            if self.navigationTree.search(newComponent) == nil {
                self.navigationTree.search(parent)?.add(newComponent)
            }
        }
    }
}
