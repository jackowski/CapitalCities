//
//  VisitorsListViewController.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 25/01/2021.
//

import UIKit

class VisitorsListViewController: UIViewController {
    fileprivate var tableView: UITableView?
    fileprivate let cellReuseIdentifier = "reuseIdentifier"
    
    var viewModel: VisitorsListViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    

    fileprivate func setUpView() {
        self.view.backgroundColor = .white
        
        setUpTableView()
        setUpCloseButton()
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
        
        tableView!.dataSource = self
    }
    
    fileprivate func setUpCloseButton() {
        let closeBarButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(didTapClose(sender:)))
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    @objc func didTapClose(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension VisitorsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        
        return viewModel.visitorListTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = viewModel?.visitorListTitles[indexPath.row]
        
        return cell
    }
}
