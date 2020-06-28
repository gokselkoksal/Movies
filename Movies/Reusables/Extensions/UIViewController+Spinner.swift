//
//  UIViewController+Spinner.swift
//  Movies
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import UIKit

final class SpinnerView: UIView {
  
  private lazy var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .white
    addSubview(activityIndicatorView)
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    accessibilityIdentifier = "common.view.spinner"
  }
  
  func start() {
    activityIndicatorView.startAnimating()
  }
  
  func stop() {
    activityIndicatorView.stopAnimating()
  }
  
  func show(in view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(self)
    leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    start()
  }
}

protocol HasSpinner {
  var spinnerView: SpinnerView { get }
  func setSpinnerVisible(_ isVisible: Bool)
  func showSpinner()
  func hideSpinner()
}

extension HasSpinner where Self: UIViewController {
  
  func setSpinnerVisible(_ isVisible: Bool) {
    if isVisible {
      showSpinner()
    } else {
      hideSpinner()
    }
  }
  
  func showSpinner() {
    spinnerView.show(in: view)
  }
  
  func hideSpinner() {
    spinnerView.removeFromSuperview()
  }
}
