//
//  Operator.swift
//  HelloWorldv2
//
//  Created by Bradley Christensen on 4/24/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation

class Operator {
    
    //global constants
    let ADD_TAG = 11, SUB_TAG = 12, MUL_TAG = 13, DIV_TAG = 14, EQUALS_TAG = 15
    
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
    
/* Description */
    
    /* description
     * -----------
     */
    
    var description: String {
        return "\(type(of: self)): " + String(self.opID)
    }
    
/* Getters and Setters */
    
    func activate() {
        self.active = true
    }
    
    func changeTo(opID:Int) {
        self.opID = opID
        
    }
    
    func getPriority() -> Int {
        return (self.opID == MUL_TAG || self.opID == DIV_TAG ? 2 : 1)
    }
    
}
