//
//  WeatherForecastServiceTests.swift
//  WeatherForecastTests
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
@testable import NetworkStubber
@testable import WeatherForecast

final class WeatherForecastServiceTests: QuickSpec {

  override func spec() {
    super.spec()

    beforeEach {
      self.initialSetup()
    }

    specOfFetchDailyForecast()
  }

  private func specOfFetchDailyForecast() {
    describe("fetch daily forecast") {
      var result: WeatherForecastResponse?

      [true, false].forEach { isSuccess in
        context("\(isSuccess ? "success": "failure")") {
          beforeEach {
            result = nil
            self.stubFetchDailyForecast(isSuccess: isSuccess)
            result = try? self.sut.fetchDailyForecast(city: self.city, numberOfDays: self.numberOfDays, degreeUnit: self.unit)
              .toBlocking(timeout: 1)
              .single()
          }

          if isSuccess {
            it("should parse response successfully") {
              self.expectToParseResponseSuccesfully(result)
            }
          } else {
            it("result should be nil") {
              expect(result).to(beNil())
            }
          }
        }
      }
    }
  }

  private func expectToParseResponseSuccesfully(_ result: WeatherForecastResponse?,
                                                _ file: String = #file,
                                                _ line: UInt = #line) {
    guard let result = result else { return fail("empty response", file: file, line: line) }
    expect(result, file: file, line: line) == self.response
  }

  private func stubFetchDailyForecast(isSuccess: Bool) {
    NetworkStubber.shared.stubAPI(
      WeatherForecastAPIService.dailyForecast(parameters),
      responseData: isSuccess ? response.toData() : nil
    )
  }

  private let appID = "appID"
  private let city = "saigon"
  private let numberOfDays = 7
  private let unit = DegreeUnit.metric
  private lazy var parameters = WeatherForecastParameters(
    city: city,
    numberOfDays: numberOfDays,
    appID: appID,
    degreeUnit: unit
  )

  private let response: WeatherForecastResponse = {
    let item = WeatherForecastResponse.WeatherDay(
      date: Date(),
      pressure: 1000,
      humidity: 50,
      temperature: .init(minimum: 20, maximum: 30),
      weather: .init(description: "Sunny day")
    )
    return .init(items: [item])
  }()

  private var sut: DefaultWeatherForecastService!

  private func initialSetup() {
    NetworkStubber.shared.reset()
    sut = DefaultWeatherForecastService(appID: appID)
  }
}
