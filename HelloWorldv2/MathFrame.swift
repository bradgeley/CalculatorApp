//
//  Frame.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

/* Class: Math Frame
 * -----------------
 * Structure:
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    7    |    +    | -3.5   |    *    |    0.4   |
 *       |         | leftOp  |        | rightOp |          |
 *       ---------------------------------------------------
 * Allows us to compare the priority easily between leftOp and rightOp,
 * following PEMDAS math rules. Mult/Div have higher priority than Add/Sub.
 *
 * If the user has not clicked the "equals" button, but instead continues to
 * add more operators and numbers, the frame should collapse any time a new
 * operator is pressed after the Math Frame is full.
 *
 *
 * Example 1: priority right
 *
 *         Legend
 *          ^ means the calculator is displaying this number
 *          ... Means the frame is waiting for input here.
 *
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    7    |    +    |  -2    |    *    |    0.5   |
 *       |         | leftOp  |        | rightOp |   ^...   |
 *       ---------------------------------------------------
 * Math Frame does not collapse at this state, instead waits for user input.
 * User input = "/"
 * Step 1 is to collapse the frame starting with the highest priority operation,
 * then add the new user operation
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    7    |    +    |  -1    |    /    |   ...    |
 *       |         | leftOp  |   ^    | rightOp |          |
 *       ---------------------------------------------------
 * Since the new user input was same priority as the initial rightOp, the frame
 * is not completely collapsed yet, and waits for user input of rightNum.
 * It will not collapse the frame until the user inputs an operator of equal
 * priority to leftOp, "+" or "-".
 *
 *
 * Example 2: priority left
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    5    |    *    |   3    |   ...   |          |
 *       |         | leftOp  |   ^    | rightOp |          |
 *       ---------------------------------------------------
 * The frame waits for user input of rightOp.
 * If the user enters "+", the result is:
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |   15    |    +    |  ...   |         |          |
 *       |    ^    | leftOp  |        | rightOp |          |
 *       ---------------------------------------------------
 * Since "*" was higher priority, it handled that operation right away.
 *
 *
 * Example 3: equal priority
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    5    |    +    |   3    |   ...   |          |
 *       |         | leftOp  |   ^    | rightOp |          |
 *       ---------------------------------------------------
 * The frame waits for user input of rightOp.
 * If the user enters "+", the result is:
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    8    |    +    |  ...   |         |          |
 *       |    ^    | leftOp  |        | rightOp |          |
 *       ---------------------------------------------------
 * Since "*" was higher priority, it handled that operation right away.
 *
 *
 * Example 4: Equals press
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    7    |    +    |  -2    |    *    |    0.5   |
 *       |         | leftOp  |        | rightOp |   ^...   |
 *       ---------------------------------------------------
 * First example but user hits equals.
 * Result should be:
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    6    |   ...   |        |         |          |
 *       |  ^...   | leftOp  |        | rightOp |          |
 *       ---------------------------------------------------
 * The Frame collapses entirely on an equals press. A new number
 * will override leftNum, a new operator will override leftOp.
 *
 *
 * Example 5: Multiple Equals presses
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    2    |    +    |   4    |   ...   |          |
 *       |         | leftOp  |   ^    | rightOp |          |
 *       ---------------------------------------------------
 * The frame waits for user input of rightOp.
 * If the user enters "=", the result is:
 *        __________________________________________________
 *       | leftNum |   ...   | midNum |         | rightNum |
 *       |    6    |    +    |   4    |         |          |
 *       |  ^...   | leftOp  |        | rightOp |          |
 *       ---------------------------------------------------
 * When the frame is not entirely full, an equals press does not
 * clear the frame completely.
 *
 *
 * Example 6: Percentage press 1
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |   2    |   ...   |          |
 *       |         | leftOp  |   ^    | rightOp |          |
 *       ---------------------------------------------------
 * The user clicks "%"
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |  0.02  |   ...   |          |
 *       |         | leftOp  |    ^   | rightOp |          |
 *       ---------------------------------------------------
 * The percentage button acts like the user just entered "/100"
 * and has the same priority as "/":
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |    1   |    /    |    100   |
 *       |         | leftOp  |    ^   | rightOp |          |
 *       ---------------------------------------------------
 *                                V
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |  0.01  |   ...   |          |
 *       |         | leftOp  |    ^   | rightOp |          |
 *       ---------------------------------------------------
 *
 *
 * Example 7: Percentage press 2
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |   2    |    *    |     5    |
 *       |         | leftOp  |        | rightOp |   ^...   |
 *       ---------------------------------------------------
 * The user clicks "%"
 * The percentage button acts like the user just entered "/100"
 * and has the same priority as "/":
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |   10   |    /    |    100   |
 *       |         | leftOp  |    ^   | rightOp |          |
 *       ---------------------------------------------------
 *                                V
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |   0.1  |   ...   |          |
 *       |         | leftOp  |    ^   | rightOp |          |
 *       ---------------------------------------------------
 * User must now hit enter or keep entering operations in order to get
 * the full answer.
 *
 * Example 8: Change Sign Press
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |   2    |    *    |     5    |
 *       |         | leftOp  |        | rightOp |     ^    |
 *       ---------------------------------------------------
 * The user clicks "+/-"
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |    2   |    *    |    -5    |
 *       |         | leftOp  |        | rightOp |     ^    |
 *       ---------------------------------------------------
 * Always changes sign of currently displayed number.
 *
 *
 * Example 9: Change Sign Press after operator
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |   2    |    *    |    ...   |
 *       |         | leftOp  |   ^    | rightOp |          |
 *       ---------------------------------------------------
 * The user clicks "+/-"
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    50   |    +    |    2   |    *    |  -...    |
 *       |         | leftOp  |        | rightOp |     ^    |
 *       ---------------------------------------------------
 * Allows the user to enter a negative number after the negative press.
 *
 *
 * Test implementation:
 * Theoretical Example: Multiple Equals presses for full Frame
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    2    |    +    |   4    |    *    |    2     |
 *       |         | leftOp  |   ^    | rightOp |          |
 *       ---------------------------------------------------
 * The frame waits for user input of another operator or equals.
 * If the user enters "=", the result is:
 *        __________________________________________________
 *       | leftNum |         | midNum |         | rightNum |
 *       |    10   |    *    |   2    |         |          |
 *       |    ^    | leftOp  |        | rightOp |          |
 *       ---------------------------------------------------
 * The frame collapses entirely, but leaves the original rightOp
 * and rightNum in tact in case of multiple equals presses.
 * If the user instead enters
 */

