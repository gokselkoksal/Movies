//
//  Movie.swift
//  MoviesCore
//
//  Created by Goksel Koksal on 05/08/16.
//  Copyright (c) 2003-2016 Monitise Group Limited. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Monitise Group Limited.
//  Any reproduction of this material must contain this notice.
//

import Foundation

public struct Movie {
  
  private static let yearBounds: ClosedRange<UInt> = 1800...2100
  private static let ratingBounds: ClosedRange<Float> = 1...5
  
  public let name: String
  public let year: UInt
  public let rating: Float
  
  public init(name: String, year: UInt, rating: Float) {
    self.name = name
    self.year = Movie.yearBounds.clamp(year)
    self.rating = Movie.ratingBounds.clamp(rating)
  }
}

extension ClosedRange where Bound: Comparable {
  
  func clamp(_ value: Bound) -> Bound {
    if value > upperBound {
      return upperBound
    } else if value < lowerBound {
      return lowerBound
    } else {
      return value
    }
  }
}

// MARK: Movie Equatable

extension Movie: Equatable {
  
  public static func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.name == rhs.name && lhs.year == rhs.year
  }
}
