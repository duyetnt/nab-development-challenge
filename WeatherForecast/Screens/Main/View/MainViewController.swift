//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by Duyet Nguyen on 26/9/20.
//  Copyright © 2020 Duyet Nguyen. All rights reserved.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {

  private let tableView = UITableView().configure { tableView in
    tableView.register(WeatherItemCell.classForCoder(), forCellReuseIdentifier: WeatherItemCell.idenfitier)
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.allowsSelection = false
    tableView.backgroundColor = .lightGray
  }

  private let viewModel: MainViewModel
  private var items = [WeatherForecastUIModel]()

  private let disposeBag = DisposeBag()

  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    setUpConstraints()
    setUpBinding()
  }

  private func setUpViews() {
    view.addSubview(tableView)

    tableView.dataSource = self
  }

  private func setUpConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setUpBinding() {
    viewModel.output.itemsStream
      .subscribe(onNext: { [weak self] items in
        self?.reload(with: items)
      })
      .disposed(by: disposeBag)

    // TODO (Duyet): Add search box & bind to query string
    viewModel.input.queryStringStream.onNext("saigon")
  }

  private func reload(with items: [WeatherForecastUIModel]) {
    self.items = items
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseCell = tableView.dequeueReusableCell(withIdentifier: WeatherItemCell.idenfitier, for: indexPath)
    let cell = reuseCell as? WeatherItemCell ?? WeatherItemCell()

    let index = indexPath.row
    cell.update(with: items[safe: index])

    return cell
  }
}
