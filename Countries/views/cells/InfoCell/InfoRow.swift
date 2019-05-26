//
//  InfoRow.swift
//  Countries
//
//  Created by Александр Марков on 27/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit

class InfoRow: TableRow {
    
    typealias Identity = String
    
    var title: String = ""
    var info: String = ""
    
    override var cellIdentifier: String {
        return "InfoCell"
    }
    
    override var identity: String {
        return info
    }
    
    override func equalTo(other: TableRow) -> Bool {
        if let rhs = other as? InfoRow {
            let lhs = self
            if lhs.title != rhs.title { return false }
            if lhs.info != rhs.info { return false }
            
            return true
        }
        return false
    }
}
