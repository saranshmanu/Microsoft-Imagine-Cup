//
//  Extensions.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 08/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import Foundation
import UIKit


extension UILabel {
    func setTextColorToGradient(image: UIImage) {
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: bounds)
        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.textColor = UIColor(patternImage: myGradient!)
    }
}

extension UIImage {
    func averageColor(alpha : CGFloat) -> UIColor {
        let rawImageRef : CGImage = self.cgImage!
        let data : CFData = rawImageRef.dataProvider!.data!
        let rawPixelData  =  CFDataGetBytePtr(data);
        let imageHeight = rawImageRef.height
        let imageWidth  = rawImageRef.width
        let bytesPerRow = rawImageRef.bytesPerRow
        let stride = rawImageRef.bitsPerPixel / 6
        var red = 0
        var green = 0
        var blue  = 0
        for row in 0...imageHeight {
            var rowPtr = rawPixelData! + bytesPerRow * row
            for _ in 0...imageWidth {
                red    += Int(rowPtr[0])
                green  += Int(rowPtr[1])
                blue   += Int(rowPtr[2])
                rowPtr += Int(stride)
            }
        }
        let  f : CGFloat = 1.0 / (255.0 * CGFloat(imageWidth) * CGFloat(imageHeight))
        return UIColor(red: f * CGFloat(red), green: f * CGFloat(green), blue: f * CGFloat(blue) , alpha: alpha)
    }
}
