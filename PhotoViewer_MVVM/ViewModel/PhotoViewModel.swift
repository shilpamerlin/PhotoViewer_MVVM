//
//  PhotoViewModel.swift
//  PhotoViewer_MVVM
//
//  Created by Shilpa Joy on 2021-07-20.
//

import Foundation
import UIKit

class PhotoViewModel: NSObject {
    
    var reloadTableViewClosure: (() -> ()) = {}
    var updateLoadingStatus: (() -> ()) = {}
    var apiService: APIService!
    private var photo: [Photo] = [Photo]()
      
    private var cellViewModels = [PhotoListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    //isLoading is True before API data fetch starts, which means view will switch the activity indicator ON
    var isLoading: Bool = false {
        didSet{
            self.updateLoadingStatus()
        }
    }
    var isAllowSegue: Bool = false
    var selectedPhoto: Photo?
    
    override init() {
        super.init()
        self.apiService = APIService()
        fetchData()
    }
    func fetchData(){
        self.isLoading = true
        apiService.fetchPopularPhoto { photo in
            self.photo = photo
            self.processFetchedPhoto(photo: photo)
            self.isLoading = false
        }
        
    }
    func processFetchedPhoto(photo: [Photo]){
        
        self.photo = photo // Cache
        var vms = [PhotoListCellViewModel]()
        for photo in photo {
            vms.append( createCellViewModel(photo: photo) )
        }
        self.cellViewModels = vms
    }
 
    func createCellViewModel( photo: Photo ) -> PhotoListCellViewModel {

        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }

        if let description = photo.description {
            descTextContainer.append( description )
        }

        let desc = descTextContainer.joined(separator: " - ")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return PhotoListCellViewModel( titleText: photo.name,
                                       descText: desc,
                                       imageUrl: photo.imageUrl,
                                       dateText: dateFormatter.string(from: photo.createdAt) )
    }
    
    func getSelectedCellInfo(at indexPath: IndexPath) {
        let photo = self.photo[indexPath.row]
        
        if photo.forSale {
            self.isAllowSegue = true
            selectedPhoto = photo
            print(" sale")
            print(isAllowSegue)
        }else {
            self.isAllowSegue = false
            self.selectedPhoto = nil
            print("not sale")
        }
        
    }
    
    func showAlert(photo: Photo) -> String{
        return ("\(photo.name) is not for sale")
    }
}



struct PhotoListCellViewModel { //1.
    
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}


