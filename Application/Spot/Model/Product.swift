//
//  Product.swift
//  Spot
//
//  Created by Saransh Mittal on 08/10/20.
//  Copyright © 2020 dantish. All rights reserved.
//

import UIKit
import Foundation

class Product {
    var foodID = ""
    var foodName = ""
    var foodDescription = ""
    var foodManufacturer = ""
    var foodImage = ""
    var foodColorTheme = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
    var foodType = ""
    var DietFood = false
    var BabyFood = false
    var GymFood = false
    var NutritionalFood = false
    var SpicyFood = false
    var SportsDrink = false
    var SoftDrinks = false
    var Calorie = false
    var Nuts = false
    var Eggs = false
    var Sugar = false
    var Caffiene = false
    var Lactose = false
    var Soya = false
    var Vegan = false
    var warning = false
    
    init(product: NSDictionary) {
        self.foodID = product["Code"] as! String
        self.foodName = product["Name"] as! String
        self.foodDescription = product["Description"] as! String
        self.foodType = product["Type"] as! String
        self.Calorie = product["Calorie"] as! Bool
        self.Nuts = product["Nuts"] as! Bool
        self.Eggs = product["Eggs"] as! Bool
        self.Sugar = product["Sugar"] as! Bool
        self.Caffiene = product["Caffiene"] as! Bool
        self.Lactose = product["Lactose"] as! Bool
        self.Soya = product["Soya"] as! Bool
        self.Vegan = product["Vegan"] as! Bool
        
        self.BabyFood = product["BabyFood"] as! Bool
        self.DietFood = product["DietFood"] as! Bool
        self.NutritionalFood = product["NutritionalFood"] as! Bool
        self.SoftDrinks = product["SoftDrinks"] as! Bool
        self.SportsDrink = product["SportsDrink"] as! Bool
        self.GymFood = product["GymFood"] as! Bool
        self.SpicyFood = product["SpicyFood"] as! Bool
    }
}
