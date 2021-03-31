//
//  FeedCell.swift
//  versi
//
//  Created by sHiKoOo on 3/25/21.
//

import UIKit
import Kingfisher

class FeedCell: UITableViewCell {

    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var repoDescLbl: UILabel!
    @IBOutlet weak var repoImgView: UIImageView!
    @IBOutlet weak var numOfForksLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var viewReedMeBtn: UIButton!
    
    public private (set) var repoUrl: URL?
    
    var repo: RepoCellViewMode? {
        didSet {
            repoNameLbl.text = repo?.name
            repoDescLbl.text = repo?.description
            numOfForksLbl.text = repo?.forksCount
            languageLbl.text = repo?.language
            if let imgUrl = repo?.imageUrl {
                repoImgView.downsampleImageForURL(imageLink: imgUrl)
            }
            if let url = repo?.repoUrl {
                repoUrl = url
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
