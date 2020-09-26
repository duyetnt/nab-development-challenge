use_frameworks!
platform :ios, '10.0'

def network_stubber_pod
  pod "NetworkStubber", :path => "LocalPods/NetworkStubber"
end

target 'WeatherForecast' do
  # Pods for WeatherForecast
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Moya/RxSwift'

  target 'WeatherForecastTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
    pod 'RxTest'
    pod 'RxBlocking'
    network_stubber_pod
  end

  target 'WeatherForecastUITests' do
    # Pods for testing
  end

end
