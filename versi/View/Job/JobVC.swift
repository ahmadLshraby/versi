//
//  JobVC.swift
//  versi
//
//  Created by sHiKoOo on 3/29/21.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class JobVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var search = UISearchController(searchResultsController: nil)
    let jobViewModel = JobViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobViewModel.getJobsData()
        setupNavigationSearch()
        bindTableView()
        subscribeToLoading()
        subscribeToValidData()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func bindTableView() {
        jobViewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: "JobCell")) {
            (row, job: JobModelData, cell: JobCell) in
            cell.job = JobCellViewModel(job: job)
        }.disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        jobViewModel.isLoading.subscribe(onNext: { (loading) in
            if loading {
                self.shouldPresentLoadingView(true)
            }else {
                self.shouldPresentLoadingView(false)
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToValidData() {
        jobViewModel.isValidDataSource.subscribe(onNext: { (valid) in
            if valid {
                self.tableView.isHidden = false
            }else {
                self.tableView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        jobViewModel.errorString.subscribe(onNext: { (string) in
            if !string.isEmpty {
                self.shouldPresentAlertView(true, title: "SORRY", alertText: string, actionTitle: "Ok", errorView: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func setupNavigationSearch() {

        search.searchBar.placeholder = "Search..."
        search.searchBar.searchTextField.leftView?.tintColor = UIColor.label
        search.searchBar.barTintColor = UIColor.label
        search.searchBar.tintColor = UIColor.label
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 14)]
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true

        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
        search.searchBar.rx.text
            .orEmpty
            .throttle(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .map {
                ($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            }
            .bind(to: jobViewModel.description)
            .disposed(by: disposeBag)
    }

}


// MARK: - UITABLEVIEW
extension JobVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? JobCell {
            if let url = cell.jobUrl {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
