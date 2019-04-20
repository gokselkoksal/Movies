//
//  ActivityTracker.swift
//  MoviesCore
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

public struct ActivityTracker {
  
  public private(set) var activityCount: UInt = 0
  public private(set) var needsUpdate = false
  
  public var isActive: Bool {
    return activityCount > 0
  }
  
  public init() { }
  
  public mutating func addActivity() {
    needsUpdate = (activityCount == 0)
    activityCount += 1
  }
  
  public mutating func removeActivity() {
    guard activityCount > 0 else {
      return
    }
    activityCount -= 1
    needsUpdate = (activityCount == 0)
  }
}

extension ActivityTracker: Equatable {
  
  public static func ==(lhs: ActivityTracker, rhs: ActivityTracker) -> Bool {
    return lhs.needsUpdate == rhs.needsUpdate && lhs.activityCount == rhs.activityCount
  }
}
