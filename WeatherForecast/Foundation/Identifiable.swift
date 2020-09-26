//
//  Identifiable.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import UIKit

protocol Identifiable {
  static var idenfitier: String { get }
}

extension Identifiable {
  static var idenfitier: String {
    return String(reflecting: self)
  }
}

extension UITableViewCell: Identifiable {}
