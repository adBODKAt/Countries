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
    private let title:BehaviorRelay<String> = BehaviorRelay(value: "Страны".uppercased())
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
        input.cellSelect.asObservable().subscribe(onNext: { [weak self] (ip) in
            self?.handleCellSelectionAt(ip: ip)
        }).disposed(by: bag)
        // Configure output
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
            countryName: countryName.asObservable()
        )
    }
    
    func viewReady() {
        modelState.change(state: .loading)
        
        self.moduleInputData.countriesService.loadCountriesAll { [weak self] (countries, error) in
            if let countries = countries {
                self?.reloadData(countries)
            } else {
                self?.errorLoad(error)
            }
        }
    }
    
    func errorLoad(_ error: NSError?) {
        modelState.show(error: error)
    }
    
    func reloadData(_ countries: [CountryModel]) {
        modelState.change(state: .normal)
        self.countries.removeAll()
        self.countries.append(contentsOf: countries)
        
        var arr = [TableRow]()
        for country in countries {
            let row = tableRowFor(country: country)
            arr.append(row)
        }
        tableData.accept( [SectionModel(model: "", items: arr)] )
    }
    
    func tableRowFor(country: CountryModel) -> TableRow {
        let row = CountryShortRow()
        row.name = country.name
        row.nativeName = country.nativeName
        row.population = country.population
        return row
    }
    
    func handleCellSelectionAt(ip: IndexPath) {
        let index = ip.row
        if countries.count > index {
            let name = countries[index].name
            countryName.accept(name)
        }
    }
}
