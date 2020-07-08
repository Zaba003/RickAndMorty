//
//  CharacterTableViewController.swift
//  RickAndMorty
//
//  Created by Кирилл Заборский on 07.07.2020.
//  Copyright © 2020 Кирилл Заборский. All rights reserved.
//

import UIKit

class CharacterTableViewController: UITableViewController {
    
    //MARK: Private properties
    private var character: Character?
    private let urlString = "https://rickandmortyapi.com/api/character"
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredChracter: [Result] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchController()
        
        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        NetworkManager.shared.fetchData(from: urlString) { character in
            DispatchQueue.main.async {
                self.character = character
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Add refreshControll
    @IBAction func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredChracter.count : character?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterName", for: indexPath) as! TableViewCell
        
        let result = isFiltering ? filteredChracter[indexPath.row] : character?.results[indexPath.row]
        cell.configure(with: result)
        
        return cell
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let person = isFiltering ? filteredChracter[indexPath.row] : character?.results[indexPath.row]
        let detailVC = segue.destination as! DetailsViewController
        detailVC.character = person
    }
    
    // MARK: - Private methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    
    // Setup navigation bar
    private func setupNavigationBar() {
        
        title = "Rick & Morty TestApp"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = .black
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
    }
}

// MARK: - UISearchResultsUpdating
extension CharacterTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredChracter = character?.results.filter { character in
            character.name.lowercased().contains(searchText.lowercased())
            } ?? []
        
        tableView.reloadData()
    }
}
