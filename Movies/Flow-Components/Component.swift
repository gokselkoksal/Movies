//
//  Component.swift
//  Movies
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol AnyComponent: class {
    weak var coordinator: Coordinator? { get set }
    var navigator: Navigator? { get }
    func process(_ action: Action) -> Navigation?
}

class Component<StateType: State>: AnyComponent {
    
    weak var coordinator: Coordinator?
    
    private(set) var state: StateType
    let navigator: Navigator?
    
    let subscriptionManager = SubscriptionManager<StateType>()
    
    init(state: StateType, navigator: Navigator? = nil) {
        self.state = state
        self.navigator = navigator
    }
    
    func process(_ action: Action) -> Navigation? {
        if let action = action as? NavigatorAction {
            let navigation = navigator?.resolve(action)
            subscriptionManager.publish(navigation)
            return navigation
        } else {
            state.react(to: action)
            subscriptionManager.publish(state)
            return nil
        }
    }
    
    func subscribe<S: Subscriber>(_ subscriber: S, on queue: DispatchQueue = .main) where S.StateType == StateType {
        subscriptionManager.subscribe(subscriber, on: queue)
    }
    
    func unsubscribe<S: Subscriber>(_ subscriber: S) where S.StateType == StateType {
        subscriptionManager.unsubscribe(subscriber)
    }
}

extension Component: Dispatcher {
    
    func dispatch(_ action: Action) {
        coordinator?.dispatch(action)
    }
    
    func dispatch<C>(_ command: C) where C : Command {
        coordinator?.dispatch(command)
    }
}
