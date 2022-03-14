//
//  HomeViewController.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit
import CoreLocation

struct SectionItem {
    var title:String
    var image:String
    var termType:TermType
}

class HomeViewController: BaseCollectionViewController,ContentDelegate {
    
    var sections:[SectionItem] = [SectionItem(title: "Food", image: "food1",termType: .FOOD),SectionItem(title: "Restaurants", image: "restaurant1",termType: .RESTAURANT)]
    
    var nearByItems:[BusinessDetail] = []{
        didSet{
            loadData()
        }
    }
    lazy var locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentDelegate = self
        locationManager.initLocation()
        locationManager.locationDelegate = self
//        fetchFromServer()
    }
    
    func registerCells() {
        baseCollectionView.register(getNib("BusinessItemCollectionViewCell"), forCellWithReuseIdentifier: "cell")
        baseCollectionView.register(getNib("HeaderCollectionViewCell"), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
    }
    
    func loadData(){
        items = [sections,nearByItems]
    }
    
    func headerrItems() -> [String] {
        return ["Search by","Near by restaurants"]
    }
    
    override func headerCell(_ indexPath: IndexPath) -> UICollectionReusableView {
        if let headerCell = baseCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell", for: indexPath) as? HeaderCollectionViewCell{
            headerCell.setDetails(headerrItems()[indexPath.section])
            return headerCell
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BusinessItemCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BusinessItemCollectionViewCell)!
        let item = items[indexPath.section][indexPath.row]
        if let sectionItem = item as? SectionItem {
            cell.setDetails(sectionItem.title, placeHolder: sectionItem.image)
        }else if let item = item as? BusinessDetail{
            cell.setDetails(item)
        }
        return cell
    }
    
    override func getLayout(_ section: Int) -> NSCollectionLayoutSection {
        return getDCLayout(type:.Horizontal,itemWH: (1,1), groupWH: (0.4,0.4),headerWH: (1,50),itemPadding: zeroPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row]
        if item is SectionItem {
            let controller = SearchViewController()
            controller.searchTerm = (item as? SectionItem)?.termType ?? .FOOD
            newController = controller
        }else if item is BusinessDetail{
            let controller = DetailsViewController()
            controller.businessDetails = item as? BusinessDetail
            newController = controller
        }
    }
}

extension HomeViewController: LocationDelegate{
    func onLocationError(restricted: Bool, error: String?) {
        if restricted {
            showToast(message: "Location Privilege restricted")
        }else{
            showToast(message: error ?? "Unknown error")
        }
    }
    
    func onNewLocation(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        debugPrint("... new location...")
        fetchFromServer(coordinate.latitude.description, coordinate.longitude.description)
    }
}

extension HomeViewController{
    func fetchFromServer(_ latitude:String = EndPoints.tempLatitude,_ longitude:String = EndPoints.tempLongitude){
        RemoteNetworkManager.shared.fetchNearByItems(term: TermType.RESTAURANT.rawValue, latitude: latitude, longitude: longitude) { [weak self] response, error in
            if let error = error {
                self?.showToast(message: error)
            }else if let response = response as? [BusinessDetail]{
                self?.nearByItems = response
            }
        }
    }
}
