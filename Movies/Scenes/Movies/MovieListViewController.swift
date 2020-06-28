//
//  MovieListViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit
import Lightning

enum MovieListViewAction: Equatable {
  case setTitle(String)
  case setLoading(Bool)
  case updateMovies([MoviePresentation], change: CollectionChange)
}

protocol MovieListViewProtocol: class {
  func handle(_ action: MovieListViewAction)
}

// MARK: - Implementation

final class MovieListViewController: UIViewController, StoryboardInstantiatable, HasSpinner {
  
  var spinnerView: SpinnerView = SpinnerView()
  
  private enum Const {
    static let cellReuseID = "Cell"
  }
  
  static var defaultStoryboardName: String {
    return "Main"
  }
  
  var presenter: MovieListPresenterProtocol!
  private var movies: [MoviePresentation] = []
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
    }
  }
  
  @IBOutlet weak var logoutBarButton: UIBarButtonItem!
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()  
    presenter.start()
    configureAccessibilityIdentifiers()
  }
  
  private func configureAccessibilityIdentifiers() {
    tableView.accessibilityIdentifier = "movieList.tableView.movies"
    logoutBarButton.accessibilityIdentifier = "movieList.button.logout"
    addBarButton.accessibilityIdentifier = "movieList.button.add"
  }
  
  // MARK: Actions
  
  @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
    presenter.logout()
  }
  
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
      guard let self = self,
        let fields = alert.textFields,
        let name = fields[0].text,
        let year = fields[1].text,
        let rating = fields[2].text
      else { return }
      self.presenter.addMovie(name: name, year: year, rating: rating)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(addAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
}

// MARK: UITableViewDataSource

extension MovieListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    presenter.removeMovie(at: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var templateCell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseID)
    if templateCell == nil {
      templateCell = UITableViewCell(style: .subtitle, reuseIdentifier: Const.cellReuseID)
      templateCell?.accessibilityIdentifier = "movieList.tableCell.movie"
      templateCell?.textLabel?.accessibilityIdentifier = "movieListTableCell.label.title"
      templateCell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    guard let cell = templateCell else {
      fatalError()
    }
    let moviePresentation = movies[indexPath.row]
    cell.textLabel?.text = moviePresentation.title
    cell.detailTextLabel?.text = moviePresentation.subtitle
    return cell
  }
  
}

// MARK: UITableViewDelegate

extension MovieListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

extension MovieListViewController: MovieListViewProtocol {
  
  func handle(_ action: MovieListViewAction) {
    switch action {
    case .setTitle(let title):
      self.title = title
    case .setLoading(let isActive):
      setSpinnerVisible(isActive)
    case .updateMovies(let presentations, change: let change):
      movies = presentations
      tableView.applyCollectionChange(change, section: 0, animation: .automatic)
    }
  }
}
