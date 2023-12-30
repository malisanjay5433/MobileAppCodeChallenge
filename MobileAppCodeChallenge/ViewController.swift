//
//  ViewController.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import UIKit

class ViewController: UIViewController {
    private let viewModel = SearchImageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.userDelegate = self
        viewModel.fetchImages(userQuery: "dogs")
    }
}

extension ViewController : SearchImageViewModelProtocol{
    func reloadData() {
        print("featch images")
    }
}
