//
//  CurrencyModel.swift
//  Countries
//
//  Created by Александр Марков on 27/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
import ObjectMapper

public struct CurrencyModel: Mappable, Equatable {
    
    var code: String = ""
    var name: String = ""
    var symbol: String = ""
    
    init() {}
    
    public init?(map: Map){}
    
    mutating public func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
        symbol <- map["symbol"]
    }
    
    // MARK: - Equatable
    public static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        if lhs.code != rhs.code { return false }
        if lhs.name != rhs.name { return false }
        if lhs.symbol != rhs.symbol { return false }
        
        return true
    }
}
