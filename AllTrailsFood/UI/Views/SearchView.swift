//
//  SearchView.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/18/21.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func filterButtonTapped()
    func searchTextChanged(_ text: String)
}

final class SearchView: UIView {
    enum Constant {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 5
    }

    private let filterButton: UIButton = UIButton(type: .system)
    private let searchBar: UISearchBar = .init()
    private var isTesting3: Bool = false // third commit

    weak var delegate: SearchViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        filterButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.heightAnchor.constraint(equalToConstant: 35),
            filterButton.widthAnchor.constraint(equalToConstant: 60.0),
            filterButton.leftAnchor.constraint(equalTo: leftAnchor, constant: Constant.horizontalPadding),
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        filterButton.setTitle("Filter", for: .normal)
        filterButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.cornerRadius = 10
        filterButton.layer.borderColor = UIColor.lightGray.cgColor

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 44.0),
            searchBar.leftAnchor.constraint(equalTo: filterButton.rightAnchor, constant: 0),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constant.horizontalPadding),
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        searchBar.barTintColor = .white
        searchBar.placeholder = "Search for a restaurant"
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
    }

    @objc private func buttonTapped() {
        delegate?.filterButtonTapped()
    }
}

extension SearchView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchTextChanged(searchText)
    }
}
