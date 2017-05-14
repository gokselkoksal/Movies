//
//  RAppState.swift
//  Movies
//
//  Created by Göksel Köksal on 10/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

let sharedStore = Store(
    state: AppState(),
    reactionReducers: [MovieListReactionReducer()]
)

struct AppState {
    
    var movieListState = MovieListState() {
        didSet {
            print("Movie count: \(movieListState.movies.count)")
        }
    }
    
    var loginState = LoginState()
}

extension AppState: State {
    
    mutating func react(to action: Action) {
        movieListState.react(to: action)
        loginState.react(to: action)
    }
    
    mutating func cleanUp() {
        self = AppState()
    }
}
