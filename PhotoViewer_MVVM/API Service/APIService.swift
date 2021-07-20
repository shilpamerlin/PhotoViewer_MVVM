//
//  APIService.swift
//  PhotoViewer_MVVM
//
//  Created by Shilpa Joy on 2021-07-20.
//

import Foundation

class APIService {
    
    func fetchPopularPhoto(comp: @escaping ([Photo]) -> ()) {
        
        DispatchQueue.global().async {
            let path = Bundle.main.path(forResource: "content", ofType: "json")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path!))
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let photos = try decoder.decode(Photos.self, from: data)
                //print(photos)
                comp(photos.photos)
            }
            catch{
                print("Error loading\(error)")
            }
        }
        
    }
    
}
