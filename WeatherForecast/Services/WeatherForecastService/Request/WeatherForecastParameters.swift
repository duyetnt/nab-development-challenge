//
//  WeatherForecastParameters.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

enum DegreeUnit: String {
  case `default`
  case metric
  case imperial
}

struct WeatherForecastParameters {
  let city: String
  let numberOfDays: Int
  let appID: String
  let degreeUnit: DegreeUnit
}
