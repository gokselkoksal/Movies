//
//  Navigation.swift
//  Core
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol Navigator {
    func resolve(_ action: Action) -> Navigation?
}

public protocol Navigation {
    typealias Creation = (parent: AnyComponent, component: AnyComponent)
    var creations: [Creation] { get }
    var deletions: [AnyComponent] { get }
}

public protocol NavigationPerformer {
    func perform(_ navigation: Navigation)
}

// MARK: - Convenience

public enum BasicNavigation: Navigation {
    
    case push(AnyComponent, from: AnyComponent)
    case pop([AnyComponent])
    case present(AnyComponent, from: AnyComponent)
    case dismiss(AnyComponent)
    
    public var creations: [Navigation.Creation] {
        return proposedChanges().creations
    }
    
    public var deletions: [AnyComponent] {
        return proposedChanges().deletions
    }
    
    private func proposedChanges() -> (creations: [Creation], deletions: [AnyComponent]) {
        var creations: [Creation] = []
        var deletions: [AnyComponent] = []
        switch self {
        case .push(let component, from: let parent):
            creations.append((parent, component))
        case .pop(let components):
            deletions.append(contentsOf: components)
        case .present(let component, from: let parent):
            creations.append((parent, component))
        case .dismiss(let component):
            deletions.append(component)
        }
        return (creations, deletions)
    }
}
