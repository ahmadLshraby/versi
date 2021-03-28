////
////  Versi_EndPoints.swift
////  TAMM worker
////
////  Created by sHiKoOo on 2/6/21.
////
//
import Foundation
import Alamofire

enum Versi_EndPoints: EndPoint {
    // Repo
    case listCompletedOrders(q: String)
    
    var path: String {
        let baseURL = "https://api.github.com"
        switch self {
        case .listCompletedOrders(let query):
            return baseURL + "/search/repositories?\(query)&sort=stars&order=desc"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listCompletedOrders:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .listCompletedOrders:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .listCompletedOrders:
            return [:]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .listCompletedOrders(let q):
            return ["q":q]
        }
    }
    
}
