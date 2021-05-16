//
//  RepoViewModel.swift
//  versi
//
//  Created by sHiKoOo on 3/25/21.
//

import UIKit
import RxSwift
import RxCocoa

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
        NetworkServices.request(endPoint: Versi_EndPoints.listGithubRepos(q: query.value), responseClass: ReposData.self) { [weak self] (reposData, networkError) in
            self?.isLoading.accept(false)
            if let data = reposData?.items {
                self?.isValidDataSource.accept(true)
                self?.errorString.accept("")
                self?.dataSource.onNext(data)
            }else if let error = networkError {
                self?.isValidDataSource.accept(false)
                switch error {
                case .connectionError(connection: let msg):
                    self?.errorString.accept(msg)
                case .responseError(response: let msg):
                    self?.errorString.accept(msg)
                case .authenticationError:
                    self?.errorString.accept("You are not authorized")
                }
            }
        }
    }
}
