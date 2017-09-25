//
//  Transaction.swift
//  Home Budget
//
//  Created by Admin on 13.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import Foundation
class Transaction: NSObject, NSCoding {
    
    struct Keys {
        static let Name = "name"
        static let Description = "description"
        static let TypeOf = "type"
        static let Value = "value"
        static let Category = "category"
        static let Date = "date"
    }
    
    var name = ""
    var desc = ""
    var type = false
    var value = 0.0
    var category = Category()
    var date = Date()
    
    
    override init() {
        
    }
    
    init(name: String, description: String, type: Bool, value: Double, category: Category) {
        self.name = name
        self.desc = description
        self.type = type
        self.value = value
        self.category = category
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let stringDate = formatter.string(from: dateNow)
        self.date = formatter.date(from: stringDate)!
    }
    
    required init(coder aDecoder: NSCoder) {
        if let nameObj = aDecoder.decodeObject(forKey: Keys.Name) as?
            String {
            name = nameObj
        }
        if let descriptionObj = aDecoder.decodeObject(forKey: Keys.Description) as?
            String {
            desc = descriptionObj
        }
        if let typeObj = aDecoder.decodeBool(forKey: Keys.TypeOf) as?
            Bool {
            type = typeObj
        }
        if let valueObj = aDecoder.decodeDouble(forKey: Keys.Value) as?
            Double {
            value = valueObj
        }
        if let categoryObj = aDecoder.decodeObject(forKey: Keys.Category) as?
            Category {
            category = categoryObj
        }
        if let dateObj = aDecoder.decodeObject(forKey: Keys.Date) as?
            Date {
            date = dateObj
        }

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.Name)
        aCoder.encode(desc, forKey: Keys.Description)
        aCoder.encode(type, forKey: Keys.TypeOf)
        aCoder.encode(value, forKey: Keys.Value)
        aCoder.encode(category, forKey: Keys.Category)
        aCoder.encode(date, forKey: Keys.Date)
    }
    
  }
