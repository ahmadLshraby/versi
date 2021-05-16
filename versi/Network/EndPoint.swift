//
//  EndPoint.swift
//  TAMM worker
//
//  Created by sHiKoOo on 2/6/21.
//

import Foundation
import Alamofire

protocol EndPoint {
    
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}
