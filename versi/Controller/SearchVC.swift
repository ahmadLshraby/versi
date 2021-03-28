//
//  SearchVC.swift
//  versi
//
//  Created by sHiKoOo on 3/28/21.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = PublishSubject<[RepoModelData]>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindElements()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func bindElements() {
        let searchResult = searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .map {
            $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            }.flatMapLatest { query -> Observable<[RepoModelData]> in
                let q = query ?? ""
                if q.isEmpty{
                    return .just([])
                }else{
                    return self.getReposData(query: q)
                }
            }.observe(on: MainScheduler.instance)
        
        searchResult.bind(to: tableView.rx.items(cellIdentifier: "SearchCell")) {
            (row, repo: RepoModelData, cell: SearchCell) in
            let repoVM = RepoViewModel(repoModelData: repo)
            cell.repo = repoVM
        }.disposed(by: disposeBag)
    }

}


// MARK: - UITABLEVIEW
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchCell {
            if let url = cell.repoUrl {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}



// MARK: - NETWORKING
extension SearchVC {
    func getReposData(query: String) -> Observable<[RepoModelData]> {
        shouldPresentLoadingView(true)
        NetworkServices.request(endPoint: Versi_EndPoints.listCompletedOrders(q: query), responseClass: ReposData.self) { (statusCode, reposData, errorString) in
            self.shouldPresentLoadingView(false)
            if reposData != nil && statusCode == 200 {
                if let data = reposData?.items {
                    self.dataSource.onNext(data)
                }
            }else {
                self.shouldPresentAlertView(true, title: "SORRY", alertText: errorString ?? "", actionTitle: "Ok", errorView: nil)
                self.dataSource.onNext([])
            }
        }
        return dataSource
    }
}


// MARK: - UITEXTFIELD
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
