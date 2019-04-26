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
    //Idea for a way to track whether or not a number is an answer or an ongoing number
    var isEditable:Bool
    
    
/* Initializers */
    
    //Most used initializer, used for creating new blank number templates
    init () {
        self.string = "0"
        self.isEditable = true

    }
    
    //stub, doesnt work when String(Double) converts to scientific notation
    //Also fails when Double rounds to weird numbers
    //Should only be used for the uneditable answer
    init (num:Double) {
        self.string = String(num)
        self.isEditable = false
    }
    
    //Initializer from a full number String. Not editable.
    init (num:String) {
        self.string = num
        self.isEditable = false
    }
    
    //Initializer from an Integer, most likely never used. Might delete later.
    init (num:Int) {
        self.string = String(num)
        self.isEditable = true
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
        if (withoutSign(numString: self.string) == "0") {
            self.string = String(self.string.dropLast())
        }
        self.string += digit
    }

    //Adds decimal to Number
    func addDecimal() {
        self.string += "."
    }
    
    //Changes sign of Number string by dropping the first character, or adding the "-" to the beginning
    func changeSign() {
        if (!self.string.contains("-")) {
            self.string = "-" + self.string
        } else {
            self.string = String(self.string.dropFirst())
        }
    }
    
    func withoutSign(numString:String) -> String {
        var result = numString
        if (numString.contains("-")) {
            result = String(numString.dropFirst())
        }
        return result
    }
}
