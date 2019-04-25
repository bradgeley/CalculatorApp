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
    
    
/* Constants */

    //Maximum digits allowed for Number
    let MAX_DIGITS = 12
    
    
/* Global Variables */
    
    //All Number data is stored as a string for easy digit appending
    var string:String
    
    
/* Initializers */
    
    init () {
        self.string = "0"
    }
    
    //stub, doesnt work when String(Double) converts to scientific notation
    //Also fails when Double rounds to weird numbers
    init (num:Double) {
        self.string = String(num)
    }
    
    init (num:String) {
        self.string = num
    }
    
    init (num:Int) {
        self.string = String(num)
    }
    
    
/* String Manipulation Functions */
    
    func addCommas(num:String) -> String {
        return self.string //stub
    }
    
    func removeCommas(num:String) -> String {
        return self.string //stub
    }
    
    
/* Conversion functions */
    
    func toDouble() -> Double {
        return (Double(self.string) != nil ? Double(self.string)! : 0.0)
    }
    

/* Calculator button functions */
    
    func addDigit(digit:String) {
        self.string += digit
    }

    //Adds decimal to Number
    func addDecimal() {
        self.string += "."
    }
    
    //Changes sign of Number
    func changeSign() {
        if (!self.string.contains("-")) {
            self.string = "-" + self.string
        }
        
        if (self.string.contains("-")) {
            self.string = String(self.string.dropFirst())
        }
    }
}
