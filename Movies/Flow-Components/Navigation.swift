//
//  Navigation.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol Navigator {
    func resolve(_ action: NavigatorAction) -> Navigation?
}

protocol Navigation {
    typealias Creation = (parent: AnyComponent, component: AnyComponent)
    var creations: [Creation] { get }
    var deletions: [AnyComponent] { get }
}

protocol NavigationPerformer {
    func perform(_ navigation: Navigation)
}

// MARK: - Convenience

enum BasicNavigation: Navigation {
    
    case push(AnyComponent, from: AnyComponent)
    case pop(AnyComponent)
    case present(AnyComponent, from: AnyComponent)
    case dismiss(AnyComponent)
    
    var creations: [Navigation.Creation] {
        return proposedChanges().creations
    }
    
    var deletions: [AnyComponent] {
        return proposedChanges().deletions
    }
    
    private func proposedChanges() -> (creations: [Creation], deletions: [AnyComponent]) {
        var creations: [Creation] = []
        var deletions: [AnyComponent] = []
        switch self {
        case .push(let component, from: let parent):
            creations.append((parent, component))
        case .pop(let component):
            deletions.append(component)
        case .present(let component, from: let parent):
            creations.append((parent, component))
        case .dismiss(let component):
            deletions.append(component)
        }
        return (creations, deletions)
    }
}
