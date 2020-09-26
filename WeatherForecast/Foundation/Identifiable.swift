//
//  Identifiable.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

protocol Identifiable {}

extension Identifiable {
  var idenfitier: String {
    return String(reflecting: self)
  }
}
