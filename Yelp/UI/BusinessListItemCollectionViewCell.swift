//
//  BusinessListItemCollectionViewCell.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit

class BusinessListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imgView:UIImageView!
    @IBOutlet private weak var nameLbl:UILabel!
    @IBOutlet private weak var locationLbl:UILabel!
    @IBOutlet private weak var bgView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.withCorners(10)
    }

    func setDetails(_ businessDetail:BusinessDetail){
        nameLbl.text = businessDetail.name
        locationLbl.text = businessDetail.name
        imgView.setImageFromURL("", placeHolder: UIImage(named: Constants.PLACEHOLDER_REST))
    }
}
