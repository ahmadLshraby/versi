////
////  NetworkServices.swift
////  TAMM worker
////
////  Created by sHiKoOo on 2/6/21.
////
//
import Foundation
import Alamofire

class NetworkServices {
    
    class func request<T: Codable> (endPoint: EndPoint, responseClass: T.Type, completion: @escaping (Int?, T?, String?) -> Void) {
        if let connected = NetworkReachabilityManager()?.isReachable {
            if connected {
                print("ENDPOINT PATH: \(endPoint.path)\nENDPOINT PARAMS: \(endPoint.parameters)")
                AF.request(endPoint.path, method: endPoint.method, parameters: endPoint.parameters, encoding: endPoint.encoding, headers: endPoint.headers).responseJSON { (response) in
                    guard let statusCode = response.response?.statusCode else {
                        completion(0, nil, "Code Error")
                        return }
                    guard let jsonResponse = try? response.result.get() else {
                        completion(0, nil, "JSON Response Error")
                        return }
                    guard let theJsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: .prettyPrinted) else {
                        completion(0, nil, "JSON Data Error")
                        return }
                    print("STATUS CODE: \(statusCode)")
                    print("RESPONSE: \(jsonResponse)")
                    // SUCCESS MODEL
                    if statusCode == 200 {
                        do {
                            let responseObj = try JSONDecoder().decode(T.self, from: theJsonData)
                            completion(200, responseObj, nil)
                        } catch  {
                            print("SUCCESS MODEL ERROR: \(error)")
                            completion(20, nil, error.localizedDescription)
                        }
                    }else {
                        completion(0, nil, "Error Happened")
                    }
                }
            }else {
                completion(0, nil, "Please, Check Your Internet Connection")
            }
        }else {
            completion(0, nil, "Please, Check Your Internet Connection")
        }
    }
    
}
