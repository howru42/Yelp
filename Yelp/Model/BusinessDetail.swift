//
//  Business.swift
//  Yelp
//
//  Created by Nkommuri on 13/03/22.
//

import Foundation

struct BaseResponse:Codable{
    var businesses:[BusinessDetail]
    var total:Int
}

struct BusinessDetail:Codable {
    var name:String
    var rating:Float
    var id:String
    var imageURL:String
    var price:String?
    var displayPhoneNo:String
    var location:Location?
    enum CodingKeys: String, CodingKey {
        case displayPhoneNo = "display_phone",imageURL = "image_url"
        case name,rating,id,price,location
    }
}

struct Location:Codable{
    var displayAdderss:[String]?
    
    enum CodingKeys: String, CodingKey {
        case displayAdderss = "display_address"
    }
    
    func getDisplayAddress() -> String{
        return displayAdderss?.joined(separator: ",") ?? ""
    }
}
