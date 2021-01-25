//
//  CitiesListViewController.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 24/01/2021.
//

import UIKit

class CitiesListViewController: UIViewController {
    fileprivate var tableView: UITableView?
    fileprivate let cellReuseIdentifier = "reuseIdentifier"
    fileprivate var activityIndicator: UIActivityIndicatorView?
    var viewModel: CitiesListViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    fileprivate func bindViewModel() {
        viewModel?.citiesViewModelList.bind(listner: { [unowned self] (_) in
            self.tableView?.reloadData()
        })
        
        viewModel?.isDataLoading.bind(listner: { [unowned self] (isLoading) in
            if isLoading {
                activityIndicator?.startAnimating()
            } else {
                activityIndicator?.stopAnimating()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.viewDidAppear()
    }

    fileprivate func setUpView() {
        self.view.backgroundColor = .white
        
        setUpTableView()
        setUpActivityIndicator()
    }
    
    fileprivate func setUpTableView() {
        tableView = UITableView(frame: .zero)
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView!)
        
        tableView!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView!.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView!.tableFooterView = UIView(frame: .zero)
        
        tableView!.delegate = self
        tableView!.dataSource = self
    }
    
    fileprivate func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator!)
        
        activityIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension CitiesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        
        return viewModel.citiesViewModelList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        let cellViewModel: CityItemViewModel = viewModel!.citiesViewModelList.value[indexPath.row]
        cell.textLabel?.text = cellViewModel.title
        cell.accessoryView = cellViewModel.isSavedToFavourites ? UIImageView(image: UIImage(systemName: "star.fill")!) : nil
        return cell
    }
}

extension CitiesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityDetailsViewController = CityDetailsViewController()
        cityDetailsViewController.viewModel = viewModel!.detailsViewModel(index: indexPath.row)
        self.navigationController?.pushViewController(cityDetailsViewController, animated: true)
    }
}
