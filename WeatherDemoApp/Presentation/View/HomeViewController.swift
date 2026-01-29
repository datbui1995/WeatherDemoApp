//
//  HomeViewController.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel: HomeViewModel
    private var cities: [City] = [] // This will keep the separation between cities in ViewController and ViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Self.className, bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindSearchBar()
        bindViewModel()
    }
    
    private func bindSearchBar() {
        searchTextField.textPublisher
            .sink { [weak self] text in
                self?.viewModel.updateSearchText(text)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            CityCell.self,
            forCellReuseIdentifier: CityCell.reuseIdentifier
        )
    }
    
    private func bindViewModel() {
        viewModel.citiesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] cities in
                self?.reloadUI(cities: cities)
            }
            .store(in: &cancellables)
    }
    
}
extension HomeViewController {
    func reloadUI(cities: [City]) {
        self.cities = cities
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: CityCell.reuseIdentifier,
                                                  for: indexPath ) as! CityCell
        cell.configure(with: cities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        viewModel.didSelect(city: city)
    }
}
