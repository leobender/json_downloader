//  Really rough usage example, may need a lot of tweaking

import Foundation

typealias StringsCompletionHandler = ([String]?, APIError?) -> Void
typealias StringCompletionHandler = (String?, APIError?) -> Void

class ApiService {

  // JSON Array example
  func getStrings(completionHandler completion: @escaping StringsCompletionHandler) {

    // Set the REST Domain
    guard var restDomain: URL = "http://www.DOMAIN.com/RESTRESOURCE" else {
        completion(nil, .invalidURL)
        return
    }

    // Construct the NSURL with query items
    let newURL = NSURLComponents(string: restDomain.absoluteString)

    // Create the URL Request with our URL
    let request = URLRequest(url: (newURL?.url)!)

    // Download and return the JSONARRAY
    let task = JSONDownloader().getJSONArray(with: request) { _jsonArray, _error in
      DispatchQueue.main.async {
        guard let jsonArray = _jsonArray, _error == nil else {
          completion(nil, _error)
          return
        }
        completion(jsonArray, nil)
      }
    }

    task.resume()
  }

  // JSON Object example
  func getString(completionHandler completion: @escaping StringCompletionHandler) {

    // Set the REST Domain
    guard var restDomain: URL = "http://www.DOMAIN.com/RESTRESOURCE" else {
        completion(nil, .invalidURL)
        return
    }

    // Construct the NSURL with query items
    let newURL = NSURLComponents(string: restDomain.absoluteString)

    // Create the URL Request with our URL
    let request = URLRequest(url: (newURL?.url)!)

    // Download and return the JSONOBJECT
    let task = JSONDownloader().getJSONObject(with: request) { _jsonObject, _error in
      DispatchQueue.main.async {
        guard let jsonObject = _jsonObject, _error == nil else {
          completion(nil, _error)
          return
        }
        completion(jsonObject, nil)
      }
    }

    task.resume()
  }
}
