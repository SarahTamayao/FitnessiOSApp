//
//  AthleteCollectionViewCell.swift
//  JSUFitness
//
//  Created by Chao Jiang on 4/6/22.
//

import UIKit

class AthleteCollectionViewCell: UICollectionViewCell {
    
    let portrait:UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
//        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage.init(systemName: "person.fill")
        return iv
    }()
    
    let fNamelabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 15)
        lb.text = "Name"
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .systemGray
        
        portraitLayoutSetup()
        fNameLabelLayoutSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension AthleteCollectionViewCell {
    func portraitLayoutSetup() {
        portrait.setToRoundedView()
        self.addSubview(portrait)
        portrait.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            portrait.topAnchor.constraint(equalTo: self.topAnchor),
            portrait.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            portrait.widthAnchor.constraint(equalToConstant: 83),
            portrait.heightAnchor.constraint(equalToConstant: 83)
        ])
    }
    
    func fNameLabelLayoutSetup() {
        self.addSubview(fNamelabel)
        fNamelabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fNamelabel.topAnchor.constraint(equalTo: portrait.bottomAnchor, constant: 2),
            fNamelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fNamelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            fNamelabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
