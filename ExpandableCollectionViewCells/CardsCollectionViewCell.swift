//
//  CardsCollectionViewCell.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 02/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit

struct filterDescription {
    var heading = ""
    var subHeading = ""
}

protocol FilterProtocol: class {
    //protocol definition goes here
    func updatesFilterOption()
}


class CardsCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, Expandable {
    
    weak var delegate: FilterProtocol?
    
    var filters = [
        ["", "", "", 0]
    ]
    var filterType = ""
    
    var totalFilters = 100
    let size = [150]
    
    func autoScroll () {
        let co = filterCollectionView.contentOffset.x
        let no = co + 10
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseInOut, animations: { [weak self]() -> Void in
            self?.filterCollectionView.contentOffset = CGPoint(x: no, y: 0)
        }) { [weak self](finished) -> Void in
            self?.autoScroll()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filters[indexPath.row%filters.count][3] as! Int == 1 {
            filters[indexPath.row%filters.count][3] = 0
        } else {
            filters[indexPath.row%filters.count][3] = 1
        }
        if filterType == "Content" {
            for i in 0...filters.count - 1 {
                if filters[i][3] as! Int == 1 {
                    switch i {
                    case 0: filtersSelectedBool.CalorieFilter = true
                    case 1: filtersSelectedBool.NutsFilter = true
                    case 2: filtersSelectedBool.EggsFilter = true
                    case 3: filtersSelectedBool.SugarFilter = true
                    case 4: filtersSelectedBool.CaffieneFilter = true
                    case 5: filtersSelectedBool.LactoseFilter = true
                    case 6: filtersSelectedBool.SoyaFilter = true
                    case 7: filtersSelectedBool.VeganFilter = true
                    default:
                        continue
                    }
                    
                } else {
                    switch i {
                    case 0: filtersSelectedBool.CalorieFilter = false
                    case 1: filtersSelectedBool.NutsFilter = false
                    case 2: filtersSelectedBool.EggsFilter = false
                    case 3: filtersSelectedBool.SugarFilter = false
                    case 4: filtersSelectedBool.CaffieneFilter = false
                    case 5: filtersSelectedBool.LactoseFilter = false
                    case 6: filtersSelectedBool.SoyaFilter = false
                    case 7: filtersSelectedBool.VeganFilter = false
                    default:
                        continue
                    }
                }
            }
        } else {
            for i in 0...filters.count - 1 {
                if filters[i][3] as! Int == 1 {
                    switch i {
                    case 0: filtersSelectedBool.DietFoodFilter = true
                    case 1: filtersSelectedBool.BabyFoodFilter = true
                    case 2: filtersSelectedBool.GymFoodFilter = true
                    case 3: filtersSelectedBool.NutritionalFoodFilter = true
                    case 4: filtersSelectedBool.SpicyFoodFilter = true
                    case 5: filtersSelectedBool.SportsDrinkFilter = true
                    case 6: filtersSelectedBool.SoftDrinksFilter = true
                    default:
                        continue
                    }
                    
                } else {
                    switch i {
                    case 0: filtersSelectedBool.DietFoodFilter = false
                    case 1: filtersSelectedBool.BabyFoodFilter = false
                    case 2: filtersSelectedBool.GymFoodFilter = false
                    case 3: filtersSelectedBool.NutritionalFoodFilter = false
                    case 4: filtersSelectedBool.SpicyFoodFilter = false
                    case 5: filtersSelectedBool.SportsDrinkFilter = false
                    case 6: filtersSelectedBool.SoftDrinksFilter = false
                    default:
                        continue
                    }
                }
            }
        }
        
//        for i in 0...Constants.filtersCategories.count - 1 {
//            if Constants.filtersCategories[i][3] as! Int == 1 {
//                switch i {
//                    case 0: filtersSelectedBool.DietFoodFilter = true
//                    case 1: filtersSelectedBool.BabyFoodFilter = true
//                    case 2: filtersSelectedBool.GymFoodFilter = true
//                    case 3: filtersSelectedBool.NutitionalFoodFilter = true
//                    case 4: filtersSelectedBool.SpicyFoodFilter = true
//                    case 5: filtersSelectedBool.SportsDrinkFilter = true
//                    case 6: filtersSelectedBool.SoftDrinksFilter = true
//                    default:
//                        continue
//                }
//            } else {
//                switch i {
//                    case 0: filtersSelectedBool.DietFoodFilter = false
//                    case 1: filtersSelectedBool.BabyFoodFilter = false
//                    case 2: filtersSelectedBool.GymFoodFilter = false
//                    case 3: filtersSelectedBool.NutitionalFoodFilter = false
//                    case 4: filtersSelectedBool.SpicyFoodFilter = false
//                    case 5: filtersSelectedBool.SportsDrinkFilter = false
//                    case 6: filtersSelectedBool.SoftDrinksFilter = false
//                    default:
//                        continue
//                }
//            }
//        }
        filterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalFilters
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        cell.alpha = 0.6
//        UIView.animate(withDuration: 0.8) {
//            cell.contentScaleFactor = 1
//            cell.alpha = 1
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "filterCard", for: indexPath) as! FilterCollectionViewCell
        card.filterBackground.layer.borderWidth = 1
        card.filterBackground.layer.cornerRadius = 10
        card.filterBackground.layer.borderColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.4).cgColor
        card.filterHeading.text = (filters[indexPath.row%filters.count][1] as! String).uppercased()
        card.filterSubheading.text = (filters[indexPath.row%filters.count][0] as! String).uppercased()
        if filters[indexPath.row%filters.count][3] as! Int == 0 {
            card.backgroundGradient.image = UIImage.init(named: "whiteGradient")
            card.filterSubheading.setTextColorToGradient(image: UIImage(named: filters[indexPath.row%filters.count][2] as! String)!)
            card.filterHeading.setTextColorToGradient(image: UIImage(named: filters[indexPath.row%filters.count][2] as! String)!)
        } else {
            card.backgroundGradient.image = UIImage.init(named: filters[indexPath.row%filters.count][2] as! String)
            card.filterSubheading.setTextColorToGradient(image: UIImage(named: "whiteGradient")!)
            card.filterHeading.setTextColorToGradient(image: UIImage(named: "whiteGradient")!)
        }
        return card
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: size[indexPath.row%size.count], height: 70)
    }
    
    @IBOutlet weak var cardBackground: UIView!
    @IBOutlet weak var cardHeading: UILabel!
    @IBOutlet weak var cardSubheading: UILabel!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        let midIndexPath = IndexPath(row: totalFilters / 2 , section: 0)
        filterCollectionView.scrollToItem(at: midIndexPath,at: .centeredHorizontally,animated: false)
