# NAB development challenge

Hi there, thanks for taking your time to review my exercise and I hope you will enjoy (reviewing) it. Your comments are much appreciated regardless of the result so please help me understand what I should improve in the future.

## 1. Architecture
It's written in MVVM-C using Input/Output approach. It's quite similar to the tranditional version, just that using Input/Output helps us make the responsibilty clearer. 
- **Input**: Receive user interaction events (updating search text...)
- **Output**: Provide all the data for View to visualize (list of weather items, showing loading indicator, error message...)
- **Coordinator**: Handle UI navigation.

## 2. Code structure
### WeatherForecast
This consists of files that being used in the main target.
- **Extensions**: Extend some existing classes/structs such as UIView, Collection...
- **Foundation**: Declare some protocols/base classes that being used accross the app such as Coordinator/BaseCoordinator...
- **App**: Consists of AppDelegate and AppCoordinator which is the app's entry point.
- **Services**: All the API services to interact with BE. Each service is responsible for sending the request to BE and parsing the response or handling failures. 
- **Screens**: Every screen's MVVM components are located in this folder.

### WeatherForecastUnitTests
This contains all unit tests, mock classes and extensions that being used in unit tests such as *WeatherForecastServiceTests*, *MainViewModelTests* or *MockWeatherForecastService*

### WeatherForecastUITests
This contians all component acceptance tests (aka UI tests). 

## 3. Third-party libraries
Below is the list of third-party libraris that I use in the project:
- **RxSwift**: It is this project's backbone to seamlessly manipulate UI events (binding between ViewModel and View) as well API requests/resposnes. By transforming everything to a sequence of events, it not only makes the logic more understandable and concise but also helps us get rid of the old approach like adding target, delegates, closures which we might feel tedious sometimes.
- **RxTest/RxBlocking**: To test RxSwift code.
- **Moya/RxSwift**: To encapsulate API calls in a reactive way by taking advantage of RxSwift.
- **SnapKit**: To write auto-layout code easier.
- **Quick/Nimble**: Those libraries are very famous in Behavior Driven Testing approach, which provide an powerful syntax to write English-friendly tests.
- **OHHTTPStubs/Swift**: To intercept network requests and return the mock data in tests.
- **Shock**: A HTTP mocking frameword to set up mock data in UI test (https://tech.just-eat.com/2019/03/05/shock-better-automation-testing-for-ios/)

## 4. Build project on local
After cloning the repo, please run `pod install` from your terminal then open `WeatherForecast.xcworkspace` and try to build the project using `Xcode 11.3.1`. It should work without any additional steps.

When running UI test, please make sure the hardware keyboard is disconnected (Simulator --> Hardware --> Keyboard --> Toggle off **Connect Hardware Keyboard**).

## 5. Checklist
- [x] Programming language: Swift

- [x] Design app's architecture: MVVM-C 

- [x] UI matches in the attachment 

- [x] Unit tests

- [x] Acceptance tests

- [x] Exception handling

- [ ] Caching handling

- [ ] Accessibility for Disability supports

Thanks and have a nice day a head.
