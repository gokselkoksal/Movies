//
//  Flow.swift
//  Movies
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol FlowID { }

protocol AnyFlow: class {
    weak var coordinator: Coordinator? { get set }
    var id: FlowID { get }
    var navigator: Navigator? { get }
    func process(_ action: Action) -> Navigation?
}

class Flow<StateType: State>: AnyFlow {
    
    weak var coordinator: Coordinator?
    
    let id: FlowID
    private(set) var state: StateType
    let navigator: Navigator?
    
    private var subscriptionSyncQueue = DispatchQueue(label: "flow.subscription.sync")
    private var _subscriptions: [Subscription] = []
    private var subscriptions: [Subscription] {
        get {
            return subscriptionSyncQueue.sync {
                return self._subscriptions
            }
        }
        set {
            subscriptionSyncQueue.sync {
                self._subscriptions = newValue
            }
        }
    }
    
    init(id: FlowID, state: StateType, navigator: Navigator? = nil) {
        self.id = id
        self.state = state
        self.navigator = navigator
    }
    
    func process(_ action: Action) -> Navigation? {
        if let action = action as? NavigatorAction {
            let request = self.navigator?.resolve(action)
            self.notifySubscribers(with: request)
            return request
        } else {
            self.state.react(to: action)
            self.notifySubscribers(with: self.state)
            return nil
        }
    }
    
    func subscribe<S: Subscriber>(_ subscriber: S, on queue: DispatchQueue = .main) where S.StateType == StateType {
        guard !self.subscriptions.contains(where: { $0.subscriber === subscriber }) else { return }
        let subscription = Subscription(subscriber: subscriber, queue: queue)
        self.subscriptions.append(subscription)
    }
    
    func unsubscribe<S: Subscriber>(_ subscriber: S) where S.StateType == StateType {
        if let subscriptionIndex = subscriptions.index(where: { $0.subscriber === subscriber }) {
            subscriptions.remove(at: subscriptionIndex)
        }
    }
    
    private func notifySubscribers(with newState: StateType) {
        forEachSubscription { $0.notify(with: newState) }
    }
    
    private func notifySubscribers(with navigation: Navigation?) {
        guard let navigation = navigation else { return }
        forEachSubscription { $0.notify(with: navigation) }
    }
    
    private func forEachSubscription(_ block: (Subscription) -> Void) {
        subscriptions = subscriptions.filter { $0.subscriber != nil }
        for subscription in subscriptions {
            block(subscription)
        }
    }
}

extension Flow: Dispatcher {
    
    func dispatch(_ action: Action) {
        coordinator?.dispatch(action)
    }
    
    func dispatch<C>(_ command: C) where C : Command {
        coordinator?.dispatch(command)
    }
}
