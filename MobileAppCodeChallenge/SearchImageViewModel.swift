//
//  SearchImageViewModel.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import Foundation
protocol SearchImageViewModelProtocol: AnyObject {
    func reloadData() // Data Binding - PROTOCOL (View and ViewModel Communication)
}
class SearchImageViewModel{
    var images: Gallery? {
        didSet {
            self.userDelegate?.reloadData()
        }
    }
    weak var userDelegate: SearchImageViewModelProtocol?
    
    @MainActor
    func fetchImages(userQuery: String){
        Task{
            do {
                let imageData:Gallery = try await ImgurAPI.searchImages(query: userQuery, sort: "viral", window: "week", page: 1)
                print("JSON : \(imageData)")
                self.images = imageData
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
