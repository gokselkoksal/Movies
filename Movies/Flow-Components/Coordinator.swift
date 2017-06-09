//
//  Coordinator.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

final class Coordinator: Dispatcher {
    
    let navigationTree: Tree<AnyFlow>
    private(set) var middlewares: [Middleware]
    
    init(rootFlow: AnyFlow, middlewares: [Middleware] = []) {
        self.navigationTree = Tree(rootFlow, equalityChecker: { $0 === $1 })
        self.middlewares = middlewares
        rootFlow.coordinator = self
    }
    
    func dispatch(_ action: Action) {
        self.willProcess(action)
        self.navigationTree.forEach { (flow) in
            if let navigation = flow.process(action) {
                for flowToDelete in navigation.deletions {
                    self.navigationTree.remove(flowToDelete)
                }
                for (parent, newFlow) in navigation.creations {
                    newFlow.coordinator = self
                    if self.navigationTree.search(newFlow) == nil {
                        self.navigationTree.search(parent)?.add(newFlow)
                    }
                }
            }
        }
        self.didProcess(action)
    }
    
    func dispatch<C: Command>(_ command: C) {
        self.navigationTree.forEach { (flow) in
            if let specificFlow = flow as? Flow<C.StateType> {
                command.execute(on: specificFlow, coordinator: self)
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
