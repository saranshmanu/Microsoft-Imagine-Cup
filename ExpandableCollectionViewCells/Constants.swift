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
var DiseaseListDatabase = ["Diabetes (Need to control blood sugar)", "Peanut Allergy (They can't eat nuts, need nut-free products)", "Celiac Disease (They can't eat Gluten)", "Hypoglycemia (They get low blood sugar easily, which is very dangerous)", "No specific disease"]

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

class filterImagesName {
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

class filtersSelectedBool {
    static var DietFoodFilter = false
    static var BabyFoodFilter = false
    static var GymFoodFilter = false
    static var NutritionalFoodFilter = false
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

var base_url = "https://alpha-india.azurewebsites.net/login"
var base_url_signup = "https://alpha-india.azurewebsites.net/signup"

class filtersName {
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

var detectedFood = [foodItem]()

var themeColors = [
    UIColor.init(red: 216/255, green: 52/255, blue: 76/255, alpha: 0.9),
    UIColor.init(red: 216/255, green: 140/255, blue: 52/255, alpha: 0.9),
    UIColor.init(red: 216/255, green: 53/255, blue: 146/255, alpha: 0.9),
    UIColor.init(red: 52/255, green: 126/255, blue: 215/255, alpha: 0.9),
    UIColor.init(red: 54/255, green: 216/255, blue: 131/255, alpha: 0.9),
    UIColor.init(red: 195/255, green: 216/255, blue: 53/255, alpha: 0.9)
]

struct foodItem {
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
}

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
        "Nuts":false,
        "Eggs":false,
        "Sugar" :false,
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
        "Caffiene" :false,
        "Lactose" :false,
        "Soya" :true,
        "Vegan" :false
    ],[
        "Code": "hzCWdIft761lQOG",
        "Name": "Imli",
        "Manufacturer": "FritoLays",
        "Description": "",
        "Type": "",
        "DietFood": true,
        "BabyFood": true,
        "GymFood": false,
        "NutritionalFood": false,
        "SpicyFood": true,
        "SportsDrink": false,
        "SoftDrinks": false,
        
        
        "Calorie":true,
        "Nuts":true,
        "Eggs":false,
        "Sugar" :false,
        "Caffiene" :true,
        "Lactose" :true,
        "Soya" :true,
        "Vegan" :true
    ]
]
