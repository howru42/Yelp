//
//  ItemsRepository.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import Foundation

class ItemsRepository{
    private init(){ }
    static let shared = ItemsRepository()
    
    lazy private var localManager = LocalStorageManager.shared
    lazy private var remoteManager = RemoteNetworkManager.shared
    
    func storeItems(_ businesses:[BusinessDetail]){
        for business in businesses{
            localManager.storeBusinessData(business)
        }
    }
    
    func fetchBusinessItem(_ name:String,onResult:((_ items: [BusinessDetail])->Void)?){
        if let businesses = localManager.fetchBusiness(name){
            onResult?(businesses)
        }
        if let location = LocationManager.shared.userLocation{
            let latitude = location.latitude.description,longitude = location.longitude.description
            remoteManager.fetchNearByItems(term: name, latitude: latitude, longitude: longitude) {response, error in
                if let error = error {
                    debugPrint(error)
                }else if let response = response as? [BusinessDetail]{
                    onResult?(response)
                }
            }
        }
    }
}
