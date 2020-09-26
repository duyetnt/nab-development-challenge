//
//  MainScreenCoordinator.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import RxSwift

final class MainScreenCoordinator: BaseCoordinator {
  private let window: UIWindow
  private let appID: String

  init(window: UIWindow, appID: String) {
    self.window = window
    self.appID = appID
  }

  override func start() {
    let viewController = MainViewController()
    window.rootViewController = UINavigationController(rootViewController: viewController)
    window.makeKeyAndVisible()
  }
}
