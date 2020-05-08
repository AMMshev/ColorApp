//
//  ColorListViewController.swift
//  CourseProject
//
//  Created by Artem Manyshev on 27.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ColorListViewController: UIViewController {
    
    private var cellID = "colorCell"
    private var colors: [ColorList] = []
    private var filteredColors: [ColorList] = []
    private var tableView: UITableView?
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    private var color = ColorModel(name: "", r: 0, g: 0, b: 0, hex: "")
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let colorsFromFile = ColorsFromFileData.shared.takeColorsFromFile() else { return }
        colors = colorsFromFile
        setupTableView()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "Color")
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "Color")]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        guard let tableView = tableView else { return }
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchController() {
        navigationController?.navigationBar.isHidden = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
                let destinationVC = segue.destination as? DetailColorViewController
            destinationVC?.color = self.color
        }
    }
}

// MARK: -UITableViewDelegate, UITableViewDataSouce

extension ColorListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredColors.count : colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? TableViewCell else { fatalError() }
        let cellData = isFiltering ? filteredColors[indexPath.row] : colors[indexPath.row]
        cell.colorName.text = cellData.name
        if  cellData.rgb.r < 125 &&
            cellData.rgb.r < 125 &&
            cellData.rgb.r < 125 {
            cell.colorName.textColor = .white
        } else {
            cell.colorName.textColor = .black
        }
        cell.backgroundColor = UIColor(red: cellData.rgb.r,
                                       green: cellData.rgb.g,
                                       blue: cellData.rgb.b, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCellColorData = isFiltering ? filteredColors[indexPath.row] : colors[indexPath.row]
        color.name = selectedCellColorData.name
        color.r = selectedCellColorData.rgb.r
        color.g = selectedCellColorData.rgb.g
        color.b = selectedCellColorData.rgb.b
        color.hex = selectedCellColorData.hex
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}

// MARK: -UISearchResultsUpdating

extension ColorListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterColorsForSearch(searchController.searchBar.text ?? "")
    }
    
    private func filterColorsForSearch(_ searchText: String) {
        filteredColors = colors.filter({$0.name.lowercased().contains(searchText.lowercased())})
        tableView?.reloadData()
    }
}
