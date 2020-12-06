//
//  ViewController.swift
//  WeeklySwift
//
//  Created by Viachaslau on 12/5/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchVC = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchVC
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.barStyle = .default
    }


}

