//
//  WeatherForecastServiceFactory.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

enum WeatherForecastSeviceFactory {
  static func makeService(appID: String) -> WeatherForecastService {
    return DefaultWeatherForecastService(appID: appID)
  }
}