import Foundation

class MathFrame {
    var numQueue:Array<Number> = Array()
    var operatorQueue:Array<Operator> = Array()
    
    //Index in the numQueue where the current displayed number is being stored
    var currentNumberIndex:Int
    //Index in the operatorQueue where the latest operator pressed is held
    var currentOperatorIndex:Int
    
    //stub
    var currentNumber:Number
    var currentOperator:Operator
    
    //True means the "AC" button is showing, false means the "C" button is showing
    var clearButton:Bool = true
    
    init() {
        currentNumberIndex = 0
        currentOperatorIndex = 0
        
        //stub
        currentNumber = Number()
        currentOperator = Operator()
    }
    
    //ViewController will send digits to the frame once they are complete
    func sendDigit(num:Int) {
        
    }
    
    //Allows ViewController to send an operator into the Math Frame instance
    func sendOperator(op:Operator) {
        //stub
        self.currentOperator = op
    }
    
    //Clear both Arrays and start from scratch
    func allClear() {
        
    }
    
    //Clear current number only and allow for new number input
    func clear() {
        
    }
    
    //Change sign of current Number
    func changeSign() {
        
    }
    
    //Adds decimal (if possible) to current Number
    func addDecimal() {
        
    }
    
    //Divides current Number by 100
    func percent() {
        
    }
    
    //Changes which number is being displayed by the calculator
    func setCurrentNumber(index:Int) {
        //stub
    }
    
    func getCurrentNumber() -> Number {
        //stub
        return Number()
    }
    
    func setCurrentOperator(op: Operator) {
        //stub
        self.currentOperator = op
    }
    
    func getCurrentOperator() -> Operator {
        //stub
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
