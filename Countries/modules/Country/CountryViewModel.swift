//
//  CountryViewModel.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol CountryViewOutput {
    func configure(input: CountryViewModel.Input) -> CountryViewModel.Output
    func viewReady()
}

class CountryViewModel: RxViewModelType, RxViewModelModuleType, CountryViewOutput {
    
    typealias SectionType = SectionModel<String, TableRawProtocol>
    
    // MARK: In/Out struct
    struct InputDependencies {
    }
    
    struct Input {
        let repeatAction: Observable<Void>
    }
    
    struct Output {
        let title: Observable<String>
        let state: Observable<LoadingState>
        let error: Observable<NSError>
        let tableData: Observable<[SectionType]>
    }
    
    // MARK: Dependencies
    private let dp: InputDependencies
    private let moduleInputData: ModuleInputData
    
    // MARK: Properties
    private let bag = DisposeBag()
    private let modelState: RxViewModelStateProtocol = RxViewModelState()
    
    // MARK: Observables
    private let title:BehaviorRelay<String> = BehaviorRelay(value: "")
    private let tableData:BehaviorRelay<[SectionType]> = BehaviorRelay(value: [])
    
    // MARK: - initializer
    
    init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
        self.dp = dependencies
        self.moduleInputData = moduleInputData
    }
    
    deinit {
        print("-- CardsViewModel dead")
    }
    
    // MARK: - CardsViewOutput
    
    func configure(input: Input) -> Output {
        // Configure input
        input.repeatAction.subscribe(onNext: { [unowned self] (_) in
            self.loadData()
        }).disposed(by: bag)
        // Configure output
        title.accept(moduleInputData.countryName)
        return Output(title: title.asObservable(),
                      state: modelState.state.asObservable(),
                      error: modelState.error.asObservable(),
                      tableData: tableData.asObservable()
        )
    }
    
    // MARK: - Module configuration
    
    func configureModule(input: ModuleInput?) -> ModuleOutput {
        // Configure input signals
        // Configure module output
        return ModuleOutput(
        )
    }
    
    func viewReady() {
        modelState.change(state: .loading)
        
        loadData()
    }
    
    func loadData() {
        self.moduleInputData.countryService.loadCountryBy(name: moduleInputData.countryName) { [weak self] (countries, error) in
            if let countries = countries, countries.count > 0 {
                self?.reloadData(countries[0])
            } else {
                self?.errorLoad(error)
            }
        }
    }
    
    func errorLoad(_ error: NSError?) {
        modelState.show(error: error)
    }
    
    func reloadData(_ country: CountryModel) {
        modelState.change(state: .normal)
        
        var arr = [TableRow]()
        let row = tableRowFor(country: country)
        arr.append(row)
        
        if country.borders.count > 0 {
            let bordersString = country.borders.joined(separator: ", ")
            let row = InfoRow()
            row.title = "Соседние страны:"
            row.info = bordersString
            arr.append(row)
        }
        
        if country.currencies.count > 0 {
            let currencyString = country.currencies.compactMap { (model) -> String? in
                return model.name + "(" + model.symbol + "): " + model.code
            }.joined(separator: "\n")
            let row = InfoRow()
            row.title = "Валюта:"
            row.info = currencyString
            arr.append(row)
        }
        
        tableData.accept([SectionModel(model: "", items:arr)])
    }
    
    func tableRowFor(country: CountryModel) -> TableRow {
        let row = CountryShortRow()
        row.name = country.name
        row.nativeName = country.nativeName
        row.population = country.population
        return row
    }
}
