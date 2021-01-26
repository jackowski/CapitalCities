//
//  CityTableViewCell.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 26/01/2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    let titleLabel: UILabel = UILabel()
    let photoImageView: UIImageView = UIImageView()
    let favouritesImageView: UIImageView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
    }
    
    fileprivate func setUpView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        favouritesImageView.translatesAutoresizingMaskIntoConstraints = false
        favouritesImageView.contentMode = .scaleAspectFit
        favouritesImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favouritesImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [photoImageView, titleLabel, favouritesImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        contentView.addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
