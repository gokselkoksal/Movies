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

struct Navigation {
    
    typealias Creation = (parent: AnyFlow, flow: AnyFlow)
    
    let from: AnyFlow
    let to: AnyFlow
    let creations: [Creation]
    let deletions: [AnyFlow]
    let info: [AnyHashable: Any]
    
    init(from: AnyFlow, to: AnyFlow, creations: [Creation], deletions: [AnyFlow], info: [AnyHashable: Any] = [:]) {
        self.from = from
        self.to = to
        self.creations = creations
        self.deletions = deletions
        self.info = info
    }
    
    static func proceed(from: AnyFlow, to: AnyFlow) -> Navigation {
        return Navigation(from: from, to: to, creations: [(from, to)], deletions: [])
    }
}

protocol NavigationPerformer {
    func perform(_ navigation: Navigation)
}
