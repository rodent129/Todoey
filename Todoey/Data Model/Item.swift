//
//  ItemDataModel.swift
//  Todoey
//
//  Created by Wang Lisa on 13/03/2018.
//  Copyright © 2018 Lisa Wang. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String
    var checked: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
}
