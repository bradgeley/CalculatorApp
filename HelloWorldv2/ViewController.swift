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
    
    //global constants
    let ADD_TAG = 11, SUB_TAG = 12, MUL_TAG = 13, DIV_TAG = 14, EQUALS_TAG = 15
    
    //operator button colors
    let DEFAULT_ORANGE:UIColor = UIColor(cgColor: #colorLiteral(red: 1, green: 0.6636318564, blue: 0, alpha: 1))
    let HIGHLIGHTED_ORANGE:UIColor = UIColor(cgColor: #colorLiteral(red: 0.798058331, green: 0.5282882452, blue: 0.02409346029, alpha: 1))
    
    //Global variable to update calculator number display
    @IBOutlet weak var numLabel: UILabel!
    
    //Global variables to update button display
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var divButton: UIButton!
    @IBOutlet weak var mulButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    //Global variable to initialize our Math Frame instance
    var mfInstance:MathFrame!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mfInstance = MathFrame()
        
        updateDisplay()
        
        //Do any additional setup after loading the view.
        
    }
    
/* IBAction Functions  */
    
    /* AllClear
     * --------
     * "AC" button. Resets the calculator.
     * The numberPressed function changes the "All Clear" button to
     * "Clear" or the "C" button when numbers have been typed.
     * Clear only clears the current number being typed, not all data, once
     * it has been changed.
     */

    @IBAction func AllClear(_ sender: Any) {
        
        //Send command to Math Frame for processing
        if (mfInstance.clearButtonShowsAC) {
            mfInstance.allClear()
        }
        
        if (!mfInstance.clearButtonShowsAC) {
            mfInstance.clear()
        }
        
        updateDisplay()
    }
    
    /* ChangeSign
     * ----------
     * "+/-" button. Multiplies current number by -1.
     */
    
    @IBAction func ChangeSign(_ sender: Any) {
        
        //Send command to Math Frame for processing
        mfInstance.changeSign()
        
        updateDisplay()
    }
    
    /* Decimal
     * -------
     * "." button. Adds a maximum of one decimal to the displayed number.
     */
    
    @IBAction func Decimal(_ sender: Any) {
        
        //Send command to Math Frame for processing
        mfInstance.addDecimal()
        
        updateDisplay()
    }
    
    /* Percent
     * --------
     * "%" button. Divides the current number by 100.
     */
    
    @IBAction func Percent(_ sender: Any) {
        
        //Send command to Math Frame for processing
        mfInstance.percent()
        
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
        
        //Find out which number was pressed
        let tag = (sender as! UIButton).tag
        let num = (tag - 1)
        
        //Send digit to Math Frame for processing
        mfInstance.sendDigit(digit: num)
        
        updateDisplay()
    }

    //Addition, Subtraction, Division, Multiplication, and Equals buttons
    @IBAction func operatorPressed(_ sender: Any) {
        
        //Save the tag of the operator pressed
        let tag:Int = (sender as! UIButton).tag
        
        //Create new operator instance with that tag
        let newOperator = Operator(opID: tag)
        
        //Push the operator into the Math Frame for processing
        mfInstance.sendOperator(op: newOperator)
        
        updateDisplay()
    }
    
/* Internal Display Functions */
    
    //Asks the Math Frame for displayable data, then displays the data.
    func updateDisplay() {
        //Update display for number first
        displayNumber()
        
        //Find and highlight operator, if any
        let currentOperator:Operator = mfInstance.getCurrentOperator()
        highlightOperator(op: currentOperator)
        
        //Set clear button to show correct text, according to Math Frame
        let correctClearTitle:String = (mfInstance.clearButtonShowsAC ? "AC" : "C")
        clearButton.setTitle(correctClearTitle, for: .normal)
        
        //Math Frame Testing
        numLabel.adjustsFontSizeToFitWidth = true
        numLabel.text = mfInstance.description
    }
    
    func displayNumber() {
        let currentNumber:Number = mfInstance.getCurrentNumber()
        
        //Set label text to current Number, according to Math Frame
        numLabel.text = addCommas(num: currentNumber.string)

    }
    
    //First resets all highlights to default, then highlights correct operator
    func highlightOperator(op:Operator) {
        addButton.backgroundColor = DEFAULT_ORANGE
        subButton.backgroundColor = DEFAULT_ORANGE
        mulButton.backgroundColor = DEFAULT_ORANGE
        divButton.backgroundColor = DEFAULT_ORANGE

        
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
     * Takes any permutation of a number that is possible for the Calculator to display,
     * and adds commas.
     *
     * Add commas should only be used when DISPLAYING a number on the calculator.
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
            //Save the sign
            sign = "-"
            //Drop the sign
            numWithNoSign = String(numWithNoSign.dropFirst())
        }
        
        //Split the number string by the decimal, if one exists
        let numSplitByDecimal:Array<Substring> = numWithNoSign.split(separator: Character("."), maxSplits: 1, omittingEmptySubsequences: true)
        
        //Initializers to save each side of the split (if a split occured)
        let numWithNoDecimal:String = String(numSplitByDecimal[0])
        var decimal:String = (num.contains(".") ? "." : "")
        
        //If a split did occur, save the decimal and add back the delimeter
        if (numSplitByDecimal.count > 1) {
            decimal += String(numSplitByDecimal[1])
        }
        
        //Initializers to add commas to everything on the left of decimal
        let numBackwards:String = String(numWithNoDecimal.reversed())
        var numWithCommas:String = ""
        
        //as we iterate through numBackwards, numRemaining will show only the numbers we have not yet counted
        var numRemaining = numBackwards
        
        //Iterate through numBackwards, adding each character and comma to the blank String numWithCommas
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
     * Simply uses the removeAll(where:) function to find commas.
     */
    
    func removeCommas(num:String) -> String {
        let removedCharacter:Character = ","
        var result = num
        
        //Use apple code to remove all commas
        result.removeAll(where: { removedCharacter == $0 } )
        
        return result
    }
    
}

