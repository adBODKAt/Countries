//
//  CountryController.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CountryViewController: UIViewController {
    
    // MARK: - Properties
    private var repeatAction = PublishRelay<Void>()
    
    // Dependencies
    var viewModel: CountryViewOutput?
    
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
    lazy var customView = self.view as? CountryView
    
    // MARK: - View lifecycle
    override func loadView() {
        let view = CountryView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
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
        
        let input = CountryViewModel.Input(
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
        print("CountryViewController deinit")
    }
}
