//
//  RAppState.swift
//  Movies
//
//  Created by Göksel Köksal on 10/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

let sharedStore = Store(
    state: AppState()
)

struct AppState {
    var loginState = LoginState()
    var movieListState = MovieListState() {
        didSet {
            print("Movie count: \(movieListState.movies.count)")
        }
    }
}

extension AppState: State {
    
    mutating func react(to action: Action) -> [Reaction] {
        let loginReactions = loginState.react(to: action)
        let movieListReactions = movieListState.react(to: action)
        return loginReactions + movieListReactions
    }
    
    mutating func cleanUp() {
        self = AppState()
    }
}
