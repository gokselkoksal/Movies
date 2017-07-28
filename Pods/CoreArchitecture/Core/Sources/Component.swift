//
//  Component.swift
//  Core
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol ComponentNavigationDelegate: class {
    func component(_ component: AnyComponent, willFireNavigation navigation: Navigation)
}

public protocol AnyComponent: class {
    weak var navigationDelegate: ComponentNavigationDelegate? { get set }
    weak var parent: AnyComponent? { get set }
    var anyState: State { get }
    func process(_ action: Action)
    func commit(_ newState: State)
    func commit(_ navigation: Navigation)
}

open class Component<StateType: State>: AnyComponent {
    
    public weak var navigationDelegate: ComponentNavigationDelegate?
    public weak var parent: AnyComponent?
    
    public private(set) var state: StateType
    public var anyState: State { return state }
    
    private let subscriptionManager = SubscriptionManager<StateType>()
    
    public init(state: StateType) {
        self.state = state
    }
    
    open func process(_ action: Action) {
        // Should be implemented by subclasses. Does nothing by default.
    }
    
    public final func subscribe<S: Subscriber>(_ subscriber: S, on queue: DispatchQueue = .main) where S.StateType == StateType {
        subscriber._update(with: state)
        subscriptionManager.subscribe(subscriber, on: queue)
    }
    
    public final func unsubscribe<S: Subscriber>(_ subscriber: S) where S.StateType == StateType {
        subscriptionManager.unsubscribe(subscriber)
    }
    
    public final func commit(_ newState: State) {
        guard let newState = newState as? StateType else { return }
        self.state = newState
        subscriptionManager.publish(newState)
    }
    
    public final func commit(_ navigation: Navigation) {
        navigationDelegate?.component(self, willFireNavigation: navigation)
        subscriptionManager.publish(navigation)
    }
    
    public final func commit(_ newState: State, _ navigation: Navigation) {
        commit(newState)
        commit(navigation)
    }
}
