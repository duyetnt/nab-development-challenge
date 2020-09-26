//
//  WeatherForecastResponse.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import Foundation

struct WeatherForecastResponse: Codable, Equatable {
  struct WeatherForecastItem: Codable, Equatable {
    struct Temperature: Codable, Equatable {
      enum CodingKeys: String, CodingKey {
        case minimum = "min"
        case maximum = "max"
      }

      let minimum: Double
      let maximum: Double
    }

    struct WeatherInfo: Codable, Equatable {
      let description: String
    }

    enum CodingKeys: String, CodingKey {
      case timeInterval = "dt"
      case temperature = "temp"
      case pressure
      case humidity
      case weather
    }

    private let timeInterval: TimeInterval
    let temperature: Temperature
    let pressure: Int
    let humidity: Int
    let weather: WeatherInfo

    var date: Date {
      return Date(timeIntervalSince1970: timeInterval)
    }

    init(date: Date, pressure: Int, humidity: Int, temperature: Temperature, weather: WeatherInfo) {
      self.timeInterval = date.timeIntervalSince1970
      self.pressure = pressure
      self.humidity = humidity
      self.temperature = temperature
      self.weather = weather
    }
  }

  enum CodingKeys: String, CodingKey {
    case items = "list"
  }

  var items: [WeatherForecastItem]
}
