import Foundation


// MARK: - State

public protocol State {
    mutating func react(to action: Action) -> [Reaction]
    mutating func cleanUp()
}

// MARK: - Actions

public protocol Action {}
public protocol Reaction {}

// MARK: - Commands

public protocol Command {
    associatedtype StateType: State
    func execute(state: StateType, store: Store<StateType>)
}

// MARK: - Middlewares

public protocol AnyMiddleware {
    func _process(action: Action, state: Any)
}

public protocol Middleware: AnyMiddleware {
    associatedtype StateType: State
    func process(action: Action, state: StateType)
}

extension Middleware {
    public func _process(action: Action, state: Any) {
        if let state = state as? StateType {
            process(action: action, state: state)
        }
    }
}

public struct Middlewares<StateType: State> {
    private(set) var middleware: AnyMiddleware
}

// MARK: - Subscribers

public protocol AnySubscriber: class {
    func _update(with state: Any)
    func _handle(reactions: [Reaction])
}

public protocol Subscriber: AnySubscriber {
    associatedtype StateType: State
    associatedtype ReactionType: Reaction
    func update(with state: StateType)
    func handle(reactions: [ReactionType])
}

extension Subscriber {
    public func _update(with state: Any) {
        if let state = state as? StateType {
            update(with: state)
        }
    }
    
    public func _handle(reactions: [Reaction]) {
        if let reaction = reactions as? [ReactionType] {
            handle(reactions: reaction)
        }
    }
}

public struct Subscription<StateType: State> {
    
    private(set) weak var subscriber: AnySubscriber? = nil
    let selector: ((StateType) -> Any)
    let cleanUp: ((StateType) -> StateType)
    let isAutoCleanUpEnabled: Bool
    let notifyQueue: DispatchQueue

    fileprivate func notify(with state: StateType) {
        notifyQueue.async {
            self.subscriber?._update(with: self.selector(state))
        }
    }
    
    fileprivate func notify(with reactions: [Reaction]) {
        notifyQueue.async {
            self.subscriber?._handle(reactions: reactions)
        }
    }
}

// MARK: - Store

public class Store<StateType: State> {
    
    private let jobQueue:DispatchQueue = DispatchQueue(label: "reactor.store.queue", qos: .userInitiated, attributes: [])

    private let subscriptionsSyncQueue = DispatchQueue(label: "reactor.store.subscription.sync")
    private var _subscriptions = [Subscription<StateType>]()
    private var subscriptions: [Subscription<StateType>] {
        get {
            return subscriptionsSyncQueue.sync {
                return self._subscriptions
            }
        }
        set {
            subscriptionsSyncQueue.sync {
                self._subscriptions = newValue
            }
        }
    }

    private let middlewares: [Middlewares<StateType>]
    public private (set) var state: StateType {
        didSet {
            notifySubscribers(with: state)
        }
    }
    
    public init(state: StateType, middlewares: [AnyMiddleware] = []) {
        self.state = state
        self.middlewares = middlewares.map(Middlewares.init)
    }
    
    
    // MARK: - Subscriptions
    
    public func add(
        subscriber: AnySubscriber,
        selector: @escaping ((StateType) -> Any),
        cleanUp: @escaping ((StateType) -> StateType),
        autoCleanUp: Bool = true,
        notifyOnQueue queue: DispatchQueue? = DispatchQueue.main) {
        
        jobQueue.async {
            guard !self.subscriptions.contains(where: {$0.subscriber === subscriber}) else { return }
            let subscription = Subscription(
                subscriber: subscriber,
                selector: selector,
                cleanUp: cleanUp,
                isAutoCleanUpEnabled: autoCleanUp,
                notifyQueue: queue ?? self.jobQueue
            )
            self.subscriptions.append(subscription)
            subscription.notify(with: self.state)
        }
    }
    
    public func remove(subscriber: AnySubscriber) {
        if let subscriptionIndex = subscriptions.index(where: { $0.subscriber === subscriber }) {
            let subscription = subscriptions[subscriptionIndex]
            if subscription.isAutoCleanUpEnabled {
                state = subscription.cleanUp(state)
            }
            subscriptions.remove(at: subscriptionIndex)
        }
    }
    
    // MARK: - Actions
    
    public func fire(action: Action) {
        jobQueue.async {
            let reactions = self.state.react(to: action)
            let state = self.state
            self.notifySubscribers(with: reactions)
            self.middlewares.forEach { $0.middleware._process(action: action, state: state) }
        }
    }
    
    public func fire<C: Command>(command: C) where C.StateType == StateType {
        jobQueue.async {
            command.execute(state: self.state, store: self)
        }
    }
    
    public func fire(reaction: Reaction) {
        jobQueue.async {
            self.notifySubscribers(with: [reaction])
        }
    }
    
    // MARK: - Private 
    
    private func notifySubscribers(with newState: StateType) {
        forEachSubscription { $0.notify(with: newState) }
    }
    
    private func notifySubscribers(with reactions: [Reaction]) {
        forEachSubscription { $0.notify(with: reactions) }
    }
    
    private func forEachSubscription(_ block: (Subscription<StateType>) -> Void) {
        subscriptions = subscriptions.filter { $0.subscriber != nil }
        for subscription in subscriptions {
            block(subscription)
        }
    }
}
