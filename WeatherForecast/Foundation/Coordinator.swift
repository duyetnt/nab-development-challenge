//
//  Coordinator.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import RxSwift

protocol Coordinator: Identifiable {}

class BaseCoordinator: Coordinator {
  private var childCoordinators = [String: Coordinator]()

  /// Start presenting a screen
  func start() {
    fatalError("Should be implemented by sub class.")
  }

  func addChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators[type(of: coordinator).idenfitier] = coordinator
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators[type(of: coordinator).idenfitier] = nil
  }
}
