//
//  ViewController.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/22/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    
/* Constants */
    
    let ADD_TAG = 11, SUB_TAG = 12, MUL_TAG = 13, DIV_TAG = 14, EQUALS_TAG = 15
    
    //operator button colors
    let DEFAULT_ORANGE:UIColor = UIColor(cgColor: #colorLiteral(red: 1, green: 0.6636318564, blue: 0, alpha: 1))
    let HIGHLIGHTED_ORANGE:UIColor = UIColor(cgColor: #colorLiteral(red: 0.798058331, green: 0.5282882452, blue: 0.02409346029, alpha: 1))
    
    
/* Global Variables */

    @IBOutlet weak var numLabel: UILabel! //Current Number display
    @IBOutlet weak var mfLabel: UILabel! //Whole equation display
    
    //Global variables to update button highlights/text
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var divButton: UIButton!
    @IBOutlet weak var mulButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
/* View Initializer */
    
    //Math Frame handles all the numbers and data organization
    var mfInstance:MathFrame!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mfInstance = MathFrame()
        
        numLabel.adjustsFontSizeToFitWidth = true
        mfLabel.adjustsFontSizeToFitWidth = true
        
        updateDisplay()
        
    }
    
    
/* IBAction Functions */
    
    /* AllClear
     * --------
     * "AC" or "C" button. Resets the calculator.
     * The numberPressed function changes the "All Clear" button to
     * "Clear" or the "C" button when numbers have been typed.
     * Clear only clears the current number being typed, not all data, once
     * it has been changed.
     */

    @IBAction func AllClear(_ sender: Any) {
        if (mfInstance.clearButtonShowsAC) {
            mfInstance.allClear()
        }
        
        if (!mfInstance.clearButtonShowsAC) {
            mfInstance.clear()
        }
        
        updateDisplay()
    }
    
    /* Percent
     * --------
     * "%" button. Divides the current number by 100.
     */
    
    @IBAction func Percent(_ sender: Any) {
        mfInstance.percent()
        
        updateDisplay()
    }
    
    /* ChangeSign
     * ----------
     * "+/-" button. Multiplies current number by -1.
     */
    
    @IBAction func ChangeSign(_ sender: Any) {
        mfInstance.changeSign()
        
        updateDisplay()
    }
    
    /* operatorPressed
     * ---------------
     * Addition, Subtraction, Division, Multiplication, and Equals buttons
     */
    
    @IBAction func operatorPressed(_ sender: Any) {
        let tag:Int = (sender as! UIButton).tag
        
        //Create new operator instance with that tag
        let newOperator = Operator(opID: tag)
        
        //Push the operator into the Math Frame for processing
        mfInstance.sendOperator(op: newOperator)
        
        updateDisplay()
    }

    /* numberPressed
     * -------------
     * Buttons "0" through "9"
     * Changes the "All Clear" button to "Clear" when numbers have been typed.
     * Clear only clears the current number being typed, not all data, once
     * it has been changed.
     */
    
    @IBAction func numberPressed(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        let num = (tag - 1) //All tags are 1 higher than their value
        
        mfInstance.sendDigit(digit: num)
        
        updateDisplay()
    }
    
    /* Decimal
     * -------
     * "." button. Adds a maximum of one decimal to the displayed number.
     */
    
    @IBAction func Decimal(_ sender: Any) {
        mfInstance.addDecimal()
        
        updateDisplay()
    }

    
/* Display Functions */
    
    /* updateDisplay
     * -------------
     * Asks the Math Frame which number to display on screen.
     * Then highlights the appropriate operator and updates the
     * clear button display.
     */
    
    func updateDisplay() {
        //Update display for number
        let currentNumber:Number = mfInstance.currentNumber
        numLabel.text = addCommas(num: currentNumber.string)
        
        //Find and highlight operator, if any
        let currentOperator:Operator = mfInstance.currentOperator
        highlightOperator(op: currentOperator)
        
        //Set clear button to show correct text, according to Math Frame
        let correctClearTitle:String = (mfInstance.clearButtonShowsAC ? "AC" : "C")
        clearButton.setTitle(correctClearTitle, for: .normal)
        
        //Math Frame Testing
        mfLabel.text = mfInstance.description
    }
    
    /* highlihtOperator
     * ----------------
     * Resets the color of all operator buttons on screen,
     * then asks the Math Frame which one, if any, to display.
     */
    
    func highlightOperator(op:Operator) {
        addButton.backgroundColor = DEFAULT_ORANGE
        subButton.backgroundColor = DEFAULT_ORANGE
        mulButton.backgroundColor = DEFAULT_ORANGE
        divButton.backgroundColor = DEFAULT_ORANGE

        //Theres probably a way to shorten the code here
        
        //Highlight addition
        if (op.opID == ADD_TAG) {
            addButton.backgroundColor = HIGHLIGHTED_ORANGE
        }
        
        //Highlight subtraction
        if (op.opID == SUB_TAG) {
            subButton.backgroundColor = HIGHLIGHTED_ORANGE
        }
        
        //Highlight multiplication
        if (op.opID == MUL_TAG) {
            mulButton.backgroundColor = HIGHLIGHTED_ORANGE
        }
        
        //Highlight division
        if (op.opID == DIV_TAG) {
            divButton.backgroundColor = HIGHLIGHTED_ORANGE
        }
        
    }
    
    
/* String Manipulation Functions */
    
    /* Add Commas
     * ----------
     * Long function, I should shorten this.
     * Takes any permutation of a number that is possible for the Calculator to display,
     * and adds commas.
     *
     * Add commas should only be used when DISPLAYING a number on the calculator,
     * Not when saving a string as the value for a Number.
     */
    
    func addCommas(num:String) -> String {
        
        //If the number is in scientific notation, do nothing
        if (num.contains("e") || num.contains("E")) {
            return num
        }
        
        //Remove commas, if any
        let numWithNoCommas = removeCommas(num: num)
        
        //Take off and save the sign, if its negative
        var sign:String = ""
        var numWithNoSign = numWithNoCommas
        if (num.contains("-")) {
            sign = "-"
            numWithNoSign = String(numWithNoSign.dropFirst())
        }
        
        //Split the number string by the decimal, if one exists
        let numSplitByDecimal:Array<Substring> = numWithNoSign.split(separator: Character("."), maxSplits: 1, omittingEmptySubsequences: true)
        
        //Initializers to save each side of the split (if a split occured)
        let numWithNoDecimal:String = String(numSplitByDecimal[0])
        var decimal:String = (num.contains(".") ? "." : "") //save to add back later
        
        //If a split did occur, save the decimal digits
        if (numSplitByDecimal.count > 1) {
            decimal += String(numSplitByDecimal[1])
        }
        
        //Reverse the num for iteration, initialize the result
        let numBackwards:String = String(numWithNoDecimal.reversed())
        var numWithCommas:String = ""
        
        //As we iterate through numBackwards, numRemaining will
        //show only the numbers we have not yet counted
        var numRemaining = numBackwards
        
        //Iterate through numBackwards, adding each character and comma
        //to the blank String numWithCommas
        var count = 0
        for char in numBackwards {
            numWithCommas += String(char)
            numRemaining = String(numRemaining.dropFirst())
            count += 1
            
            if (count == 3) {
                //The following if-statement prevents cases where the number length is multiple of 3 (e.g. ,100,000)
                if (numRemaining.count >= 1) {
                    numWithCommas += ","
                }
                count = 0
            }
        }
        
        //Reverse the String back to normal, and add back the decimal/sign
        return String(sign + String((numWithCommas.reversed() + decimal)))
    }
    
    /* Remove Commas
     * -------------
     * Simply uses the removeAll(where:) function for commas.
     */
    
    func removeCommas(num:String) -> String {
        var result = num
        result.removeAll(where: { "," == $0 } )
        return result
    }
    
}

