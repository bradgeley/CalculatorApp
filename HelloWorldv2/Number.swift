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
    
    let MAX_DIGITS = 15
    
    var positive:Bool = true
    var prefix:Int = 0
    var decimal:Bool = false
    var suffix:Int = 1
    var suffixDigits:Int = 0
    
    init() {}
    
    //initializer if you want to specify the Number's structure
    init(positive:Bool, prefix:Int, decimal:Bool, suffix:String) {
        self.positive = positive
        self.prefix = prefix
        self.decimal = decimal
        self.suffixDigits = suffix.count
        self.suffix = Int("1" + suffix)!
    }
    
    //initializer from a string literal of the number. Must be proper format.
    init(num:String) {
        var numCopy = num
        if (numCopy.first == "-") {
            self.positive = false
            numCopy.removeFirst()
        }
        if (num.contains(".")) {
            self.decimal = true
            let numSplit = numCopy.split(separator: ".")
            self.prefix = Int(numSplit[0])!
            self.suffixDigits = numSplit[1].count
            let leadingOne = Int(pow(Double(10),Double(numSplit[1].count)))
            self.suffix = leadingOne + Int(numSplit[1])!
        } else {
            self.decimal = false
            self.prefix = Int(num)!
            self.suffix = 1
            self.suffixDigits = 0
        }
    }
    
    func toDouble() -> Double {
        return Double(self.toString())!
    }
    
    //Converts the Number to a String
    func toString() -> String {
        var result = ""
        if (!self.positive) { result = result + "-"}
        result = result + String(prefix)
        if (self.decimal) {
            result = result + "."
            if (suffixDigits != 0) {
                let leadingOne:Int = Int(pow(Double(10),Double(self.suffixDigits)))
                let noLeadingOne = self.suffix - leadingOne
                var activeDigits = String(noLeadingOne)
                var numActiveDigits = activeDigits.count
            
                //The only way these two values arent the same is if there were leading 0s
                while (numActiveDigits != self.suffixDigits) {
                    numActiveDigits += 1
                    activeDigits = "0" + activeDigits
                }
            result = result + activeDigits
            }
        }
        return result
    }

    /*Number class handles all digit adding internally*/
    func addDigit(digit:Int) {
        /*if (self.toDouble() == 0) {
            self.prefix = digit
        } else {
            if (!decimal) {
                self.prefix *= 10
                self.prefix += digit
            } else {
                self.suffix *= 10
                self.suffix += digit
                self.suffixDigits += 1
            }*/
        if (!decimal) {
            if (self.toDouble() == 0) {
                self.prefix = digit
            } else {
                self.prefix *= 10
                self.prefix += digit
            }
        } else {
            self.suffix *= 10
            self.suffix += digit
            self.suffixDigits += 1
        }
    }
        
        /*
        if (!decimal) {
            if (self.toDouble() == 0) {
                self.prefix = digit
            } else {
                self.prefix *= 10
                self.prefix += digit
         } else {
            self.suffix *= 10
            self.suffix += digit
            self.suffixDigits += 1
         }
         
         */
    
    func addDecimal() {
        self.decimal = true
    }
    
    func changeSign() {
        self.positive = !self.positive
    }

    //Addition Function for Number Class
    static func += (lhs: inout Number, rhs:Number) {
        lhs.prefix += rhs.prefix
        
        //Equalize suffixes
        while (lhs.suffixDigits != rhs.suffixDigits) {
            if (lhs.suffixDigits < rhs.suffixDigits) {
                lhs.addDigit(digit: 0)
            } else {
                rhs.addDigit(digit: 0)
            }
        }
        
        //subtract off leading 1's
        let leadingOnes:Int = Int(pow(Double(10),Double(lhs.suffixDigits)))
        let suffixSum = lhs.suffix + rhs.suffix - 2 * leadingOnes
        
        //Decimal addition did not overload
        if (suffixSum - leadingOnes < 0) {
            lhs.suffix = suffixSum + leadingOnes
        } else {
            //Decimal addition did overload
            lhs.suffix = suffixSum
            lhs.prefix += 1
        }
        
        //Lop off any unnecessary trailing 0's
        while (lhs.suffix % 10 == 0) {
            lhs.suffix /= 10
            lhs.suffixDigits -= 1
        }
    }
}
