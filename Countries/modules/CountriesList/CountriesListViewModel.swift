//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by adBODKAt on 26.05.2019.
//  Copyright (c) 2019 adBODKAt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol CountriesListViewOutput {
    func configure(input: CountriesListViewModel.Input) -> CountriesListViewModel.Output
    func viewReady()
}

class CountriesListViewModel: RxViewModelType, RxViewModelModuleType, CountriesListViewOutput {
    
    typealias SectionType = SectionModel<String, TableRawProtocol>
    
    private var countries = [CountryModel]()
    private var countryName = PublishRelay<String>()
    
    // MARK: In/Out struct
    struct InputDependencies {
    }
    
    struct Input {
        let cellSelect: ControlEvent<IndexPath>
        let repeatAction: Observable<Void>
    }
    
    struct Output {
        let title: Observable<String>
        let state: Observable<LoadingState>
        let error: Observable<NSError>
        let tableData: Observable<[SectionType]>
        let noInternetMessage: Observable<NSError?>
    }
    
    // MARK: Dependencies
    private let dp: InputDependencies
    private let moduleInputData: ModuleInputData
    
    // MARK: Properties
    private let bag = DisposeBag()
    private let modelState: RxViewModelStateProtocol = RxViewModelState()
    
    // MARK: Observables
    private let title:BehaviorRelay<String> = BehaviorRelay(value: "Страны".uppercased())
    private let tableData:BehaviorRelay<[SectionType]> = BehaviorRelay(value: [])
    private let noInternetMessage = PublishRelay<NSError?>()
    
    // MARK: - initializer
    
    init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
        self.dp = dependencies
        self.moduleInputData = moduleInputData
    }
    
    deinit {
        print("-- CountriesListViewModel dead")
    }
    
    // MARK: - CountriesListViewOutput
    
    func configure(input: Input) -> Output {
        // Configure input
        input.cellSelect.asObservable().subscribe(onNext: { [unowned self] (ip) in
            self.handleCellSelectionAt(ip: ip)
        }).disposed(by: bag)
        
        input.repeatAction.subscribe(onNext: { [unowned self] (_) in
            self.loadData()
        }).disposed(by: bag)
        // Configure output
        return Output(title: title.asObservable(),
                      state: modelState.state.asObservable(),
                      error: modelState.error.asObservable(),
                      tableData: tableData.asObservable(),
                      noInternetMessage: noInternetMessage.asObservable()
        )
    }
    
    // MARK: - Module configuration
    
    func configureModule(input: ModuleInput?) -> ModuleOutput {
        // Configure input signals
        // Configure module output
        return ModuleOutput(
            countryName: countryName.asObservable()
        )
    }
    
    func viewReady() {
        modelState.change(state: .loading)
        
        loadData()
    }
    
    func loadData() {
        self.moduleInputData.countriesService.loadCountriesAll { [weak self] (countries, error) in
            if let countries = countries, countries.count > 0 {
                self?.reloadData(countries)
            } else {
                self?.errorLoad(error)
            }
        }
    }
    
    func errorLoad(_ error: NSError?) {
        if !moduleInputData.reachabilityService.hasInternetConnection {
            modelState.show(error: moduleInputData.reachabilityService.reachabilityError())
        } else if error == nil {
            let err = NSError(domain: "app.countries", code: 0, userInfo: [NSLocalizedFailureErrorKey: "Неизвестная ошибка"])
            modelState.show(error: err)
        } else {
            modelState.show(error: error)
        }
    }
    
    func reloadData(_ countries: [CountryModel]) {
        self.countries.removeAll()
        self.countries.append(contentsOf: countries)
        
        var arr = [TableRow]()
        for country in countries {
            let row = CountryShortRow()
            row.configureWith(country: country)
            arr.append(row)
        }
        tableData.accept( [SectionModel(model: "", items: arr)] )
        modelState.change(state: .normal)
    }
    
    func handleCellSelectionAt(ip: IndexPath) {
        if !moduleInputData.reachabilityService.hasInternetConnection {
            noInternetMessage.accept(moduleInputData.reachabilityService.reachabilityError())
            return
        }
        let index = ip.row
        if countries.count > index {
            let name = countries[index].name
            countryName.accept(name)
        }
    }
}
