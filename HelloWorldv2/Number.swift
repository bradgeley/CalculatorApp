//
//  File.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation


/* Number Class
 * ------------
 * The main function of the Number class is to be able to easily
 * build a Number digit by digit in the same way that users will be
 * clicking buttons in the calculator.
 */


class Number {
    
    let MAX_DIGITS:Int = 12
    var currentDigits:Int = 1
    
    var value:Double = 0
    var decimal:Bool = false
    var currentDecimalPlacePower:Double = 0
    
/* Initializers */
    init () {}
    
    init(num:Double) {
        self.value = num
        if (Double(Int(num)) != num) {
            self.decimal = true
        }
    }
    
    init(num:Int) {
        self.value = Double(num)
    }
    
    //Must be correct format, or error
    init(num:String) {
        if (Double(num) != nil) {
            self.value = Double(num)!
        }
        //If optional check fails, the Number will and up as the default "0"
    }
    
/* String Manipulation Functions */

    func toString() -> String {
        if (!self.decimal) {
            return String(Int(self.value))
        }
        return String(self.value)
    }
    
    func removeCommas(num:String) -> String {
        return ""
    }
    
    func addCommas(num:String) -> String {
        return ""
    }

/* Calculator button functions */
    func addDigit(digit:Int) {
        if (self.currentDigits < MAX_DIGITS) {
            if (!self.decimal) {
                self.value *= 10
                self.value += Double(digit)
            } else {
                let decimalPlaceMultiplier:Double = getDecimalPlaceMultiplier()
                let placedDigit:Double = decimalPlaceMultiplier * Double(digit)
                self.value += placedDigit
                self.currentDecimalPlacePower -= 1
                self.value = roundDoubleToPlace(num: self.value, place: -Int(currentDecimalPlacePower))
            }
            self.currentDigits += 1
        }
    }
    
    func getNumActiveDigits() -> Int{
        var activeDigits:String = String(abs(self.currentDigits))
        var result = activeDigits.count
        if (activeDigits.contains(".")) {
            result -= 1
        }
        return result
    }
    
    func getDecimalPlaceMultiplier() -> Double {
        var counter = self.currentDecimalPlacePower
        var result:Double = 1.0
        while (counter <= 0) {
            result /= 10
            counter += 1
        }
        return result
    }
    
    func roundDoubleToPlace(num:Double, place:Int) -> Double {
        var multiplier = 1.0
        var counter = place
        while (counter > 0) {
            multiplier *= 10
            counter -= 1
        }
        var digitsKept = num*multiplier
        
        //Rounding .5 up
        if (Int(digitsKept + 0.5) != Int(digitsKept)) {
            digitsKept += 1
        }
        
        let finalDigits = Int(digitsKept)
        
        return Double(finalDigits)/multiplier
    }
    
    //Adds decimal to Number
    func addDecimal() {
        self.decimal = true
    }
    
    //Changes sign of Number
    func changeSign() {
        self.value *= -1
    }
}
