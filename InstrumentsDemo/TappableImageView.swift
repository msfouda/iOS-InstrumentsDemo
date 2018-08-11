//
//  TappableImageView.swift
//  InstrumentsDemo
//
//  Updated by Mohamed Sobhy Fouda on 8/11/18.
//  Created by Hesham Abd-Elmegid on 8/4/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit

class TappableImageView: UIImageView {
    var tapHandler: (() -> (Void))? {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TappableImageView.tappedImage))
            addGestureRecognizer(tapGestureRecognizer)
            isUserInteractionEnabled = true
        }
    }
    
    @objc func tappedImage() {
        tapHandler?()
    }
}
