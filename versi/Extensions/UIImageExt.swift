//
//  UIImageExt.swift
//  UAE Info
//
//  Created by sHiKoOo on 12/16/20.
//  Copyright © 2020 Ashraf Essam. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func downsampleImageForURL(imageLink: URL) {
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: imageLink,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                //             .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        self.image = value.image
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        self.image = UIImage(named: "notFound")
                    }
                })
    }
    
    
    
    
}



extension UIImage {
    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
