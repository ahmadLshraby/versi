//
//  JobViewModel.swift
//  versi
//
//  Created by sHiKoOo on 3/29/21.
//

import UIKit
import RxSwift
import RxCocoa

class JobViewModel {
    
    let disposeBag = DisposeBag()
    var description = BehaviorRelay<String>(value: "")
    var fullTime = BehaviorRelay<Bool>(value: false)
    var location = BehaviorRelay<String>(value: "")
    public private (set) var isLoading = BehaviorRelay<Bool>(value: false)
    public private (set) var isValidDataSource = BehaviorRelay<Bool>(value: false)
    public private (set) var errorString = BehaviorRelay<String>(value: "")
    public private (set) var dataSource = PublishSubject<[JobModelData]>()
    
    init() {
        description.asObservable().subscribe(onNext: { [weak self] (query) in
            self?.getJobsData()
        }).disposed(by: disposeBag)
        
        fullTime.asObservable().subscribe(onNext: { [weak self] (query) in
            self?.getJobsData()
        }).disposed(by: disposeBag)
        
        location.asObservable().subscribe(onNext: { [weak self] (query) in
            self?.getJobsData()
        }).disposed(by: disposeBag)
    }
    
}


// MARK: - NETWORKING
extension JobViewModel {
    func getJobsData() {
        isLoading.accept(true)
        NetworkServices.request(endPoint: Versi_EndPoints.listGithubJobs(description: description.value, fullTime: fullTime.value, location: location.value), responseClass: [JobModelData].self) { [weak self] (jobsData, networkError) in
            self?.isLoading.accept(false)
            if let data = jobsData {
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
