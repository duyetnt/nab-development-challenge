//
//  WeatherForecastService.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import Moya
import RxSwift

enum WeatherForecastAPIService: TargetType {
  case dailyForecast(WeatherForecastParameters)

  var baseURL: URL {
    return URL(string: "https://api.openweathermap.org/data/2.5/forecast")!
  }

  var path: String {
    switch self {
    case .dailyForecast: return "/daily"
    }
  }

  var method: Moya.Method {
    switch self {
    case .dailyForecast: return .get
    }
  }

  var sampleData: Data {
    fatalError("Not in use")
  }

  var task: Task {
    switch self {
    case .dailyForecast(let params):
      let parameters: [String: String] = [
        "q": params.city,
        "cnt": String(params.numberOfDays),
        "appid": params.appID,
        "units": params.degreeUnit.rawValue
      ]
      return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
  }

  var headers: [String : String]? {
    return nil
  }
}

// MARK: - Service
protocol WeatherForecastService {
  func fetchForecastInfo(city: String, numberOfDays: Int, degreeUnit: DegreeUnit) -> Single<WeatherForecastResponse>
}

final class DefaultWeatherForecastService {
  private let provider = MoyaProvider<WeatherForecastAPIService>()
  private let appID: String

  init(appID: String) {
    self.appID = appID
  }

  func fetchForecastInfo(city: String, numberOfDays: Int, degreeUnit: DegreeUnit) -> Single<WeatherForecastResponse> {
    let parameters = WeatherForecastParameters(
      city: city,
      numberOfDays: numberOfDays,
      appID: appID,
      degreeUnit: degreeUnit
    )
    return provider.rx.request(.dailyForecast(parameters))
      .map(WeatherForecastResponse.self)
  }
}
