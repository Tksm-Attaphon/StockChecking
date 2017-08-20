//
//  Model.swift
//  Stock
//
//  Created by attaphon eamsahard on 8/17/2560 BE.
//  Copyright © 2560 attaphon eamsahard. All rights reserved.
//

import Foundation
import RealmSwift

class Status: Object {
    dynamic var date : Date? = nil
    dynamic var open : Float = 0.0
    dynamic var hight : Float = 0.0
    dynamic var low : Float = 0.0
    dynamic var close : Float = 0.0
    dynamic var change : Float = 0.0
    dynamic var percentChange : Float = 0.0
    dynamic var totalValume : Int = 0
    dynamic var totalValue : Float = 0.0 //Bath
    dynamic var owner: STOCK? // Properties can be optional
}

// Person model
class STOCK: Object {
    dynamic var name = ""
    let status = List<Status>()
}
