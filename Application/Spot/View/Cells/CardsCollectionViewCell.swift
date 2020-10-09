//
//  CardsCollectionViewCell.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 02/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, Expandable {
    
    var filterType = ""
    var totalFilters = 100
    let size = [150]
    
    override func reloadInputViews() {
        reloadTheFilters()
    }
    
    func autoScroll () {
        let co = filterCollectionView.contentOffset.x
        let no = co + 10
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: { [weak self]() -> Void in
            self?.filterCollectionView.contentOffset = CGPoint(x: no, y: 0)
        }) { [weak self](finished) -> Void in
            self?.autoScroll()
        }
    }
    
    func updateSelectedFilters(status: Bool, i: Int) {
        if filterType == "Content" {
            switch i {
                case 0: _FilterSelected.Calorie = status
                case 1: _FilterSelected.Nuts = status
                case 2: _FilterSelected.Eggs = status
                case 3: _FilterSelected.Sugar = status
                case 4: _FilterSelected.Caffiene = status
                case 5: _FilterSelected.Lactose = status
                case 6: _FilterSelected.Soya = status
                case 7: _FilterSelected.Vegan = status
                default: return
            }
        } else {
            switch i {
                case 0: _FilterSelected.Diet = status
                case 1: _FilterSelected.Baby = status
                case 2: _FilterSelected.Gym = status
                case 3: _FilterSelected.Nutritional = status
                case 4: _FilterSelected.SpicyFood = status
                case 5: _FilterSelected.Sport = status
                case 6: _FilterSelected.SoftDrink = status
                default: return
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filterType == "Content" {
            if Constants.filtersContent[indexPath.row%Constants.filtersContent.count][3] as! Int == 1 {
                Constants.filtersContent[indexPath.row%Constants.filtersContent.count][3] = 0
            } else {
                Constants.filtersContent[indexPath.row%Constants.filtersContent.count][3] = 1
            }
            for i in 0...Constants.filtersContent.count - 1 {
                if Constants.filtersContent[i][3] as! Int == 1 {
                    updateSelectedFilters(status: true, i: i)
                } else {
                    updateSelectedFilters(status: false, i: i)
                }
            }
        } else {
            if Constants.filtersCategories[indexPath.row%Constants.filtersCategories.count][3] as! Int == 1 {
                Constants.filtersCategories[indexPath.row%Constants.filtersCategories.count][3] = 0
            } else {
                Constants.filtersCategories[indexPath.row%Constants.filtersCategories.count][3] = 1
            }
            for i in 0...Constants.filtersCategories.count - 1 {
                if Constants.filtersCategories[i][3] as! Int == 1 {
                    updateSelectedFilters(status: true, i: i)
                } else {
                    updateSelectedFilters(status: false, i: i)
                }
            }
        }
        reloadTheFilters()
    }
    
    func reloadTheFilters() {
        filterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalFilters
    }
    
    func updateCard(card: FilterCollectionViewCell, totalFilters: Int, indexPath: Int, flag: [NSArray]) -> FilterCollectionViewCell{
        card.heading.text = (flag[indexPath%totalFilters][1] as! String).uppercased()
        card.subheading.text = (flag[indexPath%totalFilters][0] as! String).uppercased()
        if flag[indexPath%totalFilters][3] as! Int == 0 {
            card.gradient.image = UIImage.init(named: "whiteGradient")
            card.subheading.setTextColorToGradient(image: UIImage(named: flag[indexPath%totalFilters][2] as! String)!)
            card.heading.setTextColorToGradient(image: UIImage(named: flag[indexPath%totalFilters][2] as! String)!)
        } else {
            card.gradient.image = UIImage.init(named: flag[indexPath%totalFilters][2] as! String)
            card.subheading.setTextColorToGradient(image: UIImage(named: "whiteGradient")!)
            card.heading.setTextColorToGradient(image: UIImage(named: "whiteGradient")!)
        }
        return card
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "filterCard", for: indexPath) as! FilterCollectionViewCell
        card.background.layer.borderWidth = 1
        card.background.layer.cornerRadius = 10
        card.background.layer.borderColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.4).cgColor
        if filterType == "Content" {
            let flag = Constants.filtersContent
            return updateCard(card: card, totalFilters: flag.count, indexPath: indexPath.row, flag: flag as [NSArray])
        } else {
            let flag = Constants.filtersCategories
            return updateCard(card: card, totalFilters: flag.count, indexPath: indexPath.row, flag: flag as [NSArray])
        }
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
