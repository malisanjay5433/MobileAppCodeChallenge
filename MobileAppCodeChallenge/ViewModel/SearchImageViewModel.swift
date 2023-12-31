//
//  SearchImageViewModel.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import Foundation

protocol SearchImageViewModelProtocol: AnyObject {
    func reloadData()
}

final class SearchImageViewModel {
    
    weak var userDelegate: SearchImageViewModelProtocol?
    
    var gallery: GalleryModel? {
        didSet {
            self.userDelegate?.reloadData()
        }
    }
    
    @MainActor
    func fetchImages(userQuery: String) {
        Task {
            do {
                let galleryData: GalleryModel = try await ImgurAPI.searchTopImageOfWeek(query: userQuery, sort: "time", window: "week")
                handleGalleryResponse(galleryData)
                print(galleryData.data ?? "")
            } catch {
                handleError(error)
            }
        }
    }
    
    private func handleGalleryResponse(_ galleryData: GalleryModel) {
        guard galleryData.status == 200 else {
            print("Error: Unexpected HTTP status code \(galleryData.status ?? -1)")
            return
        }
        self.gallery = galleryData
    }
    
    private func handleError(_ error: Error) {
        print("Error fetching images: \(error.localizedDescription)")
    }
}
