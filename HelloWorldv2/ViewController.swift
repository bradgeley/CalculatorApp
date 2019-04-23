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

    /* numberPressed
     * -------------
     * Buttons "0" through "9"
     * Removes all commas from the current number, adds the
     * input, then adds new commas to the number before displaying.
     */
    
    @IBAction func numberPressed(_ sender: Any) {
        
        let tag = (sender as! UIButton).tag
        let input = (tag - 1)
        
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

