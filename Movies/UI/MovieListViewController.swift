//
//  MovieListViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

final class MovieListViewController: BaseTableViewController {
    
    private struct Const {
        static let cellReuseID = "Cell"
    }
    
    var isFirstRun = true
    
    var component: MovieListComponent!
    var presentation: MovieListPresentation = MovieListPresentation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        component.subscribe(self)
        if isFirstRun {
            isFirstRun = false
            core.dispatch(component.fetchCommand())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if zap_isBeingRemoved {
            component.unsubscribe(self)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        core.dispatch(MovieListNavigatorAction.logout)
    }
    
    // MARK: Actions
    
    @IBAction func addMovieButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Add a movie",
            message: "All fields are required.",
            preferredStyle: .alert
        )
        
        alert.addTextField { (field) in
            field.placeholder = "Name"
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Year"
            field.keyboardType = .numberPad
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Rating"
            field.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let fields = alert.textFields,
                let name = fields[0].text,
                let yearString = fields[1].text,
                let ratingString = fields[2].text,
                let year = UInt(yearString),
                let rating = Float(ratingString)
            else { return }
            let movie = Movie(name: name, year: year, rating: rating)
            core.dispatch(MovieListAction.addMovie(movie))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentation.movies.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        core.dispatch(MovieListAction.removeMovie(index: indexPath.row))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var templateCell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseID)
        if templateCell == nil {
            templateCell = UITableViewCell(style: .subtitle, reuseIdentifier: Const.cellReuseID)
        }
        guard let cell = templateCell else {
            fatalError()
        }
        let moviePresentation = presentation.movies[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = moviePresentation.title
        cell.detailTextLabel?.text = moviePresentation.subtitle
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let movies = component.state.movies
        let index = indexPath.row
        if index < movies.count {
            core.dispatch(MovieListNavigatorAction.detail(movies[index]))
        }
    }
}

extension MovieListViewController {
    
    static func instantiate(with component: MovieListComponent) -> MovieListViewController {
        let sb = Storyboard.main
        let id = String(describing: self)
        let vc = sb.instantiateViewController(withIdentifier: id) as! MovieListViewController
        vc.component = component
        return vc
    }
}

// MARK: - Updates

struct MovieListPresentation {
    
    var movies: [MoviePresentation] = []
    
    mutating func update(with state: MovieListState) {
        movies = state.movies.map { MoviePresentation(movie: $0) }
    }
}

extension MovieListViewController: Subscriber {
    
    func update(with state: MovieListState) {
        presentation.update(with: state)
        state.changelog.forEach { handle(state: state, change: $0) }
    }
    
    private func handle(state: MovieListState, change: MovieListState.Change) {
        switch change {
        case .loadingState:
            if state.loadingState.needsUpdate {
                setLoading(state.loadingState.isActive)
            }
        case .movies(let collectionChange):
            tableView.applyCollectionChange(collectionChange, toSection: 0, withAnimation: .automatic)
        case .error:
            guard let error = state.error else { return }
            handle(error: error)
        }
    }
    
    private func setLoading(_ isLoading: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
}
