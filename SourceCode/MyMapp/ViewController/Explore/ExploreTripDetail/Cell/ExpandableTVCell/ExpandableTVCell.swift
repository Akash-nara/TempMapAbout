//
//  ExpandableTVCell.swift
//  MyMapp
//
//  Created by Akash Nara on 12/03/22.
//

import UIKit

class ExpandableTVCell: UITableViewCell {

    @IBOutlet weak var buttonExpandToggle: UIButton!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var buttonArrow: UIButton!
    @IBOutlet weak var viewParentExpandableDetail: UIView!

    @IBOutlet weak var stackViewParentBulletPoint: UIStackView!
    @IBOutlet weak var stackViewParentLeftBulletpoint: UIStackView!
    @IBOutlet weak var labelLeftBulletPointHeading: UILabel!
    @IBOutlet weak var stackViewLeftBulletpoint: UIStackView!
    @IBOutlet weak var stackViewParentRightBulletpoint: UIStackView!
    @IBOutlet weak var labelRightBulletPointHeading: UILabel!
    @IBOutlet weak var stackViewRightBulletpoint: UIStackView!

    @IBOutlet weak var stackViewParentCovid19: UIStackView!
    @IBOutlet weak var labelCovid19Heading: UILabel!
    @IBOutlet weak var labelCovid19Detail: UILabel!
    @IBOutlet weak var viewParentHere: UIView!
    @IBOutlet weak var buttonHere: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        buttonArrow.setImage(UIImage(named: "iconsArrowDown"), for: .normal)
        buttonArrow.setImage(UIImage(named: "iconsArrowUp"), for: .selected)
        buttonArrow.isSelected = false
        buttonArrow.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getBulletPointLabel(text: String) -> UILabel {
        let labelPoint = UILabel()
        labelPoint.font = UIFont.Montserrat.Medium(12)
        labelPoint.textColor = UIColor(named: "App_BG_SecondaryDark2_Color")
        labelPoint.text = " •  \(text)"
        return labelPoint
    }
    
    func loadLeftBulletPoints(data: [String]) {
        guard !data.count.isZero() else {
            stackViewLeftBulletpoint.isHidden = true
            return
        }
        stackViewLeftBulletpoint.isHidden = false
        
        stackViewLeftBulletpoint.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        data.forEach { point in
            stackViewLeftBulletpoint.addArrangedSubview(getBulletPointLabel(text: point))
        }
    }
    
    func loadRightBulletPoints(data: [String]) {
        guard !data.count.isZero() else {
            stackViewRightBulletpoint.isHidden = true
            return
        }
        stackViewRightBulletpoint.isHidden = false
        
        stackViewRightBulletpoint.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        data.forEach { point in
            stackViewRightBulletpoint.addArrangedSubview(getBulletPointLabel(text: point))
        }
    }
}

extension ExpandableTVCell {
    func cellConfig(data: ExploreSuggestionDataModel) {
        cellConfigExpandable(isOpen: data.isOpenCell)
        switch data.cellType {
        case .covid19:
            cellConfigCovid19(data: data)
        case .languagesAndCurrencies:
            cellConfigBulletPoint(data: data)
        default:
            break
        }
    }
    
    func cellConfigExpandable(isOpen: Bool) {
        viewParentExpandableDetail.isHidden = !isOpen
        buttonArrow.isSelected = isOpen
    }
    
    func cellConfigCovid19(data: ExploreSuggestionDataModel) {
        stackViewParentBulletPoint.isHidden = true
        stackViewParentCovid19.isHidden = false
        
        labelHeading.text = data.title
        
        if let item = data.items.first {
            labelCovid19Heading.text = item.title
            labelCovid19Heading.isHidden = true

            labelCovid19Detail.text = item.detail
        }
    }
    
    func cellConfigBulletPoint(data: ExploreSuggestionDataModel) {
        stackViewParentCovid19.isHidden = true
        stackViewParentBulletPoint.isHidden = false
        
        labelHeading.text = data.title

        if data.items.count >= 1 {
            labelLeftBulletPointHeading.text = data.items[0].title
            loadLeftBulletPoints(data: data.items[0].detail.components(separatedBy: ","))
            stackViewParentLeftBulletpoint.isHidden = false
        } else {
            stackViewParentLeftBulletpoint.isHidden = true
        }
        
        if data.items.count == 2 {
            labelRightBulletPointHeading.text = data.items[1].title
            loadRightBulletPoints(data: data.items[1].detail.components(separatedBy: ","))
            stackViewParentRightBulletpoint.isHidden = false
        } else {
            stackViewParentRightBulletpoint.isHidden = true
        }
        
//        labelLeftBulletPointHeading.text = "Languages"
//        loadLeftBulletPoints(data: ["Spanish", "Catalan"])
        
//        labelRightBulletPointHeading.text = "Currency"
//        loadRightBulletPoints(data: ["Euro"])
    }
    
}
