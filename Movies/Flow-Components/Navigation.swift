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
    typealias Creation = (parent: AnyFlow, flow: AnyFlow)
    var creations: [Creation] { get }
    var deletions: [AnyFlow] { get }
}

protocol NavigationPerformer {
    func perform(_ navigation: Navigation)
}

// MARK: - Convenience

enum BasicNavigation: Navigation {
    
    case push(AnyFlow, from: AnyFlow)
    case pop(AnyFlow)
    case present(AnyFlow, from: AnyFlow)
    case dismiss(AnyFlow)
    
    var creations: [Navigation.Creation] {
        return proposedChanges().creations
    }
    
    var deletions: [AnyFlow] {
        return proposedChanges().deletions
    }
    
    private func proposedChanges() -> (creations: [Creation], deletions: [AnyFlow]) {
        var creations: [Creation] = []
        var deletions: [AnyFlow] = []
        switch self {
        case .push(let flow, from: let parent):
            creations.append((parent, flow))
        case .pop(let flow):
            deletions.append(flow)
        case .present(let flow, from: let parent):
            creations.append((parent, flow))
        case .dismiss(let flow):
            deletions.append(flow)
        }
        return (creations, deletions)
    }
}
