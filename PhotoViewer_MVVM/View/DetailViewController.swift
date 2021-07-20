//
//  DetailViewController.swift
//  PhotoViewer_MVVM
//
//  Created by Shilpa Joy on 2021-07-20.
//

import UIKit
import  SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    var imageUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl = imageUrl{
            detailImage.sd_setImage(with: URL(string: imageUrl)) { image, error, type, url in
                print(url)
            }
        }
        // Do any additional setup after loading the view.
    }


}
