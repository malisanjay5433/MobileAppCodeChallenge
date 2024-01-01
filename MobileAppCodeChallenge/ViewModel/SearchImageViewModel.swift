//
//  SearchImageViewModel.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import Foundation

// Protocol to notify the user interface about changes in the view model.
protocol SearchImageViewModelProtocol: AnyObject {
    func reloadData()
}

// View model responsible for handling the logic related to searching and fetching images.
final class SearchImageViewModel {
    
    // Delegate to notify the user interface.
    weak var userDelegate: SearchImageViewModelProtocol?
    
    // Represents the gallery model containing image data.
    var gallery: GalleryModel? {
        didSet {
            // Notify the user interface about data changes.
            self.userDelegate?.reloadData()
        }
    }
    
    // Fetches images based on the user query using async/await.
    @MainActor
    func fetchImages(userQuery: String) {
        Task {
            do {
                // Attempt to fetch gallery data asynchronously.
                let galleryData: GalleryModel = try await NetworkManager.request(query: userQuery, sort: "time", window: "week")
                // Handle the response from the Imgur API.
                handleGalleryResponse(galleryData)
                print(galleryData.data ?? "")
            } catch {
                // Handle any errors that occurred during the fetch.
                handleError(error)
            }
        }
    }
    
    // Handles the response from the Imgur API.
    private func handleGalleryResponse(_ galleryData: GalleryModel) {
        // Check if the HTTP status code is as expected.
        guard galleryData.status == 200 else {
            print("Error: Unexpected HTTP status code \(galleryData.status ?? -1)")
            return
        }
        // Update the gallery property with the fetched data.
        self.gallery = galleryData
    }
    
    // Handles errors that may occur during the fetch operation.
    private func handleError(_ error: Error) {
        if let imgurError = error as? ImgurAPIError {
            print("Imgur API Error: \(imgurError.localizedDescription), Code: \(error)")
        } else {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
}
