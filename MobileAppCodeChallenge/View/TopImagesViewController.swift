//
//  ViewController.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import UIKit

class TopImagesViewController: UIViewController {
    private let viewModel = SearchImageViewModel()
    @IBOutlet weak var tableView: UITableView!
    var gallery: GalleryModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        viewModel.userDelegate = self
        viewModel.fetchImages(userQuery: "dogs")
        self.tableView.register(UINib(nibName: "ImgurGalleryTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
    }
}

extension TopImagesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
