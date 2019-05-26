//
//  ReachabilityService.swift
//  paywash
//
//  Created by adBODKAt on 05.06.2018.
//  Copyright © 2018 East Media Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol ReachabilityServiceProtocol {
    var hasInternetConnection: Bool { get }
    
    func reachabilityError() -> NSError
}

class ReachabilityService: ReachabilityServiceProtocol {
    
    var hasInternetConnection = true
    let reachability = NetworkReachabilityManager()
    
    init() {
        subscribeToReachability()
    }
    
    func subscribeToReachability() {
        reachability?.listener = { [weak self] status in
            switch status {
            case .unknown:
                print("reachability unknown")
            case .notReachable:
                self?.hasInternetConnection = false
            case .reachable(_):
                self?.hasInternetConnection = true
            }
        }
        reachability?.startListening()
        
        if reachability != nil {
            hasInternetConnection = reachability!.isReachable
        }
    }
    
    func reachabilityError() -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: "Отсутствует интернет соединение"
        ]
        let error = NSError(domain: "NoConnectionException", code: 0, userInfo: userInfo)
        return error
    }
    
}
