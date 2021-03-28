//
//  FeedVC.swift
//  versi
//
//  Created by sHiKoOo on 3/25/21.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    let repoViewModel = RepoViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repoViewModel.getReposData()
        bindTableView()
        subscribeToLoading()
        subscribeToValidData()
        setupRefreshControl()
    }
    
    func bindTableView() {
        repoViewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: "FeedCell")) {
            (row, repo: RepoModelData, cell: FeedCell) in
            self.refreshControl.endRefreshing()
            cell.repo = repo
            cell.viewReedMeBtn.rx.tap.subscribe(onNext: {
                if let url = cell.repoUrl {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true, completion: nil)
                }else {
                    print("no url found")
                }
            }).disposed(by: self.disposeBag)
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
    
    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Hot Github Repos 🔥", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 16.0)!])
        refreshControl.addTarget(self, action: #selector(refreshViewModelData), for: .valueChanged)
    }
    
    @objc func refreshViewModelData() {
        repoViewModel.getReposData()
    }
    

}
