//
//  Tree.swift
//  Core
//
//  Created by Goksel Koksal on 26/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public class Tree<T> {
    
    public typealias EqualityChecker = (T, T) -> Bool
    
    public class Node {
        public let value: T
        public var children: [Node] = []
        public weak var parent: Node?
        
        public init(_ value: T) {
            self.value = value
        }
        
        public var isLeaf: Bool {
            return children.count == 0
        }
        
        public func add(_ child: Node) {
            child.parent = self
            children.append(child)
        }
        
        public func add(_ childValue: T) {
            let child = Node(childValue)
            child.parent = self
            children.append(child)
        }
    }
    
    public var root: Node
    public let defaultEqualityChecker: EqualityChecker
    
    public init(_ root: Node, equalityChecker: @escaping EqualityChecker) {
        self.root = root
        self.defaultEqualityChecker = equalityChecker
    }
    
    public convenience init(_ rootValue: T, equalityChecker: @escaping EqualityChecker) {
        self.init(Node(rootValue), equalityChecker: equalityChecker)
    }
    
    public func search(_ value: T, equalityChecker: EqualityChecker? = nil) -> Node? {
        let equalityChecker = equalityChecker ?? defaultEqualityChecker
        return Tree.node(for: value, root: root, equalityChecker: equalityChecker)
    }
    
    public func flatten() -> [T] {
        return Tree.flatten(root)
    }
    
    public func forEach(_ block: (T) -> Void) {
        return Tree.forEach(on: root, block)
    }
    
    @discardableResult
    public func remove(_ value: T, equalityChecker: EqualityChecker? = nil) -> Bool {
        let equalityChecker = equalityChecker ?? defaultEqualityChecker
        let node = search(value, equalityChecker: equalityChecker)
        if let parent = node?.parent {
            if let index = parent.children.index(where: { equalityChecker($0.value, value) }) {
                parent.children.remove(at: index)
                return true
            }
        }
        return false
    }
}

private extension Tree {
    
    static func forEach(on node: Node, _ block: (T) -> Void) {
        block(node.value)
        for child in node.children {
            Tree.forEach(on: child, block)
        }
    }
    
    static func flatten(_ node: Node) -> [T] {
        var values: [T] = []
        Tree.forEach(on: node, { values.append($0) })
        return values
    }
    
    static func node(for value: T, root: Node, equalityChecker: EqualityChecker) -> Node? {
        if equalityChecker(root.value, value) {
            return root
        } else {
            for child in root.children {
                if let result = node(for: value, root: child, equalityChecker: equalityChecker) {
                    return result
                }
            }
            return nil
        }
    }
}

extension Tree: CustomStringConvertible {
    public var description: String {
        return root.description
    }
}

extension Tree.Node: CustomStringConvertible {
    public var description: String {
        if isLeaf {
            return "{ \(value) }"
        }
        var string = "{ \(value): "
        string += children.map { "\($0)" }.joined(separator: " | ")
        string += " }"
        return string
    }
}
