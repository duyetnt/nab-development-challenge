//
//  NetworkStubber.swift
//  NetworkStubber
//
//  Created by Duyet Nguyen on 26/9/20.
//

import Moya
import Alamofire
import OHHTTPStubs

final class NetworkStubber {

  static let shared = NetworkStubber()

  private init() {}

  func reset() {
    HTTPStubs.removeAllStubs()
  }

  func stubAPI<T: TargetType>(_ api: T,
                              httpMethod: HTTPMethod? = nil,
                              statusCode: Int32 = 200,
                              responseHeaders: [String: String]? = nil,
                              responseData: Data? = nil) {
    stubUrl(
      api.fullURLString,
      httpMethod: httpMethod,
      statusCode: statusCode,
      responseHeaders: responseHeaders,
      responseData: responseData
    )
  }

  func stubUrl(_ urlString: String,
               httpMethod: HTTPMethod? = nil,
               statusCode: Int32 = 200,
               responseHeaders: [String: String]? = nil,
               responseData: Data? = nil) {
    guard URL(string: urlString) != nil else { fatalError("Invalid url.") }

    let conditionBlock: (URLRequest) -> Bool = { request in
      guard let requestUrlString = request.url?.absoluteString else {
        return false
      }

      if !requestUrlString.starts(with: urlString) {
        return false
      }

      if let httpMethod = httpMethod, request.httpMethod != httpMethod.rawValue {
        return false
      }

      return true
    }

    stub(condition: conditionBlock) { _ -> HTTPStubsResponse in
      HTTPStubsResponse(data: responseData ?? Data(), statusCode: statusCode, headers: responseHeaders)
    }
  }
}

// MARK: - TargetType
private extension TargetType {
  var fullURLString: String {
    // URL includes parameters
    switch self.task {
    case .requestParameters(let parameters, let parameterEncoding):
      if let encoding = parameterEncoding as? URLEncoding,
        encoding.destination == .queryString || (encoding.destination == .methodDependent && method == .get) {
        let request = URLRequest(url: URL(target: self))
        if let absoluteString = (try? parameterEncoding.encode(request, with: parameters))?.url?.absoluteString {
          return absoluteString
        }
      }
    default:
      break
    }

    return URL(target: self).absoluteString
  }
}
