//
//  MovieListUpdater.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol MovieListViewInterface: class, ErrorHandler, FlowComponent {
    var tableView: UITableView! { get }
    func setLoading(_ isLoading: Bool)
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
    
    func proceed(to nextFlow: AnyFlow) {
        view.proceed(to: nextFlow)
    }
    
    private func handle(state: MovieListState, change: MovieListState.Change) {
        switch change {
        case .loadingState:
            if state.loadingState.needsUpdate {
                view.setLoading(state.loadingState.isActive)
            }
        case .movies(let collectionChange):
            view.tableView.applyCollectionChange(collectionChange, toSection: 0, withAnimation: .automatic)
        case .error:
            guard let error = state.error else { return }
            view.handle(error: error)
        }
    }
}
