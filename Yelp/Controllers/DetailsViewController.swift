//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit

class DetailsViewController: UIViewController {
    init() {
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBOutlet private weak var nameLbl:UILabel!
    @IBOutlet private weak var ratingLbl:UILabel!
    @IBOutlet private weak var priceLbl:UILabel!
    @IBOutlet private weak var locationLbl:UILabel!
    @IBOutlet private weak var contactNoLbl:UILabel!
    @IBOutlet private weak var imgView:UIImageView!
    var businessDetails:BusinessDetail? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        setDetails()
        if let businessDetails = businessDetails {
            ItemsRepository.shared.storeItems([businessDetails])
        }
    }
    
    func setDetails(){
        if let detail = businessDetails {
            nameLbl.text = detail.name
            ratingLbl.text = "\(detail.rating)"
            locationLbl.text = detail.location?.getDisplayAddress()
            priceLbl.text = detail.price
            contactNoLbl.text = detail.displayPhoneNo
            imgView.setImageFromURL(detail.imageURL, placeHolder: UIImage(named: Constants.PLACEHOLDER_REST))
        }
    }
}
