//
//  Constants.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 04/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//


import Foundation
import UIKit

class RegisterUser {
    static var Name = ""
    static var Age = 0
    static var Email = ""
    static var Password = ""
}
struct Diseases {
    var id = 0
    var name = ""
}
var DiseaseList = [Diseases]()
var DiseaseListDatabase = [
    "Diabetes (Need to control blood sugar)",
    "Peanut Allergy (They can't eat nuts, need nut-free products)",
    "Celiac Disease (They can't eat Gluten)",
    "Hypoglycemia (They get low blood sugar easily, which is very dangerous)",
    "No specific disease"
]

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

class Ingredient {
    static var Nuts = "Nuts"
    static var Eggs = "Eggs"
    static var Sugar = "Sugar"
    static var Caffiene = "Caffiene"
    static var Lactose = "Lactose"
    static var Soya = "Soya"
    static var Vegan = "Vegan"
}

var products = [Product]()

class _FilterName {
    static var DietFoodFilter = "DietFoodFilter"
    static var BabyFoodFilter = "BabyFoodFilter"
    static var GymFoodFilter = "GymFoodFilter"
    static var NutritionalFoodFilter = "NutritionalFoodFilter"
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

class _FilterImage {
    static var DietFood = "DietFoodFilter"
    static var BabyFood = "BabyFoodFilter"
    static var GymFood = "GymFoodFilter"
    static var NutritionalFood = "NutritionalFoodFilter"
    static var SpicyFood = "SpicyFoodFilter"
    static var SportsDrink = "SportsDrinkFilter"
    static var SoftDrink = "SoftDrinksFilter"
    
    static var Calorie = "CalorieFilter"
    static var Nuts = "NutsFilter"
    static var Eggs = "EggsFilter"
    static var Sugar = "SugarFilter"
    static var Caffiene = "CaffieneFilter"
    static var Lactose = "LactoseFilter"
    static var Soya = "SoyaFilter"
    static var Vegan = "VeganFilter"
}

class _FilterSelected {
    static var Diet = false
    static var Baby = false
    static var Gym = false
    static var Nutritional = false
    static var SpicyFood = false
    static var Sport = false
    static var SoftDrink = false
    
    static var Calorie = false
    static var Nuts = false
    static var Eggs = false
    static var Sugar = false
    static var Caffiene = false
    static var Lactose = false
    static var Soya = false
    static var Vegan = false
}

var base_url = "https://alpha-india.azurewebsites.net/login"
var base_url_signup = "https://alpha-india.azurewebsites.net/signup"

var themeColors = [
    UIColor.init(red: 216/255, green: 52/255, blue: 76/255, alpha: 0.9),
    UIColor.init(red: 216/255, green: 140/255, blue: 52/255, alpha: 0.9),
    UIColor.init(red: 216/255, green: 53/255, blue: 146/255, alpha: 0.9),
    UIColor.init(red: 52/255, green: 126/255, blue: 215/255, alpha: 0.9),
    UIColor.init(red: 54/255, green: 216/255, blue: 131/255, alpha: 0.9),
    UIColor.init(red: 195/255, green: 216/255, blue: 53/255, alpha: 0.9)
]

var database = [
    [
        "Code": "pnzaBVjEYwT9ke7",
        "Name": "Lays Spanish Tomato",
        "Manufacturer": "FritoLays",
        "Description": "",
        "Type": "",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutritionalFood": false,
        "SpicyFood": true,
        "SportsDrink": false,
        "SoftDrinks": false,
        
        
        "Calorie":false,
        "Nuts":true,
        "Eggs":true,
        "Sugar" :false,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :true
    ]
    ,[
        "Code": "2t6jfTanIbQ5qx1",
        "Name": "Kurkure Triangles Mango Achaari",
        "Manufacturer": "FritoLays",
        "Description": "",
        "Type": "",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutritionalFood": false,
        "SpicyFood": true,
        "SportsDrink": false,
        "SoftDrinks": false,
        
        
        "Calorie":false,
        "Nuts":true,
        "Eggs":true,
        "Sugar" :true,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :true
    ],[
        "Code": "JBWaaWhdK01GGdv",
        "Name": "Dairy Milk",
        "Manufacturer": "FritoLays",
        "Description": "",
        "Type": "",
        "DietFood": false,
        "BabyFood": false,
        "GymFood": false,
        "NutritionalFood": false,
        "SpicyFood": false,
        "SportsDrink": false,
        "SoftDrinks": false,
        
        
        "Calorie":false,
        "Nuts":true,
        "Eggs":true,
        "Sugar" :false,
        "Caffiene" :true,
        "Lactose" :false,
        "Soya" :true,
        "Vegan" :true
    ],[
        "Code": "hzCWdIft761lQOG",
        "Name": "Kanji Mix",
        "Manufacturer": "FritoLays",
        "Description": "",
        "Type": "",
        "DietFood": true,
        "BabyFood": true,
        "GymFood": true,
        "NutritionalFood": true,
        "SpicyFood": false,
        "SportsDrink": false,
        "SoftDrinks": false,
        
        
        "Calorie":true,
        "Nuts":false,
        "Eggs":true,
        "Sugar" :true,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :true
    ]
]
