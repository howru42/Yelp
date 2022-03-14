//
//  HeaderCollectionViewCell.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var headerLbl:UILabel!
    
    func setDetails(_ header:String){
        headerLbl.text = header
    }
}
