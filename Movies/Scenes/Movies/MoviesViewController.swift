//
//  MoviesViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

struct MoviesPresentation {
    
    struct MoviePresentation {
        let title, subtitle: String
    }
    
    var movies: [MoviePresentation] = []
    
    mutating func update(withState state: MoviesState) {
        movies = state.movies.map { (movie) -> MoviePresentation in
            let title = movie.name
            let subtitle = "Year: \(movie.year) | Rating: \(movie.rating)"
            return MoviePresentation(title: title, subtitle: subtitle)
        }
    }
}

class MoviesViewController: UITableViewController {
    
    private struct Const {
        static let cellReuseID = "Cell"
    }
    
    var viewModel: MoviesViewModel!
    private var presentation = MoviesPresentation()
    
    static func instantiate() -> MoviesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MoviesViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        
        self.applyState(viewModel.state)
        viewModel.stateChangeHandler = { [weak self] change in
            self?.applyStateChange(change)
        }
        viewModel.fetchMovies()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Binding
    
    func applyState(_ state: MoviesState) {
        presentation.update(withState: state)
        self.tableView.reloadData()
    }
    
    func applyStateChange(_ change: MoviesState.Change) {
        switch change {
        case .movies(let collectionChange):
            presentation.update(withState: viewModel.state)
            tableView.applyCollectionChange(collectionChange, toSection: 0, withAnimation: .automatic)
        case .loadingState:
            let loadingState = viewModel.state.loadingState
            if loadingState.needsUpdate {
                UIApplication.shared.isNetworkActivityIndicatorVisible = loadingState.isActive
            }
        }
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
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
            guard let strongSelf = self,
                let fields = alert.textFields,
                let name = fields[0].text,
                let yearString = fields[1].text,
                let ratingString = fields[2].text,
                let year = UInt(yearString),
                let rating = Float(ratingString)
                else { return }
            strongSelf.viewModel.addMovie(withName: name, year: year, rating: rating)
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
        viewModel.removeMovie(at: indexPath.row)
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
    }
}
