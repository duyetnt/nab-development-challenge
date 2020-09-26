//
//  MockWeatherForecastService.swift
//  WeatherForecastTests
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import RxSwift
@testable import WeatherForecast

struct FetchDailyForecastParameters: Equatable {
  let city: String
  let numberOfDays: Int
  let unit: DegreeUnit
}

final class MockWeatherForecastService: WeatherForecastService {
  let didFetchDailyForecast = PublishSubject<FetchDailyForecastParameters>()
  var stubbedResult = Single<WeatherForecastResponse>.never()
  func fetchDailyForecast(city: String, numberOfDays: Int, degreeUnit: DegreeUnit) -> Single<WeatherForecastResponse> {
    didFetchDailyForecast.onNext(.init(city: city, numberOfDays: numberOfDays, unit: degreeUnit))
    return stubbedResult
  }
}
