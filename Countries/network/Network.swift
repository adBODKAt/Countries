//
//  Network.swift
//  Getpass
//
//  Created by vadim vitvickiy on 06.12.16.
//  Copyright © 2016 vadim vitvickiy. All rights reserved.
//
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Alamofire

class Network {
    static let authException = BehaviorRelay<Bool>(value: false)
    
    fileprivate static var provider = MoyaProvider<CountriesApi>(
        endpointClosure: { (target) -> Endpoint in
            return Endpoint(
                url: target.url,
                sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers)})
}

extension Network {
    static func request(_ target: CountriesApi) -> Observable<Response> {
        print(target.method, target.headers ?? "", target.url, target.parameters ?? "")
        return provider.rx.request(target).asObservable().handleResponse().filterSuccessfulStatusCodes()
        
    }
}

extension Observable {
    
    func handleResponse() -> Observable<Element> {
        return self.do(onNext: { response in
            if let r = response as? Response {
                if r.statusCode == 403 {
                    Network.authException.accept(true)
                }
            }
        }, onError: { error in
            
//            if ReachabilityService.shared.hasInternetConnection.value == false {
//                throw ReachabilityService.shared.reachabilityError() as Error
//            }
            
            guard let e = error as? MoyaError else { throw error }
            guard case .statusCode(let response) = e else { throw error }
            
            if response.statusCode == 403 {
                Network.authException.accept(true)
            }
            
        })
    }
    
}

