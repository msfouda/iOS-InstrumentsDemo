//
//  DetailsViewController.swift
//  InstrumentsDemo
//
//  Updated by Mohamed Sobhy Fouda on 8/11/18.
//  Created by Hesham Abd-Elmegid on 8/4/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var imageView: TappableImageView!
    var image: UIImage?

    override func viewDidLoad() {
        if let image = image {
            imageView.image = image
        }

        imageView.tapHandler = {
            _ = self.navigationController?.popViewController(animated: true)
        } as (() -> (Void))
    }
}
