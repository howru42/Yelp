//
//  SearchBarCollectionViewCell.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit

class SearchBarCollectionViewCell: UICollectionViewCell,UISearchBarDelegate {

    var onSearchTextChanged:((_ text:String)->Void)?
    var onSearchTextCleared:(()->Void)?
    
    @IBOutlet private weak var searchBar:UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.delegate = self        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.searchTextField.text ?? ""
        if searchText.isEmpty {
            onSearchTextCleared?()
        }else{
            onSearchTextChanged?(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onSearchTextCleared?()
        searchBar.searchTextField.resignFirstResponder()
    }
}
