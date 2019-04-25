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
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    
    //Global variable to initialize our Math Frame instance
    //var mfInstance:MathFrame!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
    }
    
    func swapClearButton() {
        if (clearButton.title(for: .normal) == "AC") {
            clearButton.setTitle("C", for: .normal)
        } else {
            clearButton.setTitle("AC", for: .normal)
        }
    }
    
    /* ChangeSign
     * ----------
     * "+/-" button. Multiplies current number by -1.
     */
    
    @IBAction func ChangeSign(_ sender: Any) {

    }
    
    /* Decimal
     * -------
     * "." button. Adds a maximum of one decimal to the displayed number.
     */
    
    @IBAction func Decimal(_ sender: Any) {
        
    }
    
    /* Percent
     * --------
     * "%" button. Divides the current number by 100.
     */
    
    @IBAction func Percent(_ sender: Any) {
        
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
        let input = (tag - 1)

    }
    
    
/* String Manipulation Functions */
    
    func removeCommas(num:String) -> String {
        return ""
    }
    
    func addCommas(num:String) -> String {
        return ""
    }

}

