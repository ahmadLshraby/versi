//
//  SearchCell.swift
//  versi
//
//  Created by sHiKoOo on 3/28/21.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var forksCountLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    
    public private (set) var repoUrl: URL?
    
    var repo: RepoViewModel? {
        didSet {
            nameLbl.text = repo?.name
            descriptionLbl.text = repo?.description
            forksCountLbl.text = "\(repo?.numberOfForks ?? 0)"
            languageLbl.text = repo?.language
            repoUrl = repo?.repoUrl
            if let url = repo?.imageUrl {
                imgView.downsampleImageForURL(imageLink: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imgView.kf.cancelDownloadTask()
        imgView.image = nil
    }

}
