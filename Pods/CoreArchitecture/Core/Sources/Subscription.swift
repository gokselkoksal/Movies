//
//  Subscription.swift
//  Core
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol AnySubscriber: class, NavigationPerformer {
    func _update(with state: State)
}

public protocol Subscriber: AnySubscriber {
    associatedtype StateType: State
    func update(with state: StateType)
}

public extension Subscriber {
    public func _update(with state: State) {
        guard let state = state as? StateType else { return }
        update(with: state)
    }
}

internal struct Subscription {
    
    internal private(set) weak var subscriber: AnySubscriber?
    private let queue: DispatchQueue
    
    internal init(subscriber: AnySubscriber?, queue: DispatchQueue) {
        self.subscriber = subscriber
        self.queue = queue
    }
    
    internal func notify(with newState: State) {
        execute {
            self.subscriber?._update(with: newState)
        }
    }
    
    internal func notify(with navigation: Navigation) {
        execute {
            self.subscriber?.perform(navigation)
        }
    }
    
    private func execute(_ block: @escaping () -> Void) {
        if queue == DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            queue.async {
                block()
            }
        }
    }
}
