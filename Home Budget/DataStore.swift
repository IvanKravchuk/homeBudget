//
//  DataStore.swift
//  Home Budget
//
//  Created by Admin on 13.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import Foundation
class DataStore {
    static let sharedInstance = DataStore()
    private init(){}
    var categories: [Category] = []
    var transactions: [Transaction] = []
}
