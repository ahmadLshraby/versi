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
    
    let repoViewModel = RepoViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        bindElements()
        subscribeToLoading()
        subscribeToValidData()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func bindElements() {
        searchBar.rx.text
            .orEmpty
            .throttle(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .map {
                ($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            }
            .bind(to: repoViewModel.query)
            .disposed(by: disposeBag)
        
        repoViewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: "SearchCell")) {
            (row, repo: RepoModelData, cell: SearchCell) in
            cell.repo = repo
        }.disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        repoViewModel.isLoading.subscribe(onNext: { (loading) in
            if loading {
                self.shouldPresentLoadingView(true)
            }else {
                self.shouldPresentLoadingView(false)
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToValidData() {
        repoViewModel.isValidDataSource.subscribe(onNext: { (valid) in
            if valid {
                self.tableView.isHidden = false
            }else {
                self.tableView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        repoViewModel.errorString.subscribe(onNext: { (string) in
            if !string.isEmpty {
                self.shouldPresentAlertView(true, title: "SORRY", alertText: string, actionTitle: "Ok", errorView: nil)
            }
        }).disposed(by: disposeBag)
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


// MARK: - UITEXTFIELD
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
