//
//  JobModelData.swift
//  versi
//
//  Created by sHiKoOo on 3/29/21.
//

import Foundation


struct JobModelData: Codable {
    let id, type: String?
    let url: String?
    let createdAt, company: String?
    let companyURL: String?
    let location, title, jobDescription, howToApply: String?
    let companyLogo: String?

    enum CodingKeys: String, CodingKey {
        case id, type, url
        case createdAt = "created_at"
        case company
        case companyURL = "company_url"
        case location, title
        case jobDescription = "description"
        case howToApply = "how_to_apply"
        case companyLogo = "company_logo"
    }
}
