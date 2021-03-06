//
//  CardsVC.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 02/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit

class CardsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewWillAppear(_ animated: Bool) {
        cardsCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    private var hiddenCells:[ProductCollectionViewCell] = []
    private var expandedCell:ProductCollectionViewCell?
    private var filterCell:[CardsCollectionViewCell] = []
    
    private var isStatusBarHidden = false
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 + products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 335, height: 110)
        } else {
            return CGSize(width: 335, height: 474)
        }
    }
    
    func updateCardShadows(card: CardsCollectionViewCell) -> CardsCollectionViewCell {
        let flag = card
        flag.contentView.backgroundColor = .white
        flag.contentView.layer.cornerRadius = 10
        flag.contentView.layer.masksToBounds = true
        flag.layer.masksToBounds = false
        flag.layer.shadowColor = UIColor.black.cgColor
        flag.layer.shadowOpacity = 0.4
        flag.layer.shadowOffset = CGSize(width: 0, height: 0)
        flag.layer.shadowRadius = 20
        return flag
    }
    
    func updateCardHeading(heading: String, subHeading: String, card: CardsCollectionViewCell) -> CardsCollectionViewCell {
        card.cardHeading.text = "Filters"
        card.cardSubheading.text = "Based on Food Category".uppercased()
        return card
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! HeadingCollectionViewCell
        } else if indexPath.row == 1 {
            var card = collectionView.dequeueReusableCell(withReuseIdentifier: "filterChooseCard", for: indexPath) as! CardsCollectionViewCell
            card.filterType = "Category"
            card = updateCardShadows(card: card)
            card = updateCardHeading(heading: "Filters", subHeading: "Based on Food Category", card: card)
            card.reloadInputViews()
            return card
        } else if indexPath.row == 2 {
            var card = collectionView.dequeueReusableCell(withReuseIdentifier: "filterChooseCard", for: indexPath) as! CardsCollectionViewCell
            card.filterType = "Content"
            card = updateCardShadows(card: card)
            card = updateCardHeading(heading: "Filters", subHeading: "Based on Content Type", card: card)
            card.reloadInputViews()
            return card
        } else {
            let card = collectionView.dequeueReusableCell(withReuseIdentifier: "productCard", for: indexPath) as! ProductCollectionViewCell
            let flag = products[indexPath.row - 3]
            card.name.text = flag.foodName as String
            card.desc.text = flag.foodDescription as String
            card.type.text = flag.foodType as String
            card.card.backgroundColor = flag.foodColorTheme
            return card
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.view.frame.width >= 400 {
            return
        }
        if indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2{
            if collectionView.contentOffset.y < 0 ||
                collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.frame.height {
                return
            }
            let dampingRatio: CGFloat = 0.5
            let initialVelocity: CGVector = CGVector.zero
            let springParameters: UISpringTimingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
            let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: springParameters)
            self.view.isUserInteractionEnabled = false
            if let selectedCell = expandedCell {
                isStatusBarHidden = false
                animator.addAnimations {
                    selectedCell.collapse()
                    for cell in self.hiddenCells {
                        cell.show()
                    }
                    for cell in self.filterCell {
                        cell.show()
                    }
                }
                animator.addCompletion { _ in
                    collectionView.isScrollEnabled = true
                    self.expandedCell = nil
                    self.hiddenCells.removeAll()
                }
            } else {
                isStatusBarHidden = true
                collectionView.isScrollEnabled = false
                let selectedCell = collectionView.cellForItem(at: indexPath)! as! ProductCollectionViewCell
                let frameOfSelectedCell = selectedCell.frame
                expandedCell = selectedCell
                hiddenCells = collectionView.visibleCells.map { $0 }.filter {
                    $0 != selectedCell && $0.reuseIdentifier != "filterChooseCard"
                    } as! [ProductCollectionViewCell]
                filterCell = collectionView.visibleCells.map { $0 }.filter {
                    $0.reuseIdentifier == "filterChooseCard"
                    } as! [CardsCollectionViewCell]
                animator.addAnimations {
                    selectedCell.expand(in: collectionView)
                    for cell in self.hiddenCells {
                        cell.hide(in: collectionView, frameOfSelectedCell: frameOfSelectedCell)
                    }
                    for cell in self.filterCell {
                        cell.hide(in: collectionView, frameOfSelectedCell: frameOfSelectedCell)
                    }
                }
            }
            animator.addAnimations {
                self.setNeedsStatusBarAppearanceUpdate()
            }
            animator.addCompletion { _ in
                self.view.isUserInteractionEnabled = true
            }
            animator.startAnimation()
        }
    }
    

    @IBOutlet weak var cardsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.view.frame.width >= 400 {
            let cellWidth: CGFloat = 317
            let numberOfCells = floor(view.frame.size.width / cellWidth)
            let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            return UIEdgeInsetsMake(50, edgeInsets, 0, edgeInsets)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
