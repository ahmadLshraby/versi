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
    var disposeBag = DisposeBag()
    
    var repo: RepoModelData? {
        didSet {
            repoNameLbl.text = repo?.name
            repoDescLbl.text = repo?.itemDescription
            numOfForksLbl.text = "\(repo?.forksCount ?? 0)"
            languageLbl.text = repo?.language
            let reUrl = repo?.htmlURL ?? ""
            if let url = URL(string: reUrl) {
                repoUrl = url
            }
            let imUrl = repo?.owner?.avatarURL ?? ""
            if let url = URL(string: imUrl) {
                repoImgView.downsampleImageForURL(imageLink: url)
            }
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
    
}
