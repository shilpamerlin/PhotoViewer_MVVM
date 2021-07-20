//
//  ViewController.swift
//  PhotoViewer_MVVM
//
//  Created by Shilpa Joy on 2021-07-20.
//

import UIKit
import SDWebImage

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    private var viewModel: PhotoViewModel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoTblview: UITableView!
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        photoTblview.dataSource = self
        photoTblview.delegate = self
        viewModel = PhotoViewModel()
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading { //True means Data fetch happening
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self?.photoTblview.alpha = 0.0
                    }
                    
                }else{
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self?.photoTblview.alpha = 1.0
                    }
                }
            }
        }
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.photoTblview.reloadData()
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = photoTblview.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as! PhotoTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.photoName.text = cellVM.titleText
        cell.photoDescription.text = cellVM.descText
        cell.photoDate.text = cellVM.dateText
        cell.photoImage.sd_setImage(with: URL(string: cellVM.imageUrl), completed: nil)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.viewModel.getSelectedCellInfo(at: indexPath)
        if viewModel.isAllowSegue {
            print("in will select")
            return indexPath
        }else {
        return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewContrl = segue.destination as? DetailViewController,
            let photo = viewModel.selectedPhoto {
            viewContrl.imageUrl = photo.imageUrl
        }
    }
        
    
}

