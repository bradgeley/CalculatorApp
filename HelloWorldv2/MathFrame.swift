//
//  Frame.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

/* WHATS NEXT?
 * -----------
 * View creates a new math frame every time the user presses
 * equals, adding the first number as the result of said
 * finished math frame. Allowing you to complete more math on
 * the answer.
 *
 * Add AC/C functionality.
 *
 * 
 */

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
    
    
/* Description */
    
    /* description
     * -----------
     * Prints all Numbers and Operators in the Math Frame in the form:
     * Example: "(-9.36) + (3.15) * (6.25) / (6.3232) + (100000.25)"
     */

    var description: String {
        var description:String = ""
        
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
    
    /* sendDigit
     * ---------
     * Allows ViewController to send digits over so the Math Frame can process if
     * The user is typing a new number or adding to an old number
     */

    func sendDigit(digit:Int) {
        if (!self.currentNumber.isEditable) {
            self.currentNumber = Number()
        }
        self.currentNumber.addDigit(digit: String(digit))
    }

    /* sendOperator
     * ---------
     * Allows ViewController to send an operator into the Math Frame instance
     * Possible operators are tags 11-15, or "+", "-", "*", "/", and "=", respectively
     *
     * Right now, pressing "=" is the only way to resolve the tree.
     */

    func sendOperator(op:Operator) {
        //stub
        self.currentOperator = op
        self.currentNumber.isEditable = false
        numQueue.append(self.currentNumber)
        
        //If the operator was not the equals button
        if (op.opID != EQUALS_TAG) {
            operatorQueue.append(op)
        } else { //pressed equals button
            do {
                //Remove extraneous operator
                if (operatorQueue.count == numQueue.count) {
                    operatorQueue.removeLast()
                }
                try self.currentNumber = resolveTree()
            } catch {
                
            }
        }
    }

    /* allClear and Clear
     * ------------------
     * Clear corresponds to the "C" button, whereas the All Clear function
     * corresponds to the "AC" button.
     *
     * Clear simply refreshes the current number being typed by the user,
     * allowing them to enter a completely different number, but keeping their
     * previous entries in tact.
     *
     * All Clear clears the entire frame, as if the user has not yet typed anything,
     * allowing them to start from scratch.
     */

    func allClear() {
        self.currentNumber = Number()
        self.numQueue.removeAll()
        self.operatorQueue.removeAll()
    }
    
    func clear() {
        self.currentNumber = Number()
    }

    /* changeSign
     * ----------
     * Changes the sign of the current number, or starts a new
     * Number that begins with "-0" where the "0" can still be
     * replaced with a digit.
     */

    func changeSign() {
        if (!self.currentNumber.isEditable) {
            self.currentNumber = Number()
        }
        self.currentNumber.changeSign()
    }

    /* addDecimal
     * ----------
     * Either creates a new number starting with "0.", or
     * adds a decimal to the current number being typed.
     *
     * Handled in the Number Class.
     */

    func addDecimal() {
        if (!self.currentNumber.isEditable) {
            self.currentNumber = Number()
        }
        self.currentNumber.addDecimal()
    }
    
    /* percent
     * -------
     * Divides the current number by 100, and makes it uneditable.
     */
    
    func percent() {
        do {
            try self.currentNumber = resolve(lhs: currentNumber, Op: Operator(opID: 14), rhs: Number(num: "100"))
        } catch {
            //Never produces an error
        }
    }
    
    /* Get/Set Current Operator
     * ------------------------
     * The current Operator describes the last operator that the user
     * typed, and may be changed by overriding with another operator button
     * press (including by just pressing equals)
     */
    
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
     *
     * The return Number is the result of the resolved equations
     */
    
    func resolveTree() throws -> Number {
        do {
            try resolveAllRecursively()
            if (numQueue.count != 0) {
                self.currentNumber = numQueue[0]
            }
        } catch {
            //Stub error handling, always returns 0
            return Number()
        }
        return self.currentNumber
    }
    
    /* Resolve All Recursively
     * -----------------------
     * HALF COMPLETE: ONLY SOLVES MULTIPLICATION
     * Goes through the tree and solves all Multiplication/Division recursively.
     */
    
    func resolveAllRecursively() throws {
        for n in 0..<self.operatorQueue.count {
            //Step 1: figure out what our numbers/operator are
            let op:Operator = self.operatorQueue[n]
            let lhs:Number = self.numQueue[n]
            let rhs:Number = self.numQueue[n+1]
            var result:Number = Number()
            //Higher priority goes first
            if (op.opID == MUL_TAG || op.opID == DIV_TAG) {
                do {
                //Step two, resolve them
                    result = try resolve(lhs: lhs, Op: op, rhs: rhs)
                //Step three, adjust the tree to show the operation has been completed
                    //Insert the result in the spot where the first number was
                    self.numQueue[n] = result
                    //Remove the operator
                    self.operatorQueue.remove(at: n)
                    //remove the Number where rhs was
                    numQueue.remove(at: n+1)
                //Step four, recur so that any other multiplication is done first
                    if (operatorQueue.count > 0) {
                        try resolveAllRecursively()
                        return
                    }
                } catch {
                    self.allClear()
                }
            }
            //If the Operator Queue has any more multiplication or division, skip
            if (!containsMultOperators(arr: self.operatorQueue) && (op.opID == ADD_TAG || op.opID == SUB_TAG)) {
                do {
                    //Step two, resolve them
                    result = try resolve(lhs: lhs, Op: op, rhs: rhs)
                    //Step three, adjust the tree to show the operation has been completed
                    //Insert the result in the spot where the first number was
                    self.numQueue[n] = result
                    //Remove the operator
                    self.operatorQueue.remove(at: n)
                    //remove the Number where rhs was
                    numQueue.remove(at: n+1)
                    //Step four, recur so that any other multiplication is done first
                    if (operatorQueue.count > 0) {
                        try resolveAllRecursively()
                        return
                    }
                } catch {
                    self.allClear()
                }
            }
        }
    }
    
    func containsMultOperators(arr: Array<Operator>) -> Bool {
        for op in arr {
            if (op.opID == MUL_TAG || op.opID == DIV_TAG) {
                return true
            }
        }
        return false
    }
    
    /* Resolve
     * -------
     * Solves the math between two numbers and the operator between.
     * Order is important, having the user's first entered number
     * always on the lhs.
     * Supplies the result as a new Number, which is uneditable.
     * Throws Divide by Zero error.
     */
    
    func resolve(lhs:Number, Op:Operator, rhs:Number) throws -> Number {
        
        //Convert Numbers to Doubles for arithmetic
        let lhsDouble:Double = lhs.toDouble()
        let rhsDouble:Double = rhs.toDouble()
        
        var resultDouble:Double = 0
        
        //Addition
        if (Op.opID == ADD_TAG) {
            resultDouble = lhsDouble + rhsDouble
        }
        
        //Subtraction
        if (Op.opID == SUB_TAG) {
            resultDouble = lhsDouble - rhsDouble
        }
        
        //Multiplication
        if (Op.opID == MUL_TAG) {
            resultDouble = lhsDouble * rhsDouble
        }
        
        //Division
        if (Op.opID == DIV_TAG) {
            if (rhsDouble == 0) {
                throw mathError.divByZero
            } else {
                resultDouble = lhsDouble / rhsDouble
            }
        }
        
        //Convert answer back to a Number
        let resultString:String = String(resultDouble) //May return as scientific notation
        return Number(num:resultString)
    }
    
    
/* Error Handling */
    
    /* Throw Error
     * -----------
     * Only error currently allowed is DIV/0
     * Displays the error in the text bar when one is thrown.
     */
    
    enum mathError: Error {
        case divByZero
    }
    
}
