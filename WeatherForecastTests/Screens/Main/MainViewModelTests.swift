//
//  MainViewModelTests.swift
//  WeatherForecastTests
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
@testable import WeatherForecast

final class MainViewModelTests: QuickSpec {

  override func spec() {
    super.spec()

    beforeEach {
      self.initialSetup()
    }

    specOfQueryString()
    specOfFetchData()
    specOfLoading()
  }

  private func specOfQueryString() {
    describe("update query string") {
      let minQueryLength = 5
      let validString1 = String(repeating: "a", count: minQueryLength)
      let validString2 = String(repeating: "a", count: minQueryLength + 2)
      let validString3 = String(repeating: "a", count: minQueryLength + 4)
      var fetchDailyForecastObserver: TestableObserver<FetchDailyForecastParameters>!

      beforeEach {
        self.initialSetup(minQueryLength: minQueryLength)

        fetchDailyForecastObserver = self.scheduler.observe(self.service.didFetchDailyForecast)

        self.updateQueryString(
          (text: "a", at: 1), // invalid characters count, will ignore
          (text: "aaa", at: 2),
          (text: validString1, at: 5), // valid, will fire API
          (text: validString2, at: 9), // will be ignored by debounce
          (text: validString3, at: 10), // valid, will fire API
          (text: validString3, at: 15) // duplicate query string, will by ignored by distinctUntilChanged
        )

        self.scheduler.start()
      }

      it("should proceed only when query string has \(minQueryLength) characters or above") {
        expect(fetchDailyForecastObserver.events) == [
          .next(6, .init(city: validString1, numberOfDays: self.numberOfDays, unit: .default)),
          .next(11, .init(city: validString3, numberOfDays: self.numberOfDays, unit: .default)),
        ]
      }
    }
  }

  private func specOfFetchData() {
    describe("fetch data") {
      [DegreeUnit.default, .metric, .imperial].forEach { unit in
        context("unit is \(String(describing: unit))") {
          let city1 = "aaa"
          let city2 = "aaaaa"
          let city3 = "aaaaaaa"
          let serverError = WeatherForecastError(message: "City not found!")

          var fetchDailyForecastObserver: TestableObserver<FetchDailyForecastParameters>!
          var errorObserver: TestableObserver<String>!
          var uiModelsObserver: TestableObserver<[WeatherForecastUIModel]>!
          beforeEach {
            self.initialSetup(unit: unit)

            fetchDailyForecastObserver = self.scheduler.observe(self.service.didFetchDailyForecast)
            errorObserver = self.scheduler.observe(self.sut.output.errorStream)
            uiModelsObserver = self.scheduler.observe(self.sut.output.itemsStream)

            self.service.stubbedResult = .error(TestError.random)
            self.scheduler.scheduleAt(10) {
              self.service.stubbedResult = .just(self.response)
            }
            self.scheduler.scheduleAt(20) {
              self.service.stubbedResult = .error(serverError)
            }

            self.updateQueryString(
              (text: city1, at: 5), // should show error
              (text: city2, at: 15), // should update UI models
              (text: city3, at: 25) // should show server error with message given by BE
            )

            self.scheduler.start()
          }

          it("should call service to fetch data") {
            expect(fetchDailyForecastObserver.events) == [
              .next(6, .init(city: city1, numberOfDays: self.numberOfDays, unit: unit)),
              .next(16, .init(city: city2, numberOfDays: self.numberOfDays, unit: unit)),
              .next(26, .init(city: city3, numberOfDays: self.numberOfDays, unit: unit))
            ]
          }

          it("should update error and response accordingly") {
            expect(errorObserver.events) == [
              .next(6, "Something went wrong. Please try searching with another city!"),
              .next(26, serverError.message)
            ]

            let uiModel: WeatherForecastUIModel
            switch unit {
            case .default: uiModel = self.defaultUIModel
            case .metric: uiModel = self.metricUIModel
            case .imperial: uiModel = self.imperialUIModel
            }
            expect(uiModelsObserver.events) == [.next(0, []), .next(6, []), .next(16, [uiModel]), .next(26, [])]
          }
        }
      }
    }
  }

  private func specOfLoading() {
    describe("loading") {
      let city1 = "aaa"
      let city2 = "aaaaa"

      var isLoadingObserver: TestableObserver<Bool>!
      beforeEach {
        isLoadingObserver = self.scheduler.observe(self.sut.output.isLoadingStream)

        self.service.stubbedResult = Single<WeatherForecastResponse>.error(TestError.random)
        self.scheduler.scheduleAt(10) {
          self.service.stubbedResult = Single<Int>.timer(RxTimeInterval.seconds(2), scheduler: self.scheduler)
            .map { _ in self.response }
        }

        self.updateQueryString(
          (text: city1, at: 5), // should show error
          (text: city2, at: 15) // should update UI models
        )

        self.scheduler.start()
      }

      it("should update isLoadingStream correctly") {
        expect(isLoadingObserver.events) == [.next(6, true), .next(6, false), .next(16, true), .next(18, false)]
      }
    }
  }

  private func updateQueryString(_ items: (text: String, at: Int)...) {
    let events = items.map { Recorded.next($0.at, $0.text) }
    _ = scheduler.createHotObservable(events).bind(to: sut.input.queryStringStream)
  }

  private let date = Date.init(timeIntervalSince1970: 0)
  private let dateString = "Thu, 01 Jan 1970"
  private lazy var response: WeatherForecastResponse = {
    let item = WeatherForecastResponse.WeatherDay(
      date: date,
      pressure: 1000,
      humidity: 50,
      temperature: .init(minimum: 20, maximum: 30),
      weather: .init(description: "Sunny day")
    )
    return .init(items: [item])
  }()

  private lazy var defaultUIModel = WeatherForecastUIModel(
    date: "Date: \(dateString)",
    temperature: "Average temperature: 25K",
    pressure: "Pressure: 1000",
    humidity: "Humidity: 50%",
    description: "Description: Sunny day"
  )

  private lazy var metricUIModel = WeatherForecastUIModel(
    date: "Date: \(dateString)",
    temperature: "Average temperature: 25°C",
    pressure: "Pressure: 1000",
    humidity: "Humidity: 50%",
    description: "Description: Sunny day"
  )

  private lazy var imperialUIModel = WeatherForecastUIModel(
    date: "Date: \(dateString)",
    temperature: "Average temperature: 25°F",
    pressure: "Pressure: 1000",
    humidity: "Humidity: 50%",
    description: "Description: Sunny day"
  )

  private let numberOfDays = 7
  private var service: MockWeatherForecastService!
  private var scheduler: TestScheduler!
  private var sut: DefaultMainViewModel!

  private func initialSetup(minQueryLength: Int = 3, unit: DegreeUnit = .default) {
    service = MockWeatherForecastService()
    scheduler = TestScheduler(initialClock: 0)
    sut = DefaultMainViewModel(
      service: service,
      minQueryLength: minQueryLength,
      unit: unit,
      scheduler: scheduler
    )
  }
}

private enum TestError: Error {
  case random
}
