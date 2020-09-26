//
//  Configurable.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import Foundation

protocol Configurable {}

extension NSObject: Configurable {}

extension Configurable where Self: AnyObject {
  func configure(_ transform: (Self) -> Void) -> Self {
    transform(self)
    return self
  }
}
