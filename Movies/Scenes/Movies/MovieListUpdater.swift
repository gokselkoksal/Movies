//
//  MovieListUpdater.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol MovieListViewInterface: class {
    var tableView: UITableView! { get }
    var isLoading: Bool { get set }
    func handle(error: Error)
    func navigate(to navigation: MovieListReaction.Navigation)
}

struct MovieListPresentation {
    
    var movies: [MoviePresentation] = []
    
    mutating func update(with state: MovieListState) {
        movies = state.movies.map { MoviePresentation(movie: $0) }
    }
}

class MovieListUpdater: Subscriber {
    
    unowned var view: MovieListViewInterface
    private(set) var presentation = MovieListPresentation()
    
    init(view: MovieListViewInterface) {
        self.view = view
    }
    
    func update(with state: MovieListState) {
        presentation.update(with: state)
        state.changelog.forEach { handle(state: state, change: $0) }
    }
    
    func handle(reactions: [MovieListReaction]) {
        reactions.forEach { handle(reaction: $0) }
    }
    
    private func handle(state: MovieListState, change: MovieListState.Change) {
        switch change {
        case .loadingState:
            if state.loadingState.needsUpdate {
                view.isLoading = state.loadingState.isActive
            }
        case .movies(let collectionChange):
            view.tableView.applyCollectionChange(collectionChange, toSection: 0, withAnimation: .automatic)
        }
    }
    
    private func handle(reaction: MovieListReaction) {
        switch reaction {
        case .error(let error):
            view.handle(error: error)
        case .navigation(let navigation):
            view.navigate(to: navigation)
        }
    }
}
