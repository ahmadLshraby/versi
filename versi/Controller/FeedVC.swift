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
    var dataSource = PublishSubject<[RepoModelData]>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReposData()
        bindTableView()
        setupRefreshControl()
    }
    
    func bindTableView() {
        dataSource.bind(to: tableView.rx.items(cellIdentifier: "FeedCell")) {
            (row, repo: RepoModelData, cell: FeedCell) in
            let repoVM = RepoViewModel(repoModelData: repo)
            cell.repo = repoVM
            cell.openReedmeBlock = {
                if let url = cell.repoUrl {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true, completion: nil)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Hot Github Repos 🔥", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 16.0)!])
        refreshControl.addTarget(self, action: #selector(getReposData), for: .valueChanged)
    }
    

}




// MARK: - NETWORKING
extension FeedVC {
    @objc func getReposData() {
        shouldPresentLoadingView(true)
        NetworkServices.request(endPoint: Versi_EndPoints.listCompletedOrders(q: "Swift"), responseClass: ReposData.self) { (statusCode, reposData, errorString) in
            self.shouldPresentLoadingView(false)
            self.refreshControl.endRefreshing()
            if reposData != nil && statusCode == 200 {
                if let data = reposData?.items {
                    self.dataSource.onNext(data)
                }
            }else {
                self.shouldPresentAlertView(true, title: "SORRY", alertText: errorString ?? "", actionTitle: "Ok", errorView: nil)
            }
        }
    }
}
