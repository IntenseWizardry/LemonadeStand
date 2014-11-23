//
//  Random.swift
//  Lemonade Stand
//
//  Created by Abed Alsolaiman on 11/16/14.
//  Copyright (c) 2014 Abed Alsolaiman. All rights reserved.
//

import Foundation

class Random {
    
    class func number(x: Int) -> Int {
        var result = Int(arc4random_uniform(UInt32(x)))
        return result
    }
    
}