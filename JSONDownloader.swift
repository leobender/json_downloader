// JSONDownloader.swift
// Downloads JSON Arrays and Objects via http request

import Foundation

enum APIError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case invalidURL
    case jsonParsingFailure
}

typealias JSONARRAY = [AnyObject]
typealias JSONOBJECT = [String: AnyObject]
typealias JSONArrayTaskCompletionHandler = (JSONARRAY?, APIError?) -> Void
typealias JSONObjectTaskCompletionHandler = (JSONOBJECT?, APIError?) -> Void

class JSONDownloader {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getJSONArray(with request: URLRequest, completionHandler completion: @escaping JSONArrayTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {_data, _response, _error in
            //Convert to HTTP response
            guard let httpResponse = _response as? HTTPURLResponse, _error == nil else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = _data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        
        return task
    }
    
    func getJSONObject(with request: URLRequest, completionHandler completion: @escaping JSONObjectTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {_data, _response, _error in
            guard let httpResponse = _response as? HTTPURLResponse, _error == nil else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = _data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        
        return task
    }
}
