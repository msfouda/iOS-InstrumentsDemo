//
//  ViewController.swift
//  InstrumentsDemo
//
//  Updated by Mohamed Sobhy Fouda on 8/11/18.
//  Created by Hesham Abd-Elmegid on 8/2/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let itemHeight = 200
    var images = [Int:UIImage]()
    
    
    // MARK: Low Memory Warning
    override func didReceiveMemoryWarning() {
        images.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushDetailsViewController" {
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.image = sender as? UIImage
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCellIdentifier", for: indexPath) as! PhotoCollectionViewCell
        let bounds = UIScreen.main.bounds
        let itemWidth = bounds.width
        let url = URL(string: "https://picsum.photos/\(Int(itemWidth))/\(itemHeight)/?random")!
        
        if let image = images[(indexPath as NSIndexPath).row] {
            cell.imageView.image = image
        } else {
            cell.activityIndicatorView.startAnimating()
            
            fetchImageAtURL(url) { (image) in
                OperationQueue.main.addOperation({
                    cell.activityIndicatorView.stopAnimating()
                    cell.imageView.image = image
                    self.images[(indexPath as NSIndexPath).row] = image
                })
            }
        }
        
        return cell
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PushDetailsViewController", sender: images[(indexPath as NSIndexPath).item])
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let itemWidth = bounds.width
        return CGSize(width: itemWidth, height: CGFloat(itemHeight))
    }
}

extension PhotosViewController {
    func fetchImageAtURL(_ url: URL, success: @escaping ((_ image: UIImage) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.applyFiltersToImage(image, success: { (image) in
                    success(image)
                })
            }
        }) .resume()
    }
    
    func applyFiltersToImage(_ image: UIImage, success: @escaping ((UIImage) -> Void)) {
        OperationQueue().addOperation {
            let context = CIContext(options: nil)
            
            if let currentFilter = CIFilter(name: "CIPhotoEffectMono") {
                let beginImage = CIImage(image: image)
                currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                
                if let output = currentFilter.outputImage {
                    let cgimg = context.createCGImage(output, from: output.extent)
                    let processedImage = UIImage(cgImage: cgimg!)
                    success(processedImage)
                }
            }
        }
    }
}

