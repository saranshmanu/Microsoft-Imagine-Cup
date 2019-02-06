//
//  Constants.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 04/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//


import Foundation

class Constants {
    static var filtersContent = [
        ["Low", "Calorie", "greenGradient", 0],
        ["Without", "Nuts", "greyGradient", 0],
        ["Without", "Eggs", "purpleGradient", 0],
        ["Low", "Sugar", "blueGradient", 0],
        ["Without", "Caffiene", "blackGradient", 0],
        ["Without", "Lactose", "redGradient", 0],
        ["Without", "Soya", "greyGradient", 0],
        ["Pure", "Vegan", "greyGradient", 0]
    ]
    
    static var filtersCategories = [
        ["Food", "Diet", "greenGradient", 0],
        ["Food", "Baby", "greyGradient", 0],
        ["Food", "Gym", "purpleGradient", 0],
        ["Food", "Nutitional", "blueGradient", 0],
        ["Food", "Spicy", "blackGradient", 0],
        ["Drinks", "Sports", "redGradient", 0],
        ["Drinks", "soft", "redGradient", 0]
    ]
}

class filterImagesName {
    static var DietFoodFilter = "DietFoodFilter"
    static var BabyFoodFilter = "BabyFoodFilter"
    static var GymFoodFilter = "GymFoodFilter"
    static var NutitionalFoodFilter = "NutitionalFoodFilter"
    static var SpicyFoodFilter = "SpicyFoodFilter"
    static var SportsDrinkFilter = "SportsDrinkFilter"
    static var SoftDrinksFilter = "SoftDrinksFilter"
    
    static var CalorieFilter = "CalorieFilter"
    static var NutsFilter = "NutsFilter"
    static var EggsFilter = "EggsFilter"
    static var SugarFilter = "SugarFilter"
    static var CaffieneFilter = "CaffieneFilter"
    static var LactoseFilter = "LactoseFilter"
    static var SoyaFilter = "SoyaFilter"
    static var VeganFilter = "VeganFilter"
}

class filtersSelectedBool {
    static var DietFoodFilter = false
    static var BabyFoodFilter = false
    static var GymFoodFilter = false
    static var NutitionalFoodFilter = false
    static var SpicyFoodFilter = false
    static var SportsDrinkFilter = false
    static var SoftDrinksFilter = false
    
    static var CalorieFilter = false
    static var NutsFilter = false
    static var EggsFilter = false
    static var SugarFilter = false
    static var CaffieneFilter = false
    static var LactoseFilter = false
    static var SoyaFilter = false
    static var VeganFilter = false
}

class filtersName {
    static var DietFoodFilter = "DietFoodFilter"
    static var BabyFoodFilter = "BabyFoodFilter"
    static var GymFoodFilter = "GymFoodFilter"
    static var NutitionalFoodFilter = "NutitionalFoodFilter"
    static var SpicyFoodFilter = "SpicyFoodFilter"
    static var SportsDrinkFilter = "SportsDrinkFilter"
    static var SoftDrinksFilter = "SoftDrinksFilter"
    
    static var CalorieFilter = "CalorieFilter"
    static var NutsFilter = "NutsFilter"
    static var EggsFilter = "EggsFilter"
    static var SugarFilter = "SugarFilter"
    static var CaffieneFilter = "CaffieneFilter"
    static var LactoseFilter = "LactoseFilter"
    static var SoyaFilter = "SoyaFilter"
    static var VeganFilter = "VeganFilter"
}

var detectedFood = [foodItem]()

struct foodItem {
    var foodID = ""
    var foodManufacturer = ""
    var foodName = ""
    var foodDescription = ""
    
    var DietFood = false
    var BabyFood = false
    var GymFood = false
    var NutitionalFood = false
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
}

var database = [
    [
        "Code": "A5FltH418ql3W2I",
        "Name": "Dairy Milk Spread",
        "Manufacturer": "FritoLays",
        "Description": "randomText",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutitionalFood": false,
        "SpicyFood": false,
        "SportsDrink": false,
        "SoftDrinks": false,
        "Calorie":false,
        "Nuts":true,
        "Eggs":true,
        "Sugar" :false,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :false
    ],[
        "Code": "1k6Tq75mLBSkDsE",
        "Name": "Fun Foods Mayonnaise",
        "Manufacturer": "FritoLays",
        "Description": "randomText",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutitionalFood": false,
        "SpicyFood": false,
        "SportsDrink": false,
        "SoftDrinks": false,
        "Calorie":false,
        "Nuts":false,
        "Eggs":false,
        "Sugar" :false,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :true
    ],[
        "Code": "FWu9fQ4qvCBoSET",
        "Name": "Mixture",
        "Manufacturer": "FritoLays",
        "Description": "randomText",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutitionalFood": false,
        "SpicyFood": false,
        "SportsDrink": false,
        "SoftDrinks": false,
        "Calorie":false,
        "Nuts":false,
        "Eggs":true,
        "Sugar" :false,
        "Caffiene" :false,
        "Lactose" :true,
        "Soya" :false,
        "Vegan" :true
    ],[
        "Code": "72rQW3BeQIGXcVT",
        "Name": "Haldiram Rasgulla",
        "Manufacturer": "FritoLays",
        "Description": "randomText",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutitionalFood": false,
        "SpicyFood": false,
        "SportsDrink": false,
        "SoftDrinks": false,
        "Calorie":false,
        "Nuts":true,
        "Eggs":true,
        "Sugar" :false,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :false
    ],[
        "Code": "3r5kqxfvsfyRAis",
        "Name": "Haldiram Bhujia Sev",
        "Manufacturer": "FritoLays",
        "Description": "randomText",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutitionalFood": false,
        "SpicyFood": false,
        "SportsDrink": false,
        "SoftDrinks": false,
        "Calorie":false,
        "Nuts":true,
        "Eggs":true,
        "Sugar" :false,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :false
    ]
]
