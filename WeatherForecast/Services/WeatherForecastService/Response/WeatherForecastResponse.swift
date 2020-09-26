//
//  WeatherForecastResponse.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import Foundation

struct WeatherForecastResponse: Codable, Equatable {
  struct WeatherDay: Codable, Equatable {
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
      case weatherInfoList = "weather"
    }

    private let timeInterval: TimeInterval
    private let weatherInfoList: [WeatherInfo]
    let temperature: Temperature
    let pressure: Int
    let humidity: Int

    var date: Date {
      return Date(timeIntervalSince1970: timeInterval)
    }

    var weather: WeatherInfo {
      return weatherInfoList[0]
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let weatherInfoList = try container.decode([WeatherInfo].self, forKey: .weatherInfoList)
      if weatherInfoList.count != 1 {
        throw DecodingError.dataCorruptedError(
          forKey: .weatherInfoList,
          in: container,
          debugDescription: "Invalid weather info."
        )
      }

      self.weatherInfoList = weatherInfoList
      timeInterval = try container.decode(TimeInterval.self, forKey: .timeInterval)
      temperature = try container.decode(Temperature.self, forKey: .temperature)
      pressure = try container.decode(Int.self, forKey: .pressure)
      humidity = try container.decode(Int.self, forKey: .humidity)
    }

    init(date: Date, pressure: Int, humidity: Int, temperature: Temperature, weather: WeatherInfo) {
      self.timeInterval = date.timeIntervalSince1970
      self.pressure = pressure
      self.humidity = humidity
      self.temperature = temperature
      self.weatherInfoList = [weather]
    }
  }

  enum CodingKeys: String, CodingKey {
    case items = "list"
  }

  let items: [WeatherDay]
}
