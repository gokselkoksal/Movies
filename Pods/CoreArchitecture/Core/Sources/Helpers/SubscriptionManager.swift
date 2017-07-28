//
//  SubscriptionManager.swift
//  Core
//
//  Created by Goksel Koksal on 30/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

internal final class SubscriptionManager<StateType: State> {
    
    private var subscriptionSyncQueue = DispatchQueue(label: "component.subscription.sync")
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

    internal func subscribe<S: Subscriber>(_ subscriber: S, on queue: DispatchQueue = .main) where S.StateType == StateType {
        guard !self.subscriptions.contains(where: { $0.subscriber === subscriber }) else { return }
        let subscription = Subscription(subscriber: subscriber, queue: queue)
        self.subscriptions.append(subscription)
    }
    
    internal func unsubscribe<S: Subscriber>(_ subscriber: S) where S.StateType == StateType {
        if let subscriptionIndex = subscriptions.index(where: { $0.subscriber === subscriber }) {
            subscriptions.remove(at: subscriptionIndex)
        }
    }
    
    internal func publish(_ newState: StateType) {
        forEachSubscription { $0.notify(with: newState) }
    }
    
    internal func publish(_ navigation: Navigation) {
        forEachSubscription { $0.notify(with: navigation) }
    }
    
    private func forEachSubscription(_ block: (Subscription) -> Void) {
        subscriptions = subscriptions.filter { $0.subscriber != nil }
        for subscription in subscriptions {
            block(subscription)
        }
    }
}
