//
//  CountriesListViewController.swift
//  Countries
//
//  Created by adBODKAt on 26.05.2019.
//  Copyright (c) 2019 adBODKAt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CountriesListViewController: UIViewController {
    
    // MARK: - Properties
    private var repeatAction = PublishRelay<Void>()
    
    // Dependencies
    var viewModel: CountriesListViewOutput?
    
    // Public
    var bag = DisposeBag()
    
    // Private
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TableRawProtocol>>(
        configureCell: { (_, tv, indexPath, element) in
            let identifier = element.cellIdentifier
            let cell = tv.dequeueReusableCellWithRaw(element, indexPath: indexPath)
            if let c = cell as? TableCellProtocol {
                c.configureWithModel(model: element, animated: true)
            }
            return cell
    })
    
    // IBOutlet & UI
    lazy var customView = self.view as? CountriesListView
    
    // MARK: - View lifecycle
    override func loadView() {
        let view = CountriesListView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
        self.view = view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        do {
            try self.configureRx()
        } catch(let err) {
            print(err)
        }
    }
    
    // MARK: - Appereance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Configuration
    
    private func configureRx() throws {
        guard let model = viewModel, let customView = self.customView else {
            throw RxViewModelState.viewModelError()
        }
        
        let input = CountriesListViewModel.Input(
            cellSelect: customView.tableView.rx.itemSelected,
            repeatAction: repeatAction.asObservable()
        )
        let output = model.configure(input: input)
        
        // bind title
        output.title.bind(to: self.rx.title).disposed(by: bag)

        output.tableData
            .bind(to: customView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        output.state.subscribe(onNext: { [weak self] (state) in
            if state == .loading {
                self?.customView?.setLoading(load: true)
            } else {
                self?.customView?.setLoading(load: false)
            }
        }).disposed(by: bag)

        output.error.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (error) in
                self?.showAlertMessageFor(error: error)
        }).disposed(by: bag)
        
        output.noInternetMessage.subscribe(onNext: { [weak self] (error) in
            if let error = error {
                self?.showCancellableAlertWith(userAction: nil, error: error)
            }
        }).disposed(by: bag)
        
        customView.pullToRefreshView.loadSwitch.bind(to: repeatAction).disposed(by: bag)
        
        viewModel?.viewReady()
    }
    
    private func configureUI() {
    }
    
    func showAlertMessageFor(error: NSError?) {
        let alertAction = UIAlertAction(title: "Повторить", style: UIAlertAction.Style.default) { [unowned self] (_) in
            self.repeatAction.accept(())
        }
        self.showCancellableAlertWith(userAction: alertAction, error: error)
    }
    
    deinit {
        print("CountriesListViewController deinit")
    }
}
