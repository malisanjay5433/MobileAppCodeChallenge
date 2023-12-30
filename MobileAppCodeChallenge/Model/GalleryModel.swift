//
//  Gallery.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import Foundation
struct GalleryModel: Codable {
    let data: [ImgurGallery]?
    let success: Bool?
    let status: Int?
}
struct ImgurGallery: Codable{
    let id, title: String?
    let imagesCount: Int?
    let images: [Image]
}
struct Image : Codable{
    let id: String
    let title: String?
    let description: String?
    let datetime: Int
    let link: String
}
