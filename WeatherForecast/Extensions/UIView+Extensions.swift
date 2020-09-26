//
//  UIView+Extensions.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ subviews: [UIView]) {
    subviews.forEach(addArrangedSubview)
  }

  func addArrangedSubviews(_ subviews: UIView...) {
    subviews.forEach(addArrangedSubview)
  }
}
