//
//  RepoCellViewModel.swift
//  versi
//
//  Created by sHiKoOo on 3/31/21.
//

import UIKit

class RepoCellViewMode {
    var name: String?
    var description: String?
    var imageUrl: URL?
    var forksCount: String?
    var language: String?
    var repoUrl: URL?
    
    init(repo: RepoModelData) {
        self.name = repo.name ?? ""
        self.description = repo.itemDescription ?? ""
        self.forksCount = "\(repo.forksCount ?? 0)"
        self.language = repo.language ?? ""
        let reUrl = repo.htmlURL ?? ""
        if let url = URL(string: reUrl) {
            self.repoUrl = url
        }
        let imUrl = repo.owner?.avatarURL ?? ""
        if let url = URL(string: imUrl) {
            self.imageUrl = url
        }
    }
}
