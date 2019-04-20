//
//  UITableView+CollectionChange.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit
import Lightning

extension UITableView {
  
  func applyCollectionChange(
    _ change: CollectionChange,
    section: Int,
    animation: UITableView.RowAnimation)
  {
    let startIndexPath = IndexPath(index: section)
    
    func toIndexPath(_ index: IndexPathConvertible) -> IndexPath {
      return startIndexPath.appending(index.asIndexPath())
    }
    
    func toIndexPathArray(_ indexes: IndexPathSetConvertible) -> [IndexPath] {
      return indexes.asIndexPathSet().map({ startIndexPath.appending($0) })
    }
    
    switch change {
    case .update(let indexes):
      
      reloadRows(at: toIndexPathArray(indexes), with: animation)
    case .insertion(let indexes):
      insertRows(at: toIndexPathArray(indexes), with: animation)
    case .deletion(let indexes):
      deleteRows(at: toIndexPathArray(indexes), with: animation)
    case .move(let from, let to):
      moveRow(at: toIndexPath(from), to: toIndexPath(to))
    case .reload:
      reloadData()
    }
  }
}
