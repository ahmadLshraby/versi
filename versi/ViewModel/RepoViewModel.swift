//
//  RepoViewModel.swift
//  versi
//
//  Created by sHiKoOo on 3/25/21.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class RepoViewModel {
    
    let disposeBag = DisposeBag()
    var query = BehaviorRelay<String>(value: "Swift")
    public private (set) var isLoading = BehaviorRelay<Bool>(value: false)
    public private (set) var isValidDataSource = BehaviorRelay<Bool>(value: false)
    public private (set) var errorString = BehaviorRelay<String>(value: "")
    public private (set) var dataSource = PublishSubject<[RepoModelData]>()
    
    init() {
        query.asObservable().subscribe(onNext: { [weak self] (query) in
            if !query.isEmpty {
                self?.getReposData()
            }
            })
            .disposed(by: disposeBag)
        }
    
}


// MARK: - NETWORKING
extension RepoViewModel {
    func getReposData() {
        isLoading.accept(true)
        NetworkServices.request(endPoint: Versi_EndPoints.listCompletedOrders(q: query.value), responseClass: ReposData.self) { (statusCode, reposData, errorString) in
            self.isLoading.accept(false)
            if reposData != nil && statusCode == 200 {
                if let data = reposData?.items {
                    self.isValidDataSource.accept(true)
                    self.errorString.accept("")
                    self.dataSource.onNext(data)
                }else {
                    self.isValidDataSource.accept(false)
                    self.errorString.accept(errorString ?? "")
                }
            }else {
                self.isValidDataSource.accept(false)
                self.errorString.accept(errorString ?? "")
            }
        }
    }
}
