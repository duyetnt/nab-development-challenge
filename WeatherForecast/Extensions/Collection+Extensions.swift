//
//  Array+Extensions.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import Foundation

extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Iterator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
