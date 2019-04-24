//
//  File.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation




class Number {
    var positive:Bool = true
    var prefix:Int = 0
    var decimal:Bool = false
    var suffix:Int = 1
    var suffixDigits:Int = 0
    
    init() {}
    
    //suffix given as a raw decimal value with no leading 1
    init(positive:Bool, prefix:Int, decimal:Bool, suffix:String) {
        self.positive = positive
        self.prefix = prefix
        self.decimal = decimal
        self.suffixDigits = suffix.count
        self.suffix = Int("1" + suffix)!
    }
    
    func toString() -> String {
        var result = ""
        if (!self.positive) { result = result + "-"}
        result = result + String(prefix)
        if (self.decimal) {
            result = result + "."
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
        return result
    }
    
    /*Number class handles all digit adding internally*/
    func addDigit(digit:Int) {
        if (!decimal) {
            self.prefix *= 10
            self.prefix += digit
        } else {
            self.suffix *= 10
            self.suffix += digit
            self.suffixDigits += 1
        }
    }
    
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
            lhs.suffix = suffixSum
            lhs.prefix += 1
        }
        
        //Lop off trailing 0's
        while (lhs.suffix % 10 == 0) {
            lhs.suffix /= 10
            lhs.suffixDigits -= 1
        }
    }
}
