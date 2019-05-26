//
//  CountriesService.swift
//  Countries
//
//
//
//

import Foundation
import RxSwift
import RxCocoa

protocol CountriesServiceProtocol {
    func loadCountriesAll(finish: @escaping ([CountryModel]?, NSError?) -> Void)
}

protocol CountryServiceProtocol {
    func loadCountryBy(name: String, finish: @escaping ([CountryModel]?, NSError?) -> Void)
}

class CountriesService: CountriesServiceProtocol, CountryServiceProtocol {
    // MARK: Private properties
    var bag = DisposeBag()
    
    // MARK: - Loading
    func loadCountriesAll(finish: @escaping ([CountryModel]?, NSError?) -> Void) {
        Network.request(.list).mapArray(CountryModel.self).subscribe(onNext: { (response) in
            finish(response, nil)
        }, onError: { (error) in
            finish(nil, error as NSError)
        }, onCompleted: nil, onDisposed: nil).disposed(by: bag)
    }
    
    func loadCountryBy(name: String, finish: @escaping ([CountryModel]?, NSError?) -> Void) {
        Network.request(.country(name: name)).mapArray(CountryModel.self).subscribe(onNext: { (response) in
            finish(response, nil)
        }, onError: { (error) in
            finish(nil, error as NSError)
        }, onCompleted: nil, onDisposed: nil).disposed(by: bag)
    }
}
