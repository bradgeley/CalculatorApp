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
    
    //global constants
    let ADD_TAG = 11, SUB_TAG = 12, MUL_TAG = 13, DIV_TAG = 14, EQUALS_TAG = 15
    
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
    
    var description: String {
        var description:String = "<\(type(of: self)):"
        
        var count:Int = 0
        for Number in self.numQueue {
            description = description + " (" + Number.string + ")"
            if (count < operatorQueue.count) {
                if (self.operatorQueue[count].opID == ADD_TAG) {
                    description = description + " " + "+"
                }
                if (self.operatorQueue[count].opID == SUB_TAG) {
                    description = description + " " + "-"
                }
                if (self.operatorQueue[count].opID == MUL_TAG) {
                    description = description + " " + "*"
                }
                if (self.operatorQueue[count].opID == DIV_TAG) {
                    description = description + " " + "/"
                }
            }
            count += 1
        }

        return description
    }
    
    
/* Calculator Button Command Processors */
    
    //Allows ViewController to send digits over so the Math Frame can process if
    //The user is typing a new number or adding to an old number
    func sendDigit(digit:Int) {
        if (!self.currentNumber.isEditable) {
            self.currentNumber = Number()
        }
        self.currentNumber.addDigit(digit: String(digit))
    }
    
    //Allows ViewController to send an operator into the Math Frame instance
    func sendOperator(op:Operator) {
        //stub
        self.currentOperator = op
        self.currentNumber.isEditable = false
        numQueue.append(self.currentNumber)
        
        //If the operator was not the equals button
        if (op.opID != EQUALS_TAG) {
            operatorQueue.append(op)
        } else { //pressed equals button
            resolveTree()
        }
    }
    
    //Clear both Arrays and start from scratch
    func allClear() {
        self.currentNumber = Number()
        self.numQueue.removeAll()
        self.operatorQueue.removeAll()
    }
    
    //Clear current number only and allow for new number input
    func clear() {
        self.currentNumber = Number()
    }
    
    //Change sign of current Number
    func changeSign() {
        if (!self.currentNumber.isEditable) {
            self.currentNumber = Number()
        }
        self.currentNumber.changeSign()
    }
    
    //Adds decimal (if possible) to current Numbers
    func addDecimal() {
        if (!self.currentNumber.isEditable) {
            self.currentNumber = Number()
        }
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
    
    /* Resolve Tree
     * ------------
     * The big boy function. The one ive dreaded to write.
     * How to resolve the tree of Numbers and Operators into
     * an answer once the user has clicked "="
     *
     * Uses a ?recursive loop? or normal loop to solve the tree
     * ?one operator at a time?
     * using multiplication and division first.
     */
    
    func resolveTree() {
        
    }
    
    
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
