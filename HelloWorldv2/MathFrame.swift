//
//  Frame.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

/* Class: Math Frame
 * -----------------
 */

import Foundation

class MathFrame {
    
    //Arrays for keeping track of multiple Numbers and Operators at once
    var numQueue:Array<Number>
    var operatorQueue:Array<Operator>
    
    //Index in the numQueue where the current displayed number is being stored
    var currentNumberIndex:Int
    //Index in the operatorQueue where the latest operator pressed is held
    var currentOperatorIndex:Int
    
    //stub
    var currentNumber:Number
    var currentOperator:Operator
    
    //Bool to keep track of which version of clear button to show
    var clearButtonShowsAC:Bool = true
    
    
/* Initializer */
    
    init() {
        numQueue = Array()
        operatorQueue = Array()
        
        currentNumberIndex = 0
        currentOperatorIndex = 0
        
        //stub
        currentNumber = Number()
        currentOperator = Operator()
    }
    
    
/* Calculator Button Command Processors */
    
    //Allows ViewController to send digits over so the Math Frame can process if
    //The user is typing a new number or adding to an old number
    func sendDigit(digit:Int) {
        //Stub, always just acts like user is adding to an existing number
        self.currentNumber.addDigit(digit: String(digit))
    }
    
    //Allows ViewController to send an operator into the Math Frame instance
    func sendOperator(op:Operator) {
        //stub
        self.currentOperator = op
    }
    
    //Clear both Arrays and start from scratch
    func allClear() {
        //stub
        self.currentNumber = Number()
    }
    
    //Clear current number only and allow for new number input
    func clear() {
        //stub
        self.currentNumber = Number()
    }
    
    //Change sign of current Number
    func changeSign() {
        //stub
        self.currentNumber.changeSign()
    }
    
    //Adds decimal (if possible) to current Number
    func addDecimal() {
        //Stub: User may be starting a new number by typing "."
        self.currentNumber.addDecimal()
    }
    
    //Divides current Number by 100
    func percent() {
        self.currentNumber = resolve(lhs: currentNumber, Op: Operator(opID: 14), rhs: Number(num: "100"))
    }
    
    //Changes which number is being displayed by the calculator
    func setCurrentNumber(num:Number) {
        self.currentNumber = num
    }
    
    func getCurrentNumber() -> Number {
        return self.currentNumber
    }
    
    func setCurrentOperator(op: Operator) {
        self.currentOperator = op
    }
    
    func getCurrentOperator() -> Operator {
        return self.currentOperator
    }
    
    
/* Arithmetic Functions */
    
    
    //Solves an operation with 2 Numbers and an Operator
    func resolve(lhs:Number, Op:Operator, rhs:Number) -> Number {
        
        //Convert Numbers to Doubles for arithmetic
        let lhsDouble:Double = lhs.toDouble()
        let rhsDouble:Double = rhs.toDouble()
        var resultDouble:Double = 0
        
        //Addition
        if (Op.opID == 11) {
            resultDouble = lhsDouble + rhsDouble
        }
        
        //Subtraction
        if (Op.opID == 12) {
            resultDouble = lhsDouble - rhsDouble
        }
        
        //Multiplication
        if (Op.opID == 13) {
            resultDouble = lhsDouble * rhsDouble
        }
        
        //Division
        if (Op.opID == 14 && rhsDouble != 0) {
            resultDouble = lhsDouble / rhsDouble
        } else if (rhsDouble == 0) {
            //display error (DIV/0)
        }
        
        //Convert answer back to a Number
        let resultString:String = String(resultDouble)
        return Number(num:resultString)
    }
    
}
