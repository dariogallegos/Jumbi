//
//  DetailViewController.swift
//  Jumbi
//
//  Created by dario on 31/05/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var trushImageView: UIImageView!
    
    var detailTrush: Trush? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailTrush = detailTrush {
            if let detailDescriptionLabel = detailDescriptionLabel, let trushImageView = trushImageView {
                detailDescriptionLabel.text = detailTrush.name
                trushImageView.image = UIImage(named: detailTrush.name)
                title = detailTrush.category
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureView()
        debugPrint("estoy en detail")
        trushImageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        trushImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTapped)))
        
        
    }
    
    @objc func imageTapped() {
        //self.navigationController?.pushViewController(ViewController(), animated: true)
        performSegue(withIdentifier:"LocationSegue", sender: nil)
    }


}
