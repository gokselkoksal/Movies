//
//  Coordinator.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

final class Coordinator: Dispatcher {
    
    let navigationTree: Tree<AnyComponent>
    private(set) var middlewares: [Middleware]
    
    init(rootComponent: AnyComponent, middlewares: [Middleware] = []) {
        self.navigationTree = Tree(rootComponent, equalityChecker: { $0 === $1 })
        self.middlewares = middlewares
        rootComponent.coordinator = self
    }
    
    func dispatch(_ action: Action) {
        self.willProcess(action)
        self.navigationTree.forEach { (component) in
            if let navigation = component.process(action) {
                for componentToDelete in navigation.deletions {
                    self.navigationTree.remove(componentToDelete)
                }
                for (parent, newComponent) in navigation.creations {
                    newComponent.coordinator = self
                    if self.navigationTree.search(newComponent) == nil {
                        self.navigationTree.search(parent)?.add(newComponent)
                    }
                }
            }
        }
        self.didProcess(action)
    }
    
    func dispatch<C: Command>(_ command: C) {
        self.navigationTree.forEach { (component) in
            if let specificComponent = component as? Component<C.StateType> {
                command.execute(on: specificComponent)
            }
        }
    }
    
    private func willProcess(_ action: Action) {
        middlewares.forEach { $0.willProcess(action) }
    }
    
    private func didProcess(_ action: Action) {
        middlewares.forEach { $0.didProcess(action) }
    }
}
