//
//  Store.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import Foundation
import Alamofire

protocol IStore {
    func getAll<T: Codable>(endpoint: Endpoint, clazz: T.Type, params: Parameters?, completion: @escaping(Response<[T]>)->Void)
}

class Store: IStore {
    
    static let instance = Store()
    private let baseUrl: String!
    
    private init() {
        self.baseUrl = "https://jsonplaceholder.typicode.com"
    }
    
    
    func getAll<T:Codable>(endpoint: Endpoint, clazz: T.Type, params: Parameters?, completion: @escaping (Response<[T]>) -> Void) {
        self.request(endpoint: endpoint, clazz: [[String: Any]].self, method: .get, params: params, encoding: URLEncoding.default) { (response) in
            switch response.status {
            
            case .success:
                if let dataDic = response.data {
                    do {
                        var items = [T]()
                        
                        try dataDic.forEach { (item) in
                            let decoder = JSONDecoder()
                            
                            let data = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                            let aItem: T = try decoder.decode(clazz, from: data)
                            items.append(aItem)
                        }
                        
                        completion(Response(withData: items))
                    } catch {
                        completion(Response(withFailureMessage: "Oops some error occure, please try again latter."))
                    }
                }
                break
                
            case .failure:
                let message = response.failureMsg ?? "Oops some error occure, please try again latter."
                completion(Response(withFailureMessage: message))
                break
            }
        }
    }
    
    private func request<T>(endpoint: Endpoint, clazz: T.Type, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding, completion: @escaping(Response<T>)->Void) {
        let url = baseUrl + endpoint.rawValue
        let headers: HTTPHeaders = [:]
        
        AF.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { (serverResponse) in
                switch serverResponse.result {
                case .success(let value):
                    if let rootJson = value as? T {
                        completion(Response(withData: rootJson))
                        return
                    }
                    
                    completion(Response(withFailureMessage: "Oops some error occure, please try again latter."))
                    break
                    
                    
                case .failure(let error):
                    completion(Response(withFailureMessage: error.localizedDescription))
                    break
                }
            }
    }
}
