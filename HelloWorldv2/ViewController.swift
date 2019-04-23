//
//  ViewController.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/22/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var defaultNumLabel = "0"

    @IBOutlet weak var numLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numLabel.text = defaultNumLabel
    }

    @IBAction func numberPressed(_ sender: Any) {
        
        let tag = (sender as! UIButton).tag
        let input = (tag - 1)
        
        //First remove commas from the current display string
        var number = removeCommas(num: numLabel.text!)
        
        if (number != "0") {
            number += String(input)
            numLabel.text = addCommas(num: number)
        } else {
            /* Special case: if user has not yet entered any number,
             it is 0, therefore it is replaced by the input */
            numLabel.text! = String(input)
        }
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
        
        let numBackwards:String = String(num.reversed())
        var numWithCommas:String = ""
        var numRemaining = numBackwards
        var count = 0
        
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
        
        return String(numWithCommas.reversed())
        
    }
    

}

