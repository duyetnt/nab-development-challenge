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

  private let searchController = UISearchController(searchResultsController: nil).configure { searchController in
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.obscuresBackgroundDuringPresentation = false
  }

  private let tableView = UITableView().configure { tableView in
    tableView.register(WeatherItemCell.classForCoder(), forCellReuseIdentifier: WeatherItemCell.idenfitier)
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.allowsSelection = false
  }

  private lazy var loadingIncidatorView = UIView(frame: view.bounds).configure { loadingView in
    loadingView.isHidden = true
    loadingView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    loadingView.addSubview(indicator)
    indicator.center = view.center
    indicator.startAnimating()
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
    title = "Weather Forecast"

    view.backgroundColor = .white
    view.addSubviews(tableView, loadingIncidatorView)

    if #available(iOS 11.0, *) {
      navigationItem.hidesSearchBarWhenScrolling = false
      navigationItem.searchController = searchController
    } else {
      tableView.tableHeaderView = searchController.searchBar
    }
    definesPresentationContext = true

    tableView.dataSource = self
  }

  private func setUpConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setUpBinding() {
    // output
    viewModel.output.itemsStream
      .subscribe(onNext: { [weak self] items in
        self?.reload(with: items)
      })
      .disposed(by: disposeBag)

    viewModel.output.errorStream
      .subscribe(onNext: { [weak self] errorMessage in
        self?.displayErrorMessage(errorMessage)
      })
      .disposed(by: disposeBag)

    viewModel.output.isLoadingStream
      .map { !$0 }
      .bind(to: loadingIncidatorView.rx.isHidden)
      .disposed(by: disposeBag)

    // input
    searchController.searchBar.rx.text
      .map { $0 ?? "" }
      .bind(to: viewModel.input.queryStringStream)
      .disposed(by: disposeBag)
  }

  private func reload(with items: [WeatherForecastUIModel]) {
    self.items = items
    tableView.reloadData()
  }

  private func displayErrorMessage(_ message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true)
  }
}

// MARK: - UISearchResultUpdating
extension MainViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) { }
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
