//
//  MovieListViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class MovieListViewController: UITableViewController {
    
    private struct Const {
        static let cellReuseID = "Cell"
    }
    
    static func instantiate() -> MovieListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MovieListViewController
        return vc
    }
    
    var updater: MovieListUpdater!
    let fetchCommand = MovieListFetchCommand()
    var store: Store<AppState> {
        return sharedStore
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        updater = MovieListUpdater(view: self)
        store.fire(command: fetchCommand)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.add(
            subscriber: updater,
            selector: { $0.movieListState },
            cleanUp: { state in
                var state = state
                state.movieListState.cleanUp()
                return state
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if zap_isBeingRemoved {
            store.remove(subscriber: updater)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
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
            strongSelf.store.fire(action: MovieListAction.addMovie(name: name, year: year, rating: rating))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updater.presentation.movies.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        store.fire(action: MovieListAction.removeMovie(index: indexPath.row))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var templateCell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseID)
        if templateCell == nil {
            templateCell = UITableViewCell(style: .subtitle, reuseIdentifier: Const.cellReuseID)
        }
        guard let cell = templateCell else {
            fatalError()
        }
        let moviePresentation = updater.presentation.movies[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = moviePresentation.title
        cell.detailTextLabel?.text = moviePresentation.subtitle
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        store.fire(action: MovieListAction.showMovie(index: indexPath.row))
    }
}

extension MovieListViewController: MovieListViewInterface {
    
    var isLoading: Bool {
        get {
            return UIApplication.shared.isNetworkActivityIndicatorVisible
        }
        set {
            UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
        }
    }
    
    func handle(error: Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func navigate(to navigation: MovieListReaction.Navigation) {
        // Process navigation.
        print(navigation)
    }
}
