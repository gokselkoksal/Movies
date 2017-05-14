//
//  Functions.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

func executeInMock(afterDelay delay: TimeInterval?, block: @escaping () -> Void) {
    if let delay = delay {
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            block()
        }
    } else {
        block()
    }
}
