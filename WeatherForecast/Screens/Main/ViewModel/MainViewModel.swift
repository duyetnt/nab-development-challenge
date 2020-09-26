//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import RxSwift
import RxCocoa

struct WeatherForecastUIModel: Equatable {
  let date: String
  let temperature: String
  let pressure: String
  let humidity: String
  let description: String
}

private extension DegreeUnit {
  var display: String {
    switch self {
    case .default: return "K"
    case .metric: return "°C"
    case .imperial: return "°F"
    }
  }
}

private struct UIModelConverter {
  private let dateFormatter: DateFormatter
  private let unit: DegreeUnit

  init(dateFormat: String, unit: DegreeUnit) {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    self.dateFormatter = formatter
    self.unit = unit
  }

  func convert(from model: WeatherForecastResponse.WeatherDay) -> WeatherForecastUIModel {
    let date = "Date: \(dateFormatter.string(from: model.date))"

    let averageTemperature = Int(model.temperature.minimum + model.temperature.maximum) / 2
    let temperature = "Average temperature: \(averageTemperature)\(unit.display)"

    let pressure = "Pressure: \(model.pressure)"
    let humidity = "Humidity: \(model.humidity)%"
    let description = "Description: \(model.weather.description)"
    return .init(date: date, temperature: temperature, pressure: pressure, humidity: humidity, description: description)
  }
}

struct MainViewModelInput {
  let queryStringStream: AnyObserver<String>
}

struct MainViewModelOutput {
  let itemsStream: Observable<[WeatherForecastUIModel]>
  let errorStream: Observable<String>
}

protocol MainViewModel {
  var input: MainViewModelInput { get }
  var output: MainViewModelOutput { get }
}

final class DefaultMainViewModel: MainViewModel {
  enum Constants {
    static let queryStringDebounceInterval = RxTimeInterval.microseconds(500)
    static let dateFormat = "E, dd MMM yyyy"
  }

  let input: MainViewModelInput
  let output: MainViewModelOutput

  private let service: WeatherForecastService
  private let minQueryLength: Int
  private let numberOfDays: Int
  private let unit: DegreeUnit
  private let scheduler: SchedulerType

  private let disposeBag = DisposeBag()

  init(service: WeatherForecastService,
       minQueryLength: Int = 3,
       numberOfDays: Int = 7,
       unit: DegreeUnit = .metric,
       scheduler: SchedulerType = MainScheduler.instance) {
    self.service = service
    self.minQueryLength = minQueryLength
    self.numberOfDays = numberOfDays
    self.unit = unit
    self.scheduler = scheduler

    let queryStringPublish = PublishSubject<String>()
    input = MainViewModelInput(queryStringStream: queryStringPublish.asObserver())

    let itemsRelay = BehaviorRelay<[WeatherForecastUIModel]>(value: [])
    let errorPublish = PublishSubject<String>()
    output = MainViewModelOutput(
      itemsStream: itemsRelay.asObservable(),
      errorStream: errorPublish
    )

    let uiModelConverter = UIModelConverter(dateFormat: Constants.dateFormat, unit: unit)
    queryStringPublish.filter { $0.count >= minQueryLength }
      .debounce(Constants.queryStringDebounceInterval, scheduler: scheduler)
      .flatMapLatest { city -> Single<[WeatherForecastResponse.WeatherDay]> in
        let stream = service.fetchDailyForecast(city: city, numberOfDays: numberOfDays, degreeUnit: unit)
        return stream
          .map { $0.items }
          .do(onSuccess: { items in
            let uiModels = items.map(uiModelConverter.convert(from:))
            itemsRelay.accept(uiModels)
          }, onError: { error in
            NSLog("### fail to fetch daily forecast. \(error)")
            errorPublish.onNext("Something went wrong. Please try searching with another city!")
          })
          .catchErrorJustReturn([])
      }
      .subscribe()
      .disposed(by: disposeBag)
  }
}
