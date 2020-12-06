//
//  PhotoCell.swift
//  WeeklySwift
//
//  Created by Viachaslau on 12/5/20.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    static let reuseId = "PhotoCell"
    
    private let checkmark: UIImageView = {
        let image = UIImage(named: "tick")
        let imV = UIImageView(image: image)
        imV.translatesAutoresizingMaskIntoConstraints = false
        imV.alpha = 0
        
        return imV
    }()
    
    let photoImageView: UIImageView = {
        let imV = UIImageView()
        imV.translatesAutoresizingMaskIntoConstraints = false
        imV.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imV.contentMode = .scaleAspectFill
        
        return imV
    }()
    
    var unsplashPhoto: UnspashPhoto? {
        didSet {
            let photoUrl = unsplashPhoto?.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else {
                return
            }
            
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateSelectedState()
        setupPhotoImageView()
        setupCheckmark()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupCheckmark() {
        photoImageView.addSubview(checkmark)
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8),
            checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8)
        ])
    }
}
