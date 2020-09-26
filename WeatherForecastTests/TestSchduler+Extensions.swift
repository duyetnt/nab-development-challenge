//
//  TestSchduler+Extensions.swift
//  WeatherForecastTests
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import RxSwift
import RxTest

extension TestScheduler {
  func observe<E>(_ stream: Observable<E>) -> TestableObserver<E> {
    let observer: TestableObserver<E> = createObserver(E.self)
    _ = stream.subscribe(observer)
    return observer
  }
}
