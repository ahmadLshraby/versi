//
//  JobCell.swift
//  versi
//
//  Created by sHiKoOo on 3/29/21.
//

import UIKit
import Kingfisher

class JobCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    public private (set) var jobUrl: URL?
    
    var job: JobCellViewModel? {
        didSet {
            titleLbl.text = job?.title
            companyLbl.text = job?.company
            typeLbl.text = job?.type
            if let imgUrl = job?.imageUrl {
                imgView.downsampleImageForURL(imageLink: imgUrl)
            }
            if let url = job?.repoUrl {
                jobUrl = url
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