//        autoScroll()
    }
    
    func setGradientBackground(colorTop:UIColor, colorBottom:UIColor, view:UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    
    private var initialFrame: CGRect?
    private var initialCornerRadius: CGFloat?

    func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect) {
        initialFrame = self.frame
        let currentY = self.frame.origin.y
        let newY: CGFloat
        if currentY < frameOfSelectedCell.origin.y {
            let offset = frameOfSelectedCell.origin.y - currentY
            newY = collectionView.contentOffset.y - offset
        } else {
            let offset = currentY - frameOfSelectedCell.maxY
            newY = collectionView.contentOffset.y + collectionView.frame.height + offset
        }
        self.frame.origin.y = newY
        layoutIfNeeded()
    }
    
    func show() {
        self.frame = initialFrame ?? self.frame
        initialFrame = nil
        layoutIfNeeded()
    }
    
    func expand(in collectionView: UICollectionView) {
        initialFrame = self.frame
        initialCornerRadius = self.contentView.layer.cornerRadius
        self.contentView.layer.cornerRadius = 0
        self.frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        layoutIfNeeded()
    }
    
    func collapse() {
        self.contentView.layer.cornerRadius = initialCornerRadius ?? self.contentView.layer.cornerRadius
        self.frame = initialFrame ?? self.frame
        initialFrame = nil
        initialCornerRadius = nil
        layoutIfNeeded()
    }
}

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
