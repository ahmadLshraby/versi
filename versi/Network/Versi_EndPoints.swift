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
    case listGithubRepos(q: String)
    case listGithubJobs(description: String, fullTime: Bool, location: String)
    
    var path: String {
        switch self {
        case .listGithubRepos(let query):
            return "https://api.github.com/search/repositories?\(query)&sort=stars&order=desc"
        case .listGithubJobs(let description, let fullTime, let location):
            return "https://jobs.github.com/positions.json?description=\(description)&full_time=\(fullTime)&location=\(location)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listGithubRepos, .listGithubJobs:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .listGithubRepos, .listGithubJobs:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .listGithubRepos, .listGithubJobs:
            return [:]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .listGithubRepos(let q):
            return ["q":q]
        case .listGithubJobs(let description, let fullTime, let location):
            return ["description":description,
                    "full_time":fullTime,
                    "location":location]
        }
    }
    
}
