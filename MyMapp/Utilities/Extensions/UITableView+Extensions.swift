//
//  UITableView+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 24/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0.0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func reloadRows(at:[IndexPath], with:UITableView.RowAnimation, completion: @escaping ()->()) {
        self.reloadRows(at: at, with: with)
        DispatchQueue.getMain(delay: 0.1) {
            completion()
        }
    }
    
    func reloadSections(_ sections:IndexSet, with: UITableView.RowAnimation, completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadSections(sections, with: with) })
        { _ in completion() }
    }
    
    func registerCellNib(identifier:String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(identifier: String, commonSetting: Bool = false) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        if commonSetting { commonSettings() }
    }
    
    func registerHeaderFooterNib(identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func commonSettings() {
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func getDefaultCell() -> UITableViewCell {
        var cell: UITableViewCell! = self.dequeueReusableCell(withIdentifier: "identifier")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "identifier")
        }
        return cell
    }
    
    func isWholeSectionVisible(section: Int) -> Bool {
        let topSpace = self.rect(forSection: section).minY - self.contentOffset.y
        return topSpace >= 0
    }
    
    func isWholeRowVisible(indexPath: IndexPath) -> Bool {
        let topSpace = self.rectForRow(at: indexPath).minY - self.contentOffset.y
        return topSpace >= 0
    }
    
    var getWhiteHeaderFooter : UIView {
        let headerOrFooter = UIView(frame: .zero)
        headerOrFooter.backgroundColor = UIColor.white
        return headerOrFooter
    }
    
    var autolayoutTableViewHeader: UIView? {
        set {
            self.tableHeaderView = newValue
            guard let header = newValue else { return }
            header.setNeedsLayout()
            header.layoutIfNeeded()
            header.frame.size =
            header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            self.tableHeaderView = header
        }
        get {
            return self.tableHeaderView
        }
    }
    
    var autolayoutTableViewFooterHeader: UIView? {
        set {
            self.tableFooterView = newValue
            guard let header = newValue else { return }
            header.setNeedsLayout()
            header.layoutIfNeeded()
            header.frame.size =
            header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            self.tableFooterView = header
        }
        get {
            return self.tableFooterView
        }
    }
}

extension UITableView {
    func setDefaultProperties(vc:UIViewController){
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.dataSource = vc as? UITableViewDataSource
        self.delegate = vc as? UITableViewDelegate
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
//        self.rowHeight = UITableView.automaticDimension
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
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    func scrollToLastRow(objectValue:Int) {
        let indexPath = NSIndexPath(row: objectValue - 1, section: 0)
        self.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    func scrollToSelectedRow() {
        let selectedRows = self.indexPathsForSelectedRows
        if let selectedRow = selectedRows?[0] as? NSIndexPath {
            self.scrollToRow(at: selectedRow as IndexPath, at: .middle, animated: true)
        }
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
}

extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections-1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}


extension UITableView {
    
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    func separator(hide: Bool) {
        separatorInset.left += hide ? bounds.size.width : 0
    }
    
    func setDefaultCellProperties(cell:UITableViewCell){
        self.selectionStyle = .none
    }
}
