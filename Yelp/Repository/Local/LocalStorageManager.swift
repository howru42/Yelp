//
//  LocalStorageManager.swift
//  Yelp
//
//  Created by Nkommuri on 13/03/22.
//

import Foundation
import CoreData

enum PredicteType:String{
    case NAME_CONTAINS_SEARCH = "name CONTAINS %@", ID_SEARCH = "businessId = %@"
}
class LocalStorageManager{
    private init(){ }
    
    static let shared = LocalStorageManager()
    
    func storeBusinessData(_ businessItem:BusinessDetail){
        guard let viewContext = Constants.VIEW_CONTEXT else { return }
        if let businessEntity = NSEntityDescription.entity(forEntityName: Constants.BUSINESS_ENTITY, in: viewContext){
            let storedItem = fetchBusiness(businessItem.id,predicateType: .ID_SEARCH) ?? []
            if storedItem.isEmpty,let record = NSManagedObject(entity: businessEntity, insertInto: viewContext)  as? Business{
                record.businessId = businessItem.id
                record.name = businessItem.name
                record.rating = businessItem.rating
                record.location = businessItem.location?.getDisplayAddress() ?? ""
                record.image = businessItem.imageURL
                record.price = businessItem.price
                record.phone = businessItem.displayPhoneNo
                do{
                    try viewContext.save()
                }catch let error as NSError{
                    print("Unable to store \(error.localizedDescription)")
                }
            }            
        }
    }
    
    
    func fetchBusiness(_ searchText:String,predicateType:PredicteType = .NAME_CONTAINS_SEARCH) -> [BusinessDetail]?{
        guard let viewContext = Constants.VIEW_CONTEXT else { return []}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.BUSINESS_ENTITY)
        let predicate = NSPredicate(format: predicateType.rawValue, searchText)
        fetchRequest.predicate = predicate
        do{
            if let result = try (viewContext.fetch(fetchRequest) as? [Business]){
                return result.map({ business in
                    BusinessDetail(name: business.name ?? "", rating: business.rating, id: business.businessId ?? "", imageURL: business.image ?? "" , price: business.price, displayPhoneNo: business.phone ?? "", location: Location(displayAdderss: [business.location ?? ""]))
                })
            }
        }catch let error as NSError{
            print("Unable to store \(error.localizedDescription)")
        }
        return []
    }
    
    
}
