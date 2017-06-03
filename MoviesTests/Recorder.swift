//
//  Recorder.swift
//  Movies
//
//  Created by Göksel Köksal on 03/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
@testable import Movies

class Recorder<T: State>: Subscriber {
    
    private(set) var snapshots: [T] = []
    private(set) var navigations: [Navigation] = []
    
    func update(with state: T) {
        snapshots.append(state)
    }
    
    func perform(_ navigation: Navigation) {
        navigations.append(navigation)
    }
    
    func reset() {
        snapshots.removeAll()
        navigations.removeAll()
    }
}
