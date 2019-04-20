//
//  MovieListViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit
import Rasat
import MoviesCore

struct MovieListPresentation {
  
  struct MoviePresentation {
    let title, subtitle: String
  }
  
  var movies: [MoviePresentation] = []
  
  mutating func update(with movies: [Movie]) {
    self.movies = movies.map { (movie) -> MoviePresentation in
      let title = movie.name
      let subtitle = "Year: \(movie.year) | Rating: \(movie.rating)"
      return MoviePresentation(title: title, subtitle: subtitle)
    }
  }
}

class MovieListViewController: UITableViewController {
  
  private struct Const {
    static let cellReuseID = "Cell"
  }
  
  var useCase: MovieListUseCase!
  private var presentation = MovieListPresentation()
  private let disposeBag = DisposeBag()
  
  static func instantiate() -> MovieListViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MovieListViewController
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Movies"
    disposeBag += useCase.outputObservable.subscribe(on: .main) { [weak self] (output) in
      self?.handleOutput(output)
    }
    useCase.fetchMovies()
  }
  
  @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Binding
  
  private func handleOutput(_ output: MovieListUseCaseOutput) {
    switch output {
    case .didLoadMovies(let movies):
      presentation.update(with: movies)
      tableView.reloadData()
    case .didChangeLoadingState(let loadingState):
      if loadingState.isToggled {
        UIApplication.shared.isNetworkActivityIndicatorVisible = loadingState.isActive
      }
    case .didChangeMovies(let movies, change: let change):
      presentation.update(with: movies)
      tableView.applyCollectionChange(change, section: 0, animation: .automatic)
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
      strongSelf.useCase.addMovie(withName: name, year: year, rating: rating)
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
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    useCase.removeMovie(at: indexPath.row)
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
