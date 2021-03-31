//
//  JobCellViewModel.swift
//  versi
//
//  Created by sHiKoOo on 3/31/21.
//

import UIKit

class JobCellViewModel {
    var title: String?
    var company: String?
    var imageUrl: URL?
    var type: String?
    var repoUrl: URL?
    
    init(job: JobModelData) {
        self.title = job.title ?? ""
        self.company = "Company: \(job.company ?? "")"
        self.type = "Type: \(job.type ?? "")"
        let reUrl = job.url ?? ""
        if let url = URL(string: reUrl) {
            self.repoUrl = url
        }
        let imUrl = job.companyLogo ?? ""
        if let url = URL(string: imUrl) {
            self.imageUrl = url
        }
    }
}
