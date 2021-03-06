//
//  CountryView.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class CountryView: UIView {
    
    // MARK:- Outlets
    var tableView : UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 60), style: .plain)
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.separatorStyle = .singleLine
        view.estimatedRowHeight = 80.0
        view.rowHeight = UITableView.automaticDimension
        view.allowsSelection = false
        view.tableFooterView = UIView()
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.stopAnimating()
        return view
    }()
    
    // MARK:- Init
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        
        configureView()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = UIColor.white
    }
    
    func addSubviews() {
        addSubview(tableView)
        addSubview(activityIndicator)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.top.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
    }
    
    func setLoading(load: Bool) {
        if load {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
