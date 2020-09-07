//
//  Item.swift
//  PersistentData-CoreData
//
//  Created by Jarek Adamowicz on 07/09/2020.
//  Copyright © 2020 Jarek Adamowicz. All rights reserved.
//

import Foundation


struct Item : Encodable, Decodable {
    var name : String
    var isChecked : Bool
}
