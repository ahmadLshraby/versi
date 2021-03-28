//
//  RepoViewModel.swift
//  versi
//
//  Created by sHiKoOo on 3/25/21.
//

import UIKit
import Kingfisher

struct RepoViewModel {
    var imageUrl: URL?
    var name: String
    var description: String
    var numberOfForks: Int
    var language: String
    var numberOfContributors: Int
    var repoUrl: URL?
    
    init(repoModelData: RepoModelData) {
        self.name = repoModelData.name ?? ""
        self.description = repoModelData.itemDescription ?? ""
        self.numberOfForks = repoModelData.forks ?? 0
        self.language = repoModelData.language ?? ""
        self.numberOfContributors = 999 // repoModelData.numberOfContributors ?? 0
        if let url = URL(string: repoModelData.htmlURL ?? "") {
            self.repoUrl = url
        }else {
            self.repoUrl = nil
        }
        if let imgUrl = URL(string: repoModelData.owner?.avatarURL ?? "") {
            self.imageUrl = imgUrl
        }else {
            self.imageUrl = nil
        }
    }
    
}
