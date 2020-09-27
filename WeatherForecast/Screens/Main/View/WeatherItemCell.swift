//
//  WeatherItemCell.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import UIKit
import SnapKit

final class WeatherItemCell: UITableViewCell {
  private let stackView = UIStackView().configure { stackView in
    stackView.axis = .vertical
    stackView.spacing = 8
  }

  private let dateLabel = UILabel()
  private let temperatureLabel = UILabel()
  private let pressureLabel = UILabel()
  private let humidityLabel = UILabel()
  private let descriptionLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpViews()
    setUpConstraints()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    update(with: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUpViews() {
    contentView.addSubview(stackView)
    stackView.addArrangedSubviews(dateLabel, temperatureLabel, pressureLabel, humidityLabel, descriptionLabel)
  }

  private func setUpConstraints() {
    stackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.top.bottom.equalToSuperview().inset(8)
    }
  }

  func update(with uiModel: WeatherForecastUIModel?) {
    dateLabel.text = uiModel?.date
    temperatureLabel.text = uiModel?.temperature
    pressureLabel.text = uiModel?.pressure
    humidityLabel.text = uiModel?.humidity
    descriptionLabel.text = uiModel?.description
  }
}
