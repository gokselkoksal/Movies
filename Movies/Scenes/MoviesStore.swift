//
//  MoviesStore.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

let sharedStore = Store(
    state: AppState()
)

struct AppState {
    var loginState = LoginState()
    var movieListState = MovieListState()
}

// MARK: - Reducer

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
