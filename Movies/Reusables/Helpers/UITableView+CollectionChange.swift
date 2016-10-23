//
//  UITableView+CollectionChange.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

extension UITableView {
    
    func applyCollectionChange(
        _ change: CollectionChange,
        toSection section: Int,
                  withAnimation animation: UITableViewRowAnimation)
    {
        func makeIndexPath(_ index: Int) -> IndexPath {
            return IndexPath(row: index, section: section)
        }
        
        func makeIndexPaths(_ indexes: IndexSetConvertible) -> [IndexPath] {
            return indexes.toIndexSet().map { makeIndexPath($0) }
        }
        
        switch change {
        case .update(let indexes):
            reloadRows(at: makeIndexPaths(indexes), with: animation)
        case .insertion(let indexes):
            insertRows(at: makeIndexPaths(indexes), with: animation)
        case .deletion(let indexes):
            deleteRows(at: makeIndexPaths(indexes), with: animation)
        case .move(let from, let to):
            moveRow(at: makeIndexPath(from), to: makeIndexPath(to))
        case .reload:
            reloadData()
        }
    }
}
