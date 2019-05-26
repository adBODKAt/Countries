//
//  RouteHandler.swift
//
//
//  Created by NVV on 18/10/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import Foundation
import ObjectMapper

protocol RouteHandler: class {
    @discardableResult func handleRoute(_ route: RouteItem) -> [Presentable]
}

class RouteItem {
    
    enum ItemType {
        case main
    }
    
    let type: ItemType
    var subRoute: RouteItem?
    
    init(type: ItemType, subRoute: RouteItem? = nil) {
        self.type = type
        self.subRoute = subRoute
    }
    
}
