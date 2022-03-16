//
//  UICollectionView+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 19/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCellNib(identifier: String, commonSetting: Bool = false) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        if commonSetting { commonSettings() }
    }
    
    func commonSettings() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func getDefaultCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell! = self.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        if cell == nil {
            cell = UICollectionViewCell.init()
        }
        return cell
    }
    
    func reloadData(_ completion: (() -> Void)? = nil) {
        reloadData()
        guard let completion = completion else { return }
        layoutIfNeeded()
        completion()
    }
    
    func setDefaultProperties(vc:UIViewController){
        self.backgroundColor = .clear
        self.dataSource = vc as? UICollectionViewDataSource
        self.delegate = vc as? UICollectionViewDelegate
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.Montserrat.SemiBold(dynamicFontSize(17))
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
