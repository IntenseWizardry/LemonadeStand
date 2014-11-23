//
//  Factory.swift
//  Lemonade Stand
//
//  Created by Abed Alsolaiman on 11/16/14.
//  Copyright (c) 2014 Abed Alsolaiman. All rights reserved.
//

import Foundation

class Factory {
    
    
    class func createCustomer() -> Customer {
        
        var customer = Customer()
        
        let lemonadePreferenceNumber = Random.number(3)
        
        switch lemonadePreferenceNumber {
        case 0:
            customer.likesAcidicLemonade = true
        case 1:
            customer.likesEqualLemonade = true
        case 2:
            customer.likesDilutedLemonade = true
        default:
            println("Error!")
        }
        return customer
    }
    
    
    class func createManyCustomers(x: Int) -> [Customer] {
        var customers: [Customer] = []
        for var i = 0; i < x; i++ {
            var newCustomer = Factory.createCustomer()
            customers.append(newCustomer)
        }
        
        return customers
    }
    
    class func amountOfCustomers() -> Int {
        var firstd6 = Random.number(6) + 1
        var secondd6 = Random.number(6) + 1
        var result = firstd6 + secondd6
        return result
    }
    
    
}
