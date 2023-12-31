//
//  ViewController.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import UIKit

class TopImagesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var viewModel: SearchImageViewModel!
    private var debouncer: Debouncer?
    
    var gallery: GalleryModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SearchImageViewModel()
        self.viewModel.userDelegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        self.tableView.register(UINib(nibName: "ImgurGalleryTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        // Initialize debouncer only once
        debouncer = Debouncer(delay: 0.5) { [weak self] in
            guard let query = self?.searchBar.text?.lowercased() else { return }
            self?.viewModel.fetchImages(userQuery: query)
        }
    }
}

extension TopImagesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ViewMODEL COUNT : \(viewModel.gallery?.data?.count ?? 0)")
        return viewModel.gallery?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ImgurGalleryTableViewCell
        cell?.imgurGalleryData = viewModel.gallery?.data?[indexPath.row]
        cell?.imageData = viewModel.gallery?.data?[indexPath.row].images[0]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
extension TopImagesViewController : SearchImageViewModelProtocol{
    func reloadData() {
        print("featch images")
        self.tableView.reloadData()
    }
}

extension TopImagesViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer?.call()
    }
}

