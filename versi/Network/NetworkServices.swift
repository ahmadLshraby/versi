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
    
    class func request<T: Codable> (endPoint: EndPoint, responseClass: T.Type, completion: @escaping (T?, NetworkServicesError?) -> Void) {
        if let connected = NetworkReachabilityManager()?.isReachable {
            if connected {
                print("ENDPOINT PATH: \(endPoint.path)\nENDPOINT PARAMS: \(endPoint.parameters)")
                AF.request(endPoint.path, method: endPoint.method, parameters: endPoint.parameters, encoding: endPoint.encoding, headers: endPoint.headers).responseJSON { (response) in
                    guard let statusCode = response.response?.statusCode else {
                        completion(nil, .responseError(response: "Code Error"))
                        return }
                    guard let jsonResponse = try? response.result.get() else {
                        completion(nil, .responseError(response: "JSON Response Error"))
                        return }
                    guard let theJsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: .prettyPrinted) else {
                        completion(nil, .responseError(response: "JSON Data Error"))
                        return }
                    print("STATUS CODE: \(statusCode)")
                    print("RESPONSE: \(jsonResponse)")
                    // SUCCESS MODEL
                    if response.error == nil {
                        do {
                            let responseObj = try JSONDecoder().decode(T.self, from: theJsonData)
                            completion(responseObj, nil)
                        } catch  {
                            do {
                                let responseObj = try JSONDecoder().decode(ErrorModelData.self, from: theJsonData)
                                completion(nil, .responseError(response: responseObj.message ?? "Error Happened"))
                            } catch  {
                                print("SUCCESS MODEL ERROR: \(error)")
                                completion(nil, .responseError(response: error.localizedDescription))
                            }
                        }
                    }else if let error = response.error {
                        completion(nil, .responseError(response: error.localizedDescription))
                    }
                }
            }else {
                completion(nil, .connectionError(connection: "Please, Check Your Internet Connection"))
            }
        }else {
            completion(nil, .connectionError(connection: "Please, Check Your Internet Connection"))
        }
    }
    
}
