//
//  Coffee.swift
//  MohammedSuleiman_MyOrder
//
//  Created by Mohammed on 2021-02-05.
//

import Foundation

class Coffee{
    var type: String
    var size: String
    var numOrdered: Int
    
    init(){
        type = ""
        size = ""
        numOrdered = 0
    }
    
    init(_ Type: String, _ Size: String, _ Num: Int){
        self.type = Type
        self.size = Size
        self.numOrdered = Num
    }
}
