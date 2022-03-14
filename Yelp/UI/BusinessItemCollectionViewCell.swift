//
//  BusinessItemCollectionReusableView.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit

class BusinessItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var bgView:UIView!
    @IBOutlet private weak var nameLbl:UILabel!
    @IBOutlet private weak var imgView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.withCorners()
    }
    
    func setDetails(_ name:String,_ imgUrl:String = "",placeHolder:String = ""){
        imgView.setImageFromURL(imgUrl, placeHolder: UIImage(named: placeHolder))
        nameLbl.text = name
    }
    
    func setDetails(_ business:BusinessDetail){
        imgView.setImageFromURL(business.imageURL, placeHolder: UIImage(named: Constants.PLACEHOLDER_Food1))
        nameLbl.text = business.name
    }
}
