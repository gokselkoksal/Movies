//
//  Component.swift
//  Movies
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol ComponentNavigationDelegate: class {
    func component(_ component: AnyComponent, willFireNavigation navigation: Navigation)
}

protocol AnyComponent: class {
    weak var navigationDelegate: ComponentNavigationDelegate? { get set }
    var anyState: State { get }
    func process(_ action: Action)
    func commit(_ newState: State)
    func commit(_ navigation: Navigation)
}

class Component<StateType: State>: AnyComponent {
    
    weak var navigationDelegate: ComponentNavigationDelegate?
    
    private(set) var state: StateType
    var anyState: State { return state }
    
    private let subscriptionManager = SubscriptionManager<StateType>()
    
    init(state: StateType) {
        self.state = state
    }
    
    func process(_ action: Action) {
        // Should be implemented by subclasses. Does nothing by default.
    }
    
    func subscribe<S: Subscriber>(_ subscriber: S, on queue: DispatchQueue = .main) where S.StateType == StateType {
        subscriptionManager.subscribe(subscriber, on: queue)
    }
    
    func unsubscribe<S: Subscriber>(_ subscriber: S) where S.StateType == StateType {
        subscriptionManager.unsubscribe(subscriber)
    }
    
    func commit(_ newState: State) {
        guard let newState = newState as? StateType else { return }
        self.state = newState
        subscriptionManager.publish(newState)
    }
    
    func commit(_ navigation: Navigation) {
        navigationDelegate?.component(self, willFireNavigation: navigation)
        subscriptionManager.publish(navigation)
    }
}
