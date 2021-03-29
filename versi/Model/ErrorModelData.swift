//
//  ErrorModelData.swift
//  versi
//
//  Created by sHiKoOo on 3/29/21.
//

import Foundation

struct ErrorModelData: Codable {
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
