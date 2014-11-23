//
//  ViewController.swift
//  Lemonade Stand
//
//  Created by Abed Alsolaiman on 11/16/14.
//  Copyright (c) 2014 Abed Alsolaiman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var lemonInventoryAmountLabel: UILabel!
    @IBOutlet weak var moneyInventoryAmountLabel: UILabel!
    @IBOutlet weak var iceInventoryAmountLabel: UILabel!
    @IBOutlet weak var passersInventoryAmountLabel: UILabel!
    @IBOutlet weak var adInventoryAmountLabel: UILabel!
    @IBOutlet weak var buyersInventoryAmountLabel: UILabel!
    @IBOutlet weak var lemonadeType: UILabel!
   
    @IBOutlet weak var lemonBuyAmountLabel: UILabel!
    @IBOutlet weak var iceBuyAmountLabel: UILabel!
    @IBOutlet weak var adBuyAmountLabel: UILabel!
    
    @IBOutlet weak var iceMixAmountLabel: UILabel!
    @IBOutlet weak var lemonMixAmountLabel: UILabel!
    @IBOutlet weak var mixInfoLabel: UILabel!
    
    @IBOutlet weak var startDayButton: UIButton!
    @IBOutlet weak var trashCan: UIButton!
    @IBOutlet weak var lemonadePriceAmountLabel: UILabel!
    
    
    var lemons = 0
    var money = 0
    var ice = 0
    
    var passers = 0
    var ads = 0
    var buyers = 0
    
    var lemonBuyAmount = 0
    var iceBuyAmount = 0
    var adBuyAmount = 0
    
    var lemonMixAmount  = 0
    var iceMixAmount = 0
    
    var haveMixedToday = false
    
    var day = 1
    var weatherAddition = 0
    var lemonadePrice = 2
    var lemonadePriceCustomerDifference = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGame()
        updateView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
   
    @IBAction func subtractLemonadePriceButton(sender: UIButton) {
        if lemonadePrice - 1 != 0 {
            lemonadePrice--
            updateLemonadePriceDifference(lemonadePrice)
            updateView()
        }
    }
    
    @IBAction func addLemonadePriceButton(sender: UIButton) {
        if lemonadePrice + 1 != 4 {
            lemonadePrice++
            updateLemonadePriceDifference(lemonadePrice)
        }
        else {
            showAlertWithText(message: "You can not increase the price over $3!")
        }
        updateView()
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        lemons = 0
        money = 10
        ice = 0
        passers = 0
        ads = 0
        buyers = 0
        lemonBuyAmount = 0
        iceBuyAmount = 0
        adBuyAmount = 0
        lemonMixAmount = 0
        iceMixAmount = 0
        haveMixedToday = false
        day = 1
        weather()
        trashCan.hidden = true
        lemonadeType.hidden = true
        mixInfoLabel.hidden = true
        startDayButton.setTitle("Start Day 1!", forState: UIControlState.Normal)
        lemonadePrice = 2
        lemonadePriceCustomerDifference = 0
        updateView()
        weatherImageView.image = UIImage(named: "Mild")
    }
    
    @IBAction func trashCanButtonPressed(sender: UIButton) {
        haveMixedToday = false
        lemonadeType.hidden = true
        trashCan.hidden = true
        lemonadeType.text = ""
    }

    @IBAction func addBuyLemonButtonPressed(sender: UIButton) {
        lemonBuyAmount++
        updateView()
    }
    
    @IBAction func subtractBuyLemonButtonPressed(sender: UIButton) {
        if lemonBuyAmount > 0 {
            lemonBuyAmount--
            updateView()
        }
    }
    
    @IBAction func addBuyIceButtonPressed(sender: UIButton) {
        iceBuyAmount++
        updateView()
    }
    
    @IBAction func subtractBuyIceButtonPressed(sender: UIButton) {
        if iceBuyAmount > 0 {
            iceBuyAmount--
            updateView()
            updateInfoLabel()
        }
    }
    
    @IBAction func addBuyAdButtonPressed(sender: UIButton) {
        if adBuyAmount < 3 && ads + adBuyAmount < 3 {
           adBuyAmount++
            updateView()
        }
        else {
            showAlertWithText(message: "You can only buy up to three ads a day!")
        }
    }
    
    
    @IBAction func subtractBuyAdButtonPressed(sender: UIButton) {
        if adBuyAmount > 0 {
            adBuyAmount--
            updateView()
            updateInfoLabel()
        }
    }
    
    @IBAction func buyButtonPressed(sender: UIButton) {
        
        var currentMoney = money
        
        money -= 2 * lemonBuyAmount
        money -= 2 * iceBuyAmount
        money -= 3 * adBuyAmount
        
        if money < 0 {
            showAlertWithText(message: "Insuffiecient Credits!")
            money = currentMoney
        }
        else {
            lemons += lemonBuyAmount
            ice += iceBuyAmount
            ads += adBuyAmount
            
            lemonBuyAmount = 0
            iceBuyAmount = 0
            adBuyAmount = 0
        }
        updateView()
        if (lemons == 0 || ice == 0) && money < 2 {
            showAlertWithText(header: "You Lose!", message: "Insufficient Funds To Continue!")
        }
    }
    

    @IBAction func addMixIceButtonPressed(sender: UIButton) {
        if iceMixAmount + 1 > ice {
            showAlertWithText(message: "You need more ice!")
        }
        else {
            iceMixAmount++
            updateInfoLabel()
        }
        updateView()
    }
    
    @IBAction func subtractMixIceButtonPressed(sender: UIButton) {
        if iceMixAmount > 0 {
            iceMixAmount--
            updateView()
            updateInfoLabel()
        }
    }
    
    @IBAction func addMixLemonButtonPressed(sender: UIButton) {
        if lemonMixAmount + 1 > lemons {
            showAlertWithText (message: "You need more lemons!")
        }
        else {
            lemonMixAmount++
            updateInfoLabel()
        }
        updateView()
    }
    
    @IBAction func subtractMixLemonButtonPressed(sender: UIButton) {
        if lemonMixAmount > 0 {
            lemonMixAmount--
            updateView()
            updateInfoLabel()
        }
    }
    
    @IBAction func mixButtonPressed(sender: UIButton) {
        
        var mixedLemonade: Double = Double(lemonMixAmount) / Double(iceMixAmount)
        
        if haveMixedToday != true {
            var lemonadeIsNeutral = false
            var lemonadeIsAcidic = false
            var lemonadeIsDiluted = false
            
            lemonadeType.hidden = false
            trashCan.hidden = false
            
            if mixedLemonade == 1 {
                lemonadeIsNeutral = true
                haveMixedToday = true
                lemonadeType.text = "Neutral"
                ice -= iceMixAmount
                lemons -= lemonMixAmount
            }
            else if mixedLemonade >= 0.5 && mixedLemonade < 1.0 {
                lemonadeIsDiluted = true
                haveMixedToday = true
                lemonadeType.text = "Diluted"
                ice -= iceMixAmount
                lemons -= lemonMixAmount
            }
            else if mixedLemonade <= 2.0 && mixedLemonade > 1.0 {
                lemonadeIsAcidic = true
                haveMixedToday = true
                lemonadeType.text = "Acidic"
                ice -= iceMixAmount
                lemons -= lemonMixAmount
            }
            else if mixedLemonade < 0.5 && mixedLemonade > 0 {
                haveMixedToday = true
                lemonadeType.text = "Too Diluted"
                ice -= iceMixAmount
                lemons -= lemonMixAmount
            }
            else if iceMixAmount == 0 {
                lemonadeType.hidden = true
                trashCan.hidden = true
                showAlertWithText(message: "This is not lemonade!")
                
            }
            else if mixedLemonade > 2.0 {
                haveMixedToday = true
                lemonadeType.text = "Too Acidic"
                ice -= iceMixAmount
                lemons -= lemonMixAmount
            }
            else if mixedLemonade == 0 {
                lemonadeType.hidden = true
                trashCan.hidden = true
                showAlertWithText(message: "This is not lemonade!")
            }
            
            mixInfoLabel.hidden = true
            
            lemonMixAmount = 0
            iceMixAmount = 0
            
            updateView()
        }
        else {
            showAlertWithText(message: "You have already mixed today!")
        }
        
    }
    
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        if haveMixedToday == true {
            
            day++
            startDayButton.setTitle("Start Day " + "\(day)" + "!" , forState: UIControlState.Normal)
            haveMixedToday = false
            lemonadeType.hidden = true
            trashCan.hidden = true
            
            passers = 0
            buyers = 0
            
            let baseCustomers = Factory.amountOfCustomers()
            var todaysCustomersCount = baseCustomers + weatherAddition + lemonadePriceCustomerDifference + (ads * 5)
            
            println("Base Customers:" + "\(baseCustomers)")
            println("Weather Addition:" + "\(weatherAddition)")
            println("Lemonade Price Difference:" + "\(lemonadePriceCustomerDifference)")
            println("Ad Customers:" + "\(ads * 5)")
            println("Todays Total Customers Before Test: " + "\(todaysCustomersCount)")
            
            if testForNoCustomers(todaysCustomersCount) == false {
                todaysCustomersCount = 0
            }
            
            println("Todays Total Customers After Test: " + "\(todaysCustomersCount)")
            
            var todaysCustomers = Factory.createManyCustomers(todaysCustomersCount)
            
            
            ads = 0
            
            println(lemonadePrice)
            for customer in todaysCustomers {
                if customer.likesEqualLemonade == true {
                    if lemonadeType.text == "Neutral" {
                        buyers++
                        money += lemonadePrice
                    }
                    else {
                        passers++
                    }
                }
                else if customer.likesAcidicLemonade == true {
                    if lemonadeType.text == "Acidic" {
                        buyers++
                        money += lemonadePrice
                    }
                    else {
                        passers++
                    }
                }
                else if customer.likesDilutedLemonade == true {
                    if lemonadeType.text == "Diluted" {
                        buyers++
                        money += lemonadePrice
                    }
                    else {
                        passers++
                    }
                }
            }
            lemonMixAmount = 0
            iceMixAmount = 0
            lemonBuyAmount = 0
            iceBuyAmount = 0
            lemonadePrice = 2
            lemonadePriceCustomerDifference = 0
            weatherAddition = weather()
            updateView()
        }
        else {
            showAlertWithText(message: "You have not mixed yet!")
        }
    }
    
    func showAlertWithText (header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func updateView() {
        lemonInventoryAmountLabel.text = "\(lemons)"
        moneyInventoryAmountLabel.text = "$" + "\(money)"
        iceInventoryAmountLabel.text = "\(ice)"
        passersInventoryAmountLabel.text = "\(passers)"
        adInventoryAmountLabel.text = "\(ads)"
        buyersInventoryAmountLabel.text = "\(buyers)"
    
        lemonBuyAmountLabel.text = "\(lemonBuyAmount)"
        iceBuyAmountLabel.text = "\(iceBuyAmount)"
        adBuyAmountLabel.text = "\(adBuyAmount)"
    
        lemonMixAmountLabel.text = "\(lemonMixAmount)"
        iceMixAmountLabel.text = "\(iceMixAmount)"
        lemonadePriceAmountLabel.text = "$" + "\(lemonadePrice)"
    }
    
    func setupGame() {
        money = 10
        updateView()
    }
    
    func updateLemonadePriceDifference(price: Int) {
        if price == 1 {
            lemonadePriceCustomerDifference = 3
        }
        else if price == 2 {
            lemonadePriceCustomerDifference = 0
        }
        else if price == 3 {
            lemonadePriceCustomerDifference = -2
        }
    }
    
    
    func updateInfoLabel() {
        if lemonMixAmount != 0 && iceMixAmount != 0 {
            var mixedLemonade: Double = Double(lemonMixAmount)/Double(iceMixAmount)
            mixInfoLabel.hidden = false
            if mixedLemonade == 1 {
                mixInfoLabel.text = "This is neutral lemonade."
            }
            else if mixedLemonade >= 0.5 && mixedLemonade < 1.0  {
                mixInfoLabel.text = "This is diluted lemonade."
            }
            else if mixedLemonade <= 2.0 && mixedLemonade > 1.0 {
                mixInfoLabel.text = "This is sour lemonade."
            }
            else if mixedLemonade < 0.5 {
                mixInfoLabel.text = "This lemonade is too diluted."
            }
            else if mixedLemonade > 2.0 {
                mixInfoLabel.text = "This lemonade is too sour."
            }
        }
        else {
            mixInfoLabel.text = "This is not lemonade."
        }
    }
    
    func testForNoCustomers(customers: Int) -> Bool {
        if customers < 0 {
            return false
        }
        else {
            return true
        }
    }
    func weather() -> Int {
        
        var weatherNumber = Random.number(4)
        
        switch weatherNumber {
        case 0:
            weatherImageView.image = UIImage (named:"Cold")
            return -2
        case 1:
            weatherImageView.image = UIImage (named:"Mild")
            return 0
        case 2:
            weatherImageView.image = UIImage(named: "Mild")
            return 0
        case 3:
            weatherImageView.image = UIImage(named: "Warm")
            return 4
        default:
            return 0
        }
    }
}















