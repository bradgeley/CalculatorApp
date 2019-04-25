//
//  Operator.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation

class Operator {
    
    //Unique identifier for operator
    var opID:Int
    
    //Keeps track of whether or not the Operator is active or inactive
    //Inactive means it does not have Numbers on BOTH sides of it
    //Might be unnecessary since Math Frame can keep track of that
    var active:Bool
    
    
    /* Initializers */
    init() {
        self.opID = 0
        self.active = false
    }
    
    init(opID:Int) {
        self.opID = opID
        self.active = false
    }
    
    
    /* Getters and Setters */
    func activate() {
        self.active = true
    }
    
    func changeTo(opID:Int) {
        self.opID = opID
        
    }
    
    func getPriority() -> Int {
        if (self.opID == 13 || self.opID == 14) {
            return 2
        } else { //only remaining options are 11 and 12, which are addition and subtraction
            return 1
        }
    }
    
}
