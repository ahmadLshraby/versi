//
//  FeedCell.swift
//  versi
//
//  Created by sHiKoOo on 3/25/21.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FeedCell: UITableViewCell {

    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var repoDescLbl: UILabel!
    @IBOutlet weak var repoImgView: UIImageView!
    @IBOutlet weak var numOfForksLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var viewReedMeBtn: UIButton!
    
    public private (set) var repoUrl: URL?
    var openReedmeBlock: (() -> Void)? = nil
    var disposeBag = DisposeBag()
    
    var repo: RepoViewModel? {
        didSet {
            repoNameLbl.text = repo?.name
            repoDescLbl.text = repo?.description
            numOfForksLbl.text = "\(repo?.numberOfForks ?? 0)"
            languageLbl.text = repo?.language
            repoUrl = repo?.repoUrl
            if let url = repo?.imageUrl {
                repoImgView.downsampleImageForURL(imageLink: url)
            }
            
            viewReedMeBtn.rx.tap.subscribe(onNext: {
                self.openReedmeBlock?()
            }).disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        repoImgView.kf.cancelDownloadTask()
        repoImgView.image = nil
    }

    @IBAction func reedmeBtnClicked(_ sender: UIButton) {
        
    }
    
}
