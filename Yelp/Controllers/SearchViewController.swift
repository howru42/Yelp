//
//  SearchViewController.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit

class SearchViewController: BaseCollectionViewController, ContentDelegate {
    var filteredItems:[Any] = []{
        didSet{
            loadData()
        }
    }
    var searchItems:[Any] = []{
        didSet{
            filteredItems = searchItems
        }
    }
    var searchTerm:TermType = .FOOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        contentDelegate = self
    }
    
    func loadData(){
        items = [filteredItems]
    }
    
    func registerCells() {
        baseCollectionView.register(getNib("BusinessListItemCollectionViewCell"), forCellWithReuseIdentifier: "cell")
        baseCollectionView.register(getNib("SearchBarCollectionViewCell"), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchCell")
    }
    
    func headerrItems() -> [String] {
        return ["Search with"]
    }
    
    override func headerCell(_ indexPath: IndexPath) -> UICollectionReusableView {
        let cell = baseCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchCell", for: indexPath) as! SearchBarCollectionViewCell
        cell.onSearchTextChanged = { [weak self] text in
            self?.searchRelatedItems(text, onResult: { response in
                self?.filteredItems = response
            })
        }
        cell.onSearchTextCleared = { [weak self] in
            self?.filteredItems.removeAll()
            self?.filteredItems = self?.searchItems ?? []
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = baseCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BusinessListItemCollectionViewCell
        if let item = items[indexPath.section][indexPath.row] as? BusinessDetail{
            cell.setDetails(item)
        }
        return cell
    }
    
    override func getLayout(_ section: Int) -> NSCollectionLayoutSection {
        return getDCLayout(type:.Vertical,itemWH: (1,1), groupWH: (1,0.25),headerWH: (section == 0) ? (1,80) : zeroWH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailsViewController()
        controller.businessDetails = items[indexPath.section][indexPath.row] as? BusinessDetail
        newController = controller
    }
    
    func searchRelatedItems(_ searchText:String,onResult:((_ items: [BusinessDetail])->Void)?){
        ItemsRepository.shared.fetchBusinessItem(searchText, onResult: onResult)
    }
}

//ItemsRepository.shared.fetchBusinessItem(searchTerm.rawValue, onResult: { [weak self] response in
//    self?.searchItems = response
//})
