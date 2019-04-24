//
//  ViewController.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/22/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //global constants
    let ADD_TAG = 11, SUB_TAG = 12, MUL_TAG = 13, DIV_TAG = 14, EQUALS_TAG = 15
    
    //Set up global variable to be able to update numLabel from other functions
    @IBOutlet weak var numLabel: UILabel!
    
    //Global boolean to handle AC vs C button
    let allClear:Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.
        numLabel.text = "0"
        
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
    
    /* Arithmetic
     * ----------
     * Handles all Arithmetic buttons: "+" "-" "X" "/" "="
     */
    
    
    @IBAction func Arithmetic(_ sender: Any) {
        
       
        
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
        
        // Tags are integers ranging from 1-10, 1 for 0 and 10 for 9.
        // Therefore the value of the number pressed is tag - 1
        let input = (tag - 1)

    }
    
    
/* String Manipulation Functions */
    
    func toDouble(num:String) -> Double {
        return 0
    }
    
    func removeCommas(num:String) -> String {
        return ""
    }
    
    func addCommas(num:String) -> String {
        return ""
    }
    

}

