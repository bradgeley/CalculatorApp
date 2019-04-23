//
//  ViewController.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/22/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaultNumLabel = "0"
    
    //Globabl variable to keep track of the last tag that was pressed
    var lastTagPressed:Int = 0
    var lastArithmeticTagPressed:Int = 0
    
    //Saves first number in an arithmetic operation
    var firstNumber:Double = 0
    var secondNumber:Double = 0
    
    @IBOutlet weak var numLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.
        numLabel.text = defaultNumLabel
        
    }
    
/* IBAction Functions  */
    
    /* AllClear
     * --------
     * "AC" button. Resets the current text view to the default: "0"
     */

    @IBAction func AllClear(_ sender: Any) {
        
        numLabel.text = defaultNumLabel
        
    }
    
    /* ChangeSign
     * ----------
     * "+/-" button. Changes the sign of the current number.
     */
    
    
    @IBAction func ChangeSign(_ sender: Any) {
        
        if (numLabel.text! != "0") {
            if ((numLabel.text!.contains("-"))) {
                numLabel.text = String(numLabel.text!.dropFirst())
            } else {
                numLabel.text = "-" + numLabel.text!
            }
        }
    }
    
    /* Decimal
     * -------
     * "." button. Adds a maximum of one decimal to the displayed number.
     */
    
    @IBAction func Decimal(_ sender: Any) {
        
        if !((numLabel.text!.contains(Character(".")))) {
            
            numLabel.text! += "."
            
        }
        
    }
    
    /* Percent
     * --------
     * "%" button. Divides the current number by 100.
     */
    
    @IBAction func Percent(_ sender: Any) {
        
        let numAsDouble:Double = toDouble(num: numLabel.text!)
        numLabel.text = addCommas(num: String(numAsDouble/100))
        
    }
    
    
    @IBAction func Arithmetic(_ sender: Any) {
        
        let addTag = 11, subTag = 12, mulTag = 13, divTag = 14, equalsTag = 15
        let tagPressed = (sender as! UIButton).tag
        
        //Save original number with no commas, save as a double
        let currNum:Double = toDouble(num: numLabel.text!)
        
        //If they want to change the arithmetic operator because they misclicked/changed mind
        if (lastArithmeticTagPressed != 0 && tagPressed != equalsTag) {
            
            //Rewrite the operator only, they want to change it
            lastArithmeticTagPressed = tagPressed
            
        } else {
            
            //No previous operator was pressed, and it isnt equals
            if (tagPressed != equalsTag) {
                
                //save the first number, so it can be rewritten, save the operator
                firstNumber = currNum
                lastArithmeticTagPressed = tagPressed
                
            } else {
                
                //User pressed the equals button, and they have an operator, so do the math
                if (lastTagPressed != equalsTag) {
                    secondNumber = currNum
                }
                
                //If the arithmetic operator was addition...
                if (lastArithmeticTagPressed == addTag) {
                    
                    //Add the current number to the firstNumber
                    let result = firstNumber + secondNumber //or currNum
                    firstNumber = result
                    
                    //Set the label to display the new number
                    numLabel.text = addCommas(num: String(result))
                    
                    //reset everything
                    //firstNumber = currNum
                    //lastArithmeticTagPressed = 0
                    
                }
                
                //Case where they want to do multiple equals in a row, so repeat arithmetic
                if (lastTagPressed == equalsTag) {
                    
                    
                    
                }
                
            }
            
        }
        lastTagPressed = tagPressed
        
    }
    

    /* numberPressed
     * -------------
     * Buttons "0" through "9"
     * Removes all commas from the current number, adds the
     * input, then adds new commas to the number before displaying.
     */
    
    @IBAction func numberPressed(_ sender: Any) {
        
        let tag = (sender as! UIButton).tag
        let input = (tag - 1)
        
        if (lastTagPressed == 15) {
            
            lastArithmeticTagPressed = 0
            firstNumber = 0
            
        }
        
        if (lastTagPressed == 11 || lastTagPressed == 15) {
            
            //Number was saved, so overwrite number
            numLabel.text = defaultNumLabel
            
            //Reset lastTagPressed to not interfere with number typing
            lastTagPressed = 0
            
        }
        
        //First remove commas from the current display string
        var number = removeCommas(num: numLabel.text!)
        
        if (number != "0") {
            number += String(input)
            numLabel.text = addCommas(num: number)
        } else {
            /* Special case: if user has not yet entered any number, it is "0",
               therefore it is replaced by the input to avoid a leading "0"     */
            numLabel.text! = String(input)
        }
    }
    
    
/* String Manipulation Functions */
    
    func toDouble(num:String) -> Double {
        
        let noCommas = removeCommas(num: num)
        
        return Double(noCommas)!
        
    }
    
    func removeCommas(num:String) -> String {
        
        var result:String = ""
        
        for char in num {
            
            if (char != ",") {
                result += String(char)
            }
            
        }
        
        return result
        
    }
    
    func addCommas(num:String) -> String {
        
        //Take off and save the sign, if its negative
        var sign:String = ""
        var numWithNoSign = num
        if (numLabel.text!.contains("-")) {
            //Save the sign
            sign = "-"
            //Drop the sign
            numWithNoSign = String(numWithNoSign.dropFirst())
        }
        
        //Split the number string by the decimal, if one exists
        let numSplitByDecimal:Array<Substring> = numWithNoSign.split(separator: Character("."), maxSplits: 1, omittingEmptySubsequences: true)
        
        //Initializers to save each side of the split (if a split occured)
        let numWithNoDecimal:String = String(numSplitByDecimal[0])
        var decimal:String = ""
        
        //If a split did occur, save the decimal and add back the delimeter
        if (numSplitByDecimal.count > 1) {
            decimal = "." + String(numSplitByDecimal[1])
        }
        
        //Initializers to add commas to everything on the left of decimal
        let numBackwards:String = String(numWithNoDecimal.reversed())
        var numWithCommas:String = ""
        
        //as we iterate through numBackwards, numRemaining will show only the numbers we have not yet counted
        var numRemaining = numBackwards
        
        //Count is used to iterate to 3, place a comma, then reset back to 0
        var count = 0
        
        //Iterate through numBackwards, adding each character and comma to the blank String numWithCommas
        for char in numBackwards {
            
            numWithCommas += String(char)
            numRemaining = String(numRemaining.dropFirst())
            count += 1
            
            if (count == 3) {
                
                if (numRemaining.count >= 1) {
                    numWithCommas += ","
                }
                count = 0
                
            }
            
        }
        
        //Reverse the String back to normal, and add back the decimal/sign
        return String(sign + String((numWithCommas.reversed() + decimal)))
        
    }
    

}

