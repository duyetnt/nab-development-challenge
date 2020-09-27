//
//  Endpoint.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 27/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

enum Endpoint {
  #if TEST
  static let current = "http://localhost:6789"
  #else
  static let current = "https://api.openweathermap.org/data/2.5"
  #endif
}
