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
        //Stub
        mfInstance.clear()
        updateDisplay()
    }
    
    func swapClearButton() {
        if (clearButton.title(for: .normal) == "AC") {
            clearButton.setTitle("C", for: .normal)
        } else {
            clearButton.setTitle("AC", for: .normal)
        }
        
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
    
    /* Decimal
     * -------
     * "." button. Adds a maximum of one decimal to the displayed number.
     */
    
    @IBAction func Decimal(_ sender: Any) {
        mfInstance.addDecimal()
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
    

    /* numberPressed
     * -------------
     * Buttons "0" through "9"
     * Changes the "All Clear" button to "Clear" when numbers have been typed.
     * Clear only clears the current number being typed, not all data, once
     * it has been changed.
     */
    
    @IBAction func numberPressed(_ sender: Any) {
        
        let tag = (sender as! UIButton).tag
        let num = (tag - 1)
        mfInstance.sendDigit(digit: num)
        updateDisplay()

    }

    //Addition, Subtraction, Division, Multiplication, and Equals buttons
    @IBAction func operatorPressed(_ sender: Any) {
        let tag:Int = (sender as! UIButton).tag
        let newOperator = Operator(opID: tag)
        mfInstance.sendOperator(op: newOperator)
        updateDisplay()
    }
    
/* Internal Display Functions */
    
    //Asks the Math Frame for displayable data, then displays the data.
    func updateDisplay() {
    
        let currentNumber:Number = mfInstance.getCurrentNumber()
        let currentOperator:Operator = mfInstance.getCurrentOperator()
        numLabel.text = currentNumber.toString()
        
        //deal with highlighting the current operator being used
        highlightOperator(op: currentOperator)
    }
    
    func highlightOperator(op:Operator) {
        
        //Reset highlights
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
    
    func removeCommas(num:String) -> String {
        return ""
    }
    
    func addCommas(num:String) -> String {
        return ""
    }

}

