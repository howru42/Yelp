//
//  Extensions.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit
let imageCache = NSCache<NSString, AnyObject>()

extension UIViewController: UIGestureRecognizerDelegate {
    
    public func getNib(_ name:String) -> UINib{
        return UINib(nibName: name, bundle: nil)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-300, width: 300,  height : 35))
        toastLabel.numberOfLines = 0
        toastLabel.text = message
        toastLabel.frame.size = CGSize(width: toastLabel.intrinsicContentSize.width + 50, height: toastLabel.intrinsicContentSize.height + 10)
        toastLabel.frame.origin = CGPoint(x: view.frame.size.width/2 - toastLabel.frame.size.width/2 , y: view.frame.size.height-320)
        toastLabel.backgroundColor = .black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 3.0, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        })
    }
}

extension UIView{
    func withCorners(_ radius:CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}

extension UIImageView {
    func setImageFromURL(_ URLString: String?, placeHolder: UIImage?) {
        self.image = nil
        guard let URLString = URLString,!URLString.isEmpty else { self.image = placeHolder
            return }
        
        //If imageurl's imagename has space then this line going to work for this
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let cachedImage = imageCache.object(forKey: URLString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
