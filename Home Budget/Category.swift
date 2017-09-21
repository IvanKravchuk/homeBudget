//
//  Category.swift
//  Home Budget
//
//  Created by Admin on 13.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import Foundation
class Category: NSObject, NSCoding {
    
    struct Keys {
        static let Id = "id"
        static let Name = "name"
        static let Description = "description"
    }
    
    var id = ""
    var name = ""
    var desc = ""
    
    override init() {
        
    }
    
    init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.desc = description
    }
    
    required init(coder aDecoder: NSCoder) {
        if let idObj = aDecoder.decodeObject(forKey: Keys.Id) as?
            String {
            id = idObj
        }
        if let nameObj = aDecoder.decodeObject(forKey: Keys.Name) as?
            String {
            name = nameObj
        }
        if let descriptionObj = aDecoder.decodeObject(forKey: Keys.Description) as?
            String {
            desc = descriptionObj
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.Id)
        aCoder.encode(name, forKey: Keys.Name)
        aCoder.encode(desc, forKey: Keys.Description)
        
    }
    

}
