//
//  Randomizer.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

let randomizer = DefaultRandomizer()

protocol Randomizer {
    func randomNumber(_ lowerLimit: UInt32, _ upperLimit: UInt32) -> UInt32
    func randomBool(withRate rate: Float) -> Bool
}

class DefaultRandomizer: Randomizer {
    
    func randomNumber(_ lowerLimit: UInt32, _ upperLimit: UInt32) -> UInt32 {
        let number = arc4random_uniform(upperLimit - lowerLimit + 1) + lowerLimit
        return number
    }
    
    func randomBool(withRate rate: Float = 0.50) -> Bool {
        if rate < 0.01 {
            return false
        } else if rate > 0.99 {
            return true
        } else {
            let rate = UInt32(rate * 100)
            let number = randomNumber(1, 100)
            return number <= rate
        }
    }
}
