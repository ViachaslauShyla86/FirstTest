//
//  MainTabBarController.swift
//  WeeklySwift
//
//  Created by Viachaslau on 12/5/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let photosVC = PhotosCollectionViewController()
        
        setViewControllers([
            generateNavigationVC(rootVC: photosVC, tabTarItemStyle: .history),
            generateNavigationVC(rootVC: ViewController(), tabTarItemStyle: .favorites)
        ], animated: true)
    }
    
    func generateNavigationVC(rootVC: UIViewController, tabTarItemStyle: UITabBarItem.SystemItem) -> UIViewController {
        let navVC = UINavigationController(rootViewController: rootVC)
        let tabBarItem = UITabBarItem(tabBarSystemItem: tabTarItemStyle, tag: 0)
        rootVC.tabBarItem = tabBarItem
        return navVC
    }
}
