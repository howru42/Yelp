//
//  Constants.swift
//  Yelp
//
//  Created by Nkommuri on 13/03/22.
//

import Foundation
import UIKit

typealias Dimension = (CGFloat,CGFloat,CGFloat,CGFloat)
typealias SizeDimension = (CGFloat,CGFloat)
var zeroPadding:Dimension = (0,0,0,0)
var zeroWH:SizeDimension = (0,0)

enum CollectionType:Int {
    case Horizontal,Vertical
}

enum TermType:String{
    case FOOD = "food",RESTAURANT = "restaurants"
}

struct Constants {
    static let BUSINESS_ENTITY = "Business"
    static let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate
    static let VIEW_CONTEXT = APPDELEGATE?.persistentContainer.viewContext
    static let PLACEHOLDER_Food1 = "food1"
    static let PLACEHOLDER_Food2 = "food2"
    static let PLACEHOLDER_REST = "restaurant1"
}

struct EndPoints{
    static let SEARCH_BUSINESSES_API = "https://api.yelp.com/v3/businesses/search"
    static let API_KEY = "pVsDVsr01tInNWBJAzOVdpHXLziseRLVKuGw-FejC9RriegZt16nCOOg2_LJgw8fpaIarBcHbLKb80w4PGfr9imQTqI_mvLDWSWtqYlaIOquvzEt4Uxh5sq_Hfo0YXYx"
    static let tempLatitude = "40.708601514766876"
    static let tempLongitude = "-73.93027523760566"
}
