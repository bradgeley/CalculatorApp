//
//  Frame.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

/* WHATS NEXT?
 * -----------
 * Add AC/C functionality.
 */

import Foundation


class MathFrame {
    
    
/* Constants */
    
    let ADD_TAG = 11, SUB_TAG = 12, MUL_TAG = 13, DIV_TAG = 14, EQUALS_TAG = 15
    
    //Arrays for keeping track of multiple Numbers and Operators at once
    var numQueue:Array<Number>
    var operatorQueue:Array<Operator>
    
    //Last number/operator to be entered, or the current number being added to
    var currentNumber:Number
    var currentOperator:Operator
    
    //Bool to keep track of which version of clear button to show
    var clearButtonShowsAC:Bool = true
    
    
/* Initializer */
    
    init() {
        numQueue = Array()
        operatorQueue = Array()
        
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
        description += " (" + currentNumber.string + ")"
        

        return description
    }


/* Calculator Button Command Processors */
    
    /* allClear and Clear
     * ------------------
     * Currently not completely functional yet.
     *
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
    
    /* percent
     * -------
     * Divides the current number by 100, and makes it uneditable.
     */
    
    func percent() {
        do {
            try self.currentNumber = resolve(lhs: currentNumber, Op: Operator(opID: 14), rhs: Number(num: "100"))
        } catch {
            
        }
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
    
    /* sendOperator
     * ---------
     * Allows ViewController to send an operator into the Math Frame instance
     * Possible operators are tags 11-15, or "+", "-", "*", "/", and "=", respectively
     *
     * Right now, pressing "=" is the only way to resolve the tree.
     */
    
    func sendOperator(op:Operator) {
        //Case where user hit 2 operators in a row
        //TO ADD: operator then equals does something?
        self.currentOperator = op
        
        //Typing of the current number is over, add to Tree.
        self.currentNumber.isEditable = false
        
        if (operatorQueue.count == numQueue.count) {
            numQueue.append(self.currentNumber)
        }
        
        if (operatorQueue.count == 0 && currentNumber.string != numQueue[0].string) {
            numQueue[0] = currentNumber
        }
        
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
                self.allClear()
            }
        }
    }
    
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
    
    
/* Arithmetic Functions */
    
    /* resolveTree
     * ------------
     * Uses a recursive loop o solve the tree one operator at a time,
     * doing all multiplication and division first.
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
    
    /* resolveAllRecursively
     * -----------------------
     * Goes through the numQueue and operatorQueue and solves all
     * Multiplication/Division, then all addition/subtraction.
     */
    
    func resolveAllRecursively() throws {
        //Recursion ends when operatorQueue is empty
        for n in 0..<self.operatorQueue.count {
            let op:Operator = self.operatorQueue[n]
            let lhs:Number = self.numQueue[n]
            let rhs:Number = self.numQueue[n+1]
            
            //Multiplatication and Division first
            if (op.opID == MUL_TAG || op.opID == DIV_TAG) {
                updateTree(lhs: lhs, op: op, rhs: rhs, index: n) //recursive
                return
            }
            
            //Addition and Subtraction second
            if (!containsMultOperators(arr: self.operatorQueue) && (op.opID == ADD_TAG || op.opID == SUB_TAG)) {
                updateTree(lhs: lhs, op: op, rhs: rhs, index: n) //recursive
                return
            }
        }
    }
    
    /* updateTree
     * ----------
     * Goes through the numQueue and operatorQueue and solves all
     * Multiplication/Division, then all addition/subtraction.
     */
    
    func updateTree(lhs:Number, op:Operator, rhs:Number, index:Int) {
        var result:Number = Number()
        do {
            //Resolve the equation
            result = try resolve(lhs: lhs, Op: op, rhs: rhs)
            //Insert the result in the spot where the first number was
            self.numQueue[index] = result
            //Remove the operator
            self.operatorQueue.remove(at: index)
            //remove the Number where rhs was
            numQueue.remove(at: index+1)
            //recur
            if (operatorQueue.count > 0) {
                try resolveAllRecursively()
                return
            }
        } catch {
            self.allClear()
        }
    }
    
    /* containsMultOperators
     * ---------------------
     * Checks if there are still multiplication or division
     * operators left in the operatorQueue.
     */
    
    func containsMultOperators(arr: Array<Operator>) -> Bool {
        for op in arr {
            if (op.opID == MUL_TAG || op.opID == DIV_TAG) {
                return true
            }
        }
        return false
    }
    
    /* resolve
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
     * Not sure how best to implement this.
     *
     * Only error currently checked for is DIV/0
     *
     * Current stub is to allClear the tree if div/0 happens.
     */
    
    enum mathError: Error {
        case divByZero
    }
    
}
