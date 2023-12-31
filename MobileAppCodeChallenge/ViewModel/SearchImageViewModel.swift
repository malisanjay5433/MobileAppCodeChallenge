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
    
    weak var userDelegate: SearchImageViewModelProtocol?
    
    
    var gallery: GalleryModel? {
        didSet {
            self.userDelegate?.reloadData()
        }
    }
    
    @MainActor
    func fetchImages(userQuery: String) {
        Task{
            do {
                let galleryData:GalleryModel = try await ImgurAPI.searchTopImageOfWeek(query: userQuery, sort: "time", window: "week")
                
                guard galleryData.status == 200 else {
                    print("Error: Unexpected HTTP status code \(String(describing: galleryData.status))")
                    return
                }
                self.gallery = galleryData
            } catch {
                print("Error fetching images: \(error.localizedDescription)")
            }
        }
    }
    
}
