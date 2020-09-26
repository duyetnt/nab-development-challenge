//
//  AppCoorrdinator.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
  private let window: UIWindow
  private let appID: String

  init(window: UIWindow, appID: String) {
    self.window = window
    self.appID = appID
  }

  override func start() {
    let mainCoordinator = MainScreenCoordinator(window: window, appID: appID)
    addChildCoordinator(mainCoordinator)

    mainCoordinator.start()
  }
}
