//
//  FlickrCollectionViewCell.swift
//  IntellBitsChallenge
//
//  Created by Julio Rico on 21/10/22.
//

import UIKit
import FlickerImages

class FlickrCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    let colors: [UIColor] = [.blue, .red, .green, .black, .magenta, .cyan, .yellow, .orange]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setup()
    }
    
    func fadeIn(_ urlImage: URL) {
        imageContainer.load(url: urlImage)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.3,
            usingSpringWithDamping: 0.25,
            initialSpringVelocity: 1.25,
            options: [],
            animations: {
                self.imageContainer.alpha = 1
            }, completion: { completed in
                if completed {
                    self.viewContainer.stopShimmering()
                }
            })
    }
    
    private func setup() {
        imageContainer.alpha = 0
        viewContainer.startShimmering()
    }
    
}


extension FlickrCollectionViewCell {
    func configure(viewModel: FlickerImage?) {
//        viewContainer.backgroundColor = colors.randomElement()!
//        imageContainer.alpha = 1
//        imageContainer.image = UIImage(named: "apple-logo")
//        imageContainer.contentMode = .scaleAspectFit
//        viewContainer.stopShimmering()
        
        if let viewModel = viewModel, let url = URL(string: viewModel.imageURL(imageSize: .c)) {
            fadeIn(url)
        }
    }
}
