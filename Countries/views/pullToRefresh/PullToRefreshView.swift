//
//  PullToRefreshView.swift
//  paywash
//
//  Created by adBODKAt on 15.05.2018.
//  Copyright © 2018 East Media Ltd. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PullToRefreshView: UIView {
    
    enum PullToRefreshState {
        case normal
        case loading
    }
    
    let refreshView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    let pullToRefreshIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = false
        view.stopAnimating()
        return view
    }()
    
    private let bag = DisposeBag()
    
    private var viewRefreshOffset: CGFloat = 0.0
    private var constraint: Constraint?
    private var scrollView: UIScrollView!
    
    private let viewState = PublishRelay<PullToRefreshState>()
    private var load: Bool = false
    
    var loadSwitch = PublishRelay<Void>()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(offset: CGFloat, scrollView: UIScrollView) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: offset))
        
        viewRefreshOffset = offset
        self.scrollView = scrollView
        
        self.scrollView.rx.contentOffset.asObservable().subscribe(onNext: { [weak self] (point) in
            self?.scrollDidScroll(point)
        }).disposed(by: bag)
        self.scrollView.rx.didEndDragging.asObservable().subscribe(onNext: { [weak self] (drag) in
            self?.scrollDidEndDrag(drag)
        }).disposed(by: bag)
        
        addSubviews()
        setupView()
        setupRx()
    }
    
    private func addSubviews() {
        addSubview(refreshView)
        refreshView.addSubview(pullToRefreshIndicator)
    }
    private func setupView() {
        backgroundColor = UIColor.clear
        clipsToBounds = true
    }
    private func setupRx() {
        viewState.asObservable().subscribe(onNext: { [weak self] (state) in
            self?.updateEndgeInsets(state: state)
        }).disposed(by: bag)
    }
    func makeConstraints() {
        refreshView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(viewRefreshOffset)
        }
        pullToRefreshIndicator.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        self.snp.makeConstraints { [weak self] (maker) in
            self?.constraint = maker.height.equalTo(0).constraint
        }
    }
    
    func finishLoad() {
        viewState.accept(.normal)
    }
    func isLoad() -> Bool {
        return load
    }
    
    func scrollDidScroll(_ offset: CGPoint) {
        let yOffset = offset.y
        if let c = constraint {
            if yOffset < 0.0 {
                c.update(offset: -yOffset)
                updateIndicatorAnimation(offset: -yOffset)
            } else {
                c.update(offset: 0)
            }
        }
    }
    func scrollDidEndDrag(_ decelerate: Bool = false) {
        if -(scrollView.contentOffset.y) >= viewRefreshOffset {
            viewState.accept(.loading)
            loadSwitch.accept(())
        }
    }
    
    private func updateIndicatorAnimation(offset: CGFloat) {
        if offset >= viewRefreshOffset {
            pullToRefreshIndicator.startAnimating()
        } else {
            pullToRefreshIndicator.stopAnimating()
        }
    }
    
    private func updateEndgeInsets(state: PullToRefreshState) {
        var topInsets: CGFloat = 0.0
        load = false
        if state == .loading {
            topInsets = viewRefreshOffset
            load = true
        }
        var edge = scrollView.contentInset
        edge.top = topInsets
        scrollView.contentInset = edge
    }
}
