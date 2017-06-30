//
//  Subscription.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol AnySubscriber: class, NavigationPerformer {
    func _update(with state: State)
}

protocol Subscriber: AnySubscriber {
    associatedtype StateType: State
    func update(with state: StateType)
}

extension Subscriber {
    func _update(with state: State) {
        guard let state = state as? StateType else { return }
        update(with: state)
    }
}

struct Subscription {
    
    private(set) weak var subscriber: AnySubscriber?
    let queue: DispatchQueue
    
    func notify(with newState: State) {
        execute {
            self.subscriber?._update(with: newState)
        }
    }
    
    func notify(with navigation: Navigation) {
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
