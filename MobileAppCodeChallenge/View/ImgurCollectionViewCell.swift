//
//  TestCollectionViewCell.swift
//  Test
//
//  Created by Sanjay Mali on 31/12/23.
//

import UIKit
import SDWebImage
protocol ImgurImageFormatter {
    func format(date: Int) -> String
}

class DefaultImgurImageFormatter: ImgurImageFormatter {
    func format(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
        return dateFormatter.string(from: date)
    }
}

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgurImageView: UIImageView!
    @IBOutlet weak var imageCountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    private var imgurImageFormatter: ImgurImageFormatter!
    private let formatter: ImgurImageFormatter = DefaultImgurImageFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var imgurGalleryData: ImgurGallery? {
        didSet {
            guard let imgurGalleryData = imgurGalleryData else {return}
            self.titleLbl.text = imgurGalleryData.title
            
            guard let datetime = imgurGalleryData.datetime  else { return }
            self.dateLbl.text = formatter.format(date: datetime)
            
            guard let imagesCount = imgurGalleryData.images_count else {return}
            self.imageCountLbl.text = "\(imagesCount)"
        }
    }
    
    var imageData: Image? {
        didSet {
            guard let imageData = imageData else { return }
            if isImageType(imageData.type) {
                loadImageFromURL(imageData.link)
            }
        }
    }
    
    private func isImageType(_ type: String?) -> Bool {
        return type == "image/jpeg" || type == "image/jpg"
    }
    
    private func loadImageFromURL(_ urlString: String) {
        print("URL STRING : \(urlString)")
        imgurImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeholder"))
    }
}
