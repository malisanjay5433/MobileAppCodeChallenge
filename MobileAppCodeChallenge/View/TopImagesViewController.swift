//
//  ViewController.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import UIKit

class TopImagesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var viewModel: SearchImageViewModel!
    private var debouncer: Debouncer?
    var toggleButton: UIBarButtonItem!
    var isGridMode: Bool = false
    private var emptyStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupSearchBar()
        configureCollectionView()
        setupDebouncer()
        setupEmptyStateLabel()
        updateEmptyState()
    }
    private func setupEmptyStateLabel() {
        emptyStateLabel = UILabel()
        emptyStateLabel.text = "No search results found..."
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
        
        // Add constraints to center the label in the view
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel = SearchImageViewModel()
        viewModel.userDelegate = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        toggleButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(toggleViewMode))
        navigationItem.rightBarButtonItem = toggleButton
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "ImgurCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        updateViewMode()
    }
    
    private func setupDebouncer() {
        debouncer = Debouncer(delay: 0.5) { [weak self] in
            guard let searchText = self?.searchBar.text?.lowercased(), !searchText.isEmpty, searchText.count > 3 else {
                return
            }
            self?.viewModel.fetchImages(userQuery: searchText)
        }
    }
    
    
}

extension TopImagesViewController: SearchImageViewModelProtocol {
    func reloadData() {
        collectionView.reloadData()
        updateEmptyState()
    }
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !(viewModel.gallery?.data?.isEmpty ?? true)
    }
}
extension TopImagesViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer?.call()
    }
}

extension TopImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @objc func toggleViewMode() {
        isGridMode = !isGridMode
        updateViewMode()
    }
    
    func updateViewMode() {
        toggleButton.title = isGridMode ? "List" : "Grid"
        let layout = isGridMode ? createGridLayout() : createListLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let itemSize = CGSize(width: (collectionView.frame.width - 32) / 2, height: 180)
        layout.itemSize = itemSize
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        let itemSize = CGSize(width: collectionView.frame.width - 16, height: 180)
        layout.itemSize = itemSize
        return layout
    }
    
    // MARK: UICollectionViewDataSource and UICollectionViewDelegate methods...
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gallery?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImgurCollectionViewCell
        
        // Configure the cell with data based on your model
        cell.imgurGalleryData = viewModel.gallery?.data?[indexPath.row]
        cell.imageData = viewModel.gallery?.data?[indexPath.row].images[0]
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
}
