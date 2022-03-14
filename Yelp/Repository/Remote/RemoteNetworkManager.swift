//
//  RemoteNetworkManager.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import Foundation

class RemoteNetworkManager{
    
    private init(){ }
    
    static let shared = RemoteNetworkManager()
    typealias CompletionHandler = (_ response:Any?,_ error:String?) -> Void
    
    func fetchNearByItems(term:String,latitude:String,longitude:String,completion:@escaping CompletionHandler){
        guard let url = URL(string: "\(EndPoints.SEARCH_BUSINESSES_API)?term=\(term)&latitude=\(latitude)&longitude=\(longitude)&radius=40000") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(EndPoints.API_KEY)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil,error.localizedDescription)
                }else{
                    guard let data = data else { return }
                    let parsedData = try? JSONDecoder().decode(BaseResponse.self, from: data)
                    print(parsedData)
                    completion(parsedData?.businesses,nil)
                }
            }
        }
        task.resume()
    }
}
