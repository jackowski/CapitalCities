//
//  CityDetailsViewController.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 24/01/2021.
//

import UIKit

class CityDetailsViewController: UIViewController {
    fileprivate var stackView: UIStackView?
    fileprivate var ratingLabel: UILabel?
    fileprivate var visitorsButton: UIButton?
    fileprivate var favouriteButton: UIButton?
    fileprivate var activityIndicator: UIActivityIndicatorView?
    
    var viewModel: CityDetailsViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    fileprivate func bindViewModel() {
        viewModel?.isDataLoading.bind(listner: { [unowned self] (isLoading) in
            if isLoading {
                activityIndicator?.startAnimating()
            } else {
                activityIndicator?.stopAnimating()
            }
        })
        
        viewModel?.ratingText.bind(listner: { [unowned self] (ratingText) in
            self.ratingLabel?.text = ratingText
        })
        
        viewModel?.visitorsText.bind(listner: { [unowned self] (visitorsText) in
            self.visitorsButton?.setTitle(visitorsText, for: .normal)
        })
        
        viewModel?.favouriteButtonTitle.bind(listner: { [unowned self] (favouriteButtonTitle) in
            self.favouriteButton?.setTitle(favouriteButtonTitle, for: .normal)
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        title = viewModel?.navigationTitle
        favouriteButton?.setTitle(viewModel?.favouriteButtonTitle.value, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.viewDidAppear()
    }
    
    fileprivate func setUpView() {
        self.view.backgroundColor = .white
        
        setUpContentStackView()
        setUpActivityIndicator()
    }
    
    fileprivate func setUpContentStackView() {
        ratingLabel = UILabel(frame: .zero)
        ratingLabel!.textAlignment = .center
        ratingLabel!.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel!.heightAnchor.constraint(equalToConstant: 40).isActive = true

        visitorsButton = UIButton(type: .roundedRect)
        visitorsButton!.translatesAutoresizingMaskIntoConstraints = false
        visitorsButton!.heightAnchor.constraint(equalToConstant: 40).isActive = true
        visitorsButton!.addTarget(self, action: #selector(didTapVisitorsButton(_ :)), for: .touchUpInside)
        
        favouriteButton = UIButton(type: .roundedRect)
        favouriteButton!.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton!.heightAnchor.constraint(equalToConstant: 40).isActive = true
        favouriteButton!.addTarget(self, action: #selector(didTapFavouriteButton(_ :)), for: .touchUpInside)
        
        stackView = UIStackView(arrangedSubviews: [ratingLabel!, visitorsButton!, favouriteButton!])
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = .vertical
        stackView!.distribution = .equalSpacing
        stackView!.spacing = 20
        view.addSubview(stackView!)
        stackView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    fileprivate func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator!)
        
        activityIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func didTapVisitorsButton(_ sender: UIButton) {
        
    }
    
    @objc func didTapFavouriteButton(_ sender: UIButton) {
        viewModel?.didTapSaveToFavouritesButton()
    }
}
