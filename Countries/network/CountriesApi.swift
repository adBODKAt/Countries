//
//  Api.swift
//
//
//
//
//

import Foundation
import UIKit
import Moya

enum CountriesApi {
    case list
    case country(name: String)
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

extension CountriesApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://restcountries.eu/rest/v2")!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/all?fields=name;nativeName;population"
        case .country(let name):
            return "/name/" + name.urlEscaped + "?fields=name;nativeName;population;currencies;borders"
        }
    }
        
    var url: String {
        return "\(baseURL)\(path)"
    }
        
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        return .requestParameters(parameters: (parameters) ?? [:], encoding: parameterEncoding)
    }
    var parameters: [String : Any]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
        
    var headers: [String: String]? {
        return nil
    }
        
    var parameterEncoding: Moya.ParameterEncoding {
        return method == .get ? URLEncoding() : JSONEncoding()
    }
}

