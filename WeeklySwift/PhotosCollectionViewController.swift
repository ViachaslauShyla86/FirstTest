//
//  PhotosCollectionViewController.swift
//  WeeklySwift
//
//  Created by Viachaslau on 12/5/20.
//

import UIKit

class PhotosCollectionViewController: UIViewController {
    private struct Constants {
        static let cellId = "cellId"
        static let titleBar = "PHOTOS"
    }
    
    private var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    private var networkDataFetcher = NetworkDataFetcher()
    private var photos = [UnspashPhoto]()
    private var selectedImages = [UIImage]()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionsInsert = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        updateNavBarState()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.searchBar(self.searchBar, textDidChange: "red")
        }
    }
    
    var numberOfSelectedPhoto: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    func updateNavBarState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhoto > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhoto > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
    }
    
    //MARK: - NavigationActions
    
    @objc private func addBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func actionBarButtonTapped(_ sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController, animated: true, completion: nil)
    }
    
    //MARK: - SetupUIElements
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = Constants.titleBar
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        
        collectionView.backgroundColor = .orange
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        searchBar.delegate = self
        
        
//        let searchVC = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchVC
//        searchVC.hidesNavigationBarDuringPresentation = false
//        searchVC.obscuresBackgroundDuringPresentation = false
//        searchVC.searchBar.delegate = self
    }
}

//MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell
        let unsplashPhoto = photos[indexPath.row]
        cell?.unsplashPhoto = unsplashPhoto
        cell?.backgroundColor = .red
        
        return cell!
    }
}

//MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        guard let image = cell?.photoImageView.image else { return }
        selectedImages.append(image)
        updateNavBarState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        guard let image = cell?.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(where: { $0 == image }) {
            selectedImages.remove(at: index)
            updateNavBarState()
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.row]
        let paddingSpace = sectionsInsert.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInsert
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionsInsert.left
    }
    
    
}

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] searchResults in
            guard let fetchResult = searchResults else {
                return
            }
            
            self?.photos = fetchResult.results
            self?.collectionView.reloadData()
        }
    }
}
