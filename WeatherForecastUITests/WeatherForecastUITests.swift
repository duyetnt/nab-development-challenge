//
//  WeatherForecastUITests.swift
//  WeatherForecastUITests
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import XCTest
import Shock
@testable import AccessIDs
@testable import WeatherForecast

final class WeatherForecastUITests: XCTestCase {

  private var mockServer: MockServer!
  private let timeout = TimeInterval(2)
  private let urlPath = "/forecast/daily"

  override func setUp() {
    super.setUp()

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    mockServer = MockServer(port: 6789, bundle: Bundle(for: type(of: self)))
    mockServer.start()
  }

  override func tearDown() {
    mockServer.stop()
    super.tearDown()
  }

  func testMainScreen() {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()

    let navigationTitle = app.navigationBars.staticTexts["Weather Forecast"]
    expectToSee(navigationTitle)

    let searchBar = app.navigationBars.searchFields.firstMatch
    expectToSee(searchBar)
    XCTAssertEqual(searchBar.placeholderValue, "Enter a place")

    let tableView = app.tables[MainAccessID.tableView.id]
    expectToSee(tableView)

    searchBar.tap()
    searchBar.typeText("aa")
    // search text only has 2 characters, shouldn't fire API request
    expectNotToSee(tableView.tableRows.firstMatch)

    // server error case
    var message = "This is a message from Backend."
    let serverErrorRoute = MockHTTPRoute.simple(
      method: .get,
      urlPath: urlPath,
      code: 404,
      filename: "server_error.json"
    )
    mockServer.setup(route: serverErrorRoute)

    searchBar.typeText("ab")

    var errorAlert = app.alerts.firstMatch
    var errorMessage = errorAlert.staticTexts[message]
    expectToSee(errorMessage)

    var okButton = errorAlert.buttons.firstMatch
    okButton.tap()

    // timeout
    let timeoutRoute = MockHTTPRoute.timeout(method: .get, urlPath: urlPath, timeoutInSeconds: 1)
    mockServer.setup(route: timeoutRoute)

    searchBar.tap()
    searchBar.typeText("c")

    let loadingView = app.otherElements[MainAccessID.loadingView.id]
    expectToSee(loadingView)

    sleep(2)
    expectNotToSee(loadingView)

    message = "Something went wrong. Please try searching with another city!"
    errorAlert = app.alerts.firstMatch
    errorMessage = errorAlert.staticTexts[message]
    expectToSee(errorMessage)

    okButton = errorAlert.buttons.firstMatch
    okButton.tap()

    // success
    let successRoute = MockHTTPRoute.simple(
      method: .get,
      urlPath: urlPath,
      code: 200,
      filename: "success.json"
    )
    mockServer.setup(route: successRoute)

    searchBar.tap()
    searchBar.typeText("d")

    let cell = tableView.cells.firstMatch
    expectToSee(cell)

    let texts = [
      "Date: Sun, 27 Sep 2020",
      "Average temperature: 15°C",
      "Pressure: 1011",
      "Humidity: 67%",
      "Description: overcast clouds"
    ]
    texts.forEach { text in expectToSee(cell.staticTexts[text]) }
  }

  private func expectToSee(_ element: XCUIElement, _ file: StaticString = #file, _ line: UInt = #line) {
    XCTAssertTrue(element.waitForExistence(timeout: timeout), file: file, line: line)
  }

  private func expectNotToSee(_ element: XCUIElement, _ file: StaticString = #file, _ line: UInt = #line) {
    XCTAssertFalse(element.waitForExistence(timeout: timeout), file: file, line: line)
  }
}
