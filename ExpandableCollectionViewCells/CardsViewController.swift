//
//  CardsViewController.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 02/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var hiddenCells:[ProductCollectionViewCell] = []
    private var expandedCell:ProductCollectionViewCell?
    private var filterCell:[CardsCollectionViewCell] = []
    
    private var isStatusBarHidden = false
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let card = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! ProductCollectionViewCell
            return card
        } else if indexPath.row == 1 {
            let card = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "filterChooseCard", for: indexPath) as! CardsCollectionViewCell
            card.contentView.backgroundColor = .white
            card.contentView.layer.cornerRadius = 10
            card.contentView.layer.masksToBounds = true
            card.layer.masksToBounds = false
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.4
            card.layer.shadowOffset = CGSize(width: 0, height: 0)
            card.layer.shadowRadius = 20
            return card
        } else {
            let card = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath)
            return card
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 && indexPath.row != 1{
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
}
