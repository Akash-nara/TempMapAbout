//
//  LessMoreCustomizeLabel.swift
//  MyMapp
//
//  Created by Akash on 22/12/18.
//  Copyright © 2018 Akash. All rights reserved.
//

import UIKit
import ActiveLabel

class LessMoreCustomizeLabel: ActiveLabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initConfig()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initConfig()
    }
    
    
    // Empty content part ---------------------------------------------------
    var addImageView: UIImageView = UIImageView()
    var defaultFont: UIFont? = nil
    var emptyContentFont = UIFont.Montserrat.SemiBold(14)
    var emptyContentTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
    public var readMoreText: String = "see more"
    public var readLessText: String = "see less"
    
    var isProfileViewer = false {
        didSet {
            self.addImageView.isHidden = true
        }
    }
    
    func initConfig() {
        self.emptyContent = ""
        self.defaultFont = self.font
        self.font = self.emptyContentFont
        
//        self.addImageView.image = #imageLiteral(resourceName: "photoGallery_back_arrow")
        self.addSubview(self.addImageView)
        self.addImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addImageView.addLeft(isSuperView: self, constant: 0)
        self.addImageView.addCenterY(inSuperView: self)
        
        // add empty content tap gesture
        emptyContentTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(emptyContentTap)
    }
    
    var addContentTapClosure: (() -> ())? = nil
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        // add icon visiblity says there is not content
        if !self.addImageView.isHidden {
            self.addContentTapClosure?()
        }
    }
    func emptyContentTriggered(addContentClosure: @escaping () -> ()) {
        self.addContentTapClosure = addContentClosure
    }
    
    var emptyContentString: String = ""
    @IBInspectable var emptyContent: String = "" {
        didSet {
            if isProfileViewer {
                self.textColor = UIColor.black
                self.text = "no_bio_available"
            }else{
                self.emptyContentString = self.emptyContent
                self.addImageView.isHidden = false
                self.font = self.emptyContentFont
                self.text = "      \(self.emptyContent)"
                self.textColor = UIColor.black
            }
        }
    }
    
    var seeMoreLessColor: UIColor = UIColor.black
    var setTextFont: UIFont = UIFont.Montserrat.Regular(14)
    var seeMoreLessFont: UIFont = UIFont.Montserrat.Bold(14)

    
    // content part ---------------------------------------------------------
    var wholeContent: String = ""
    var isShowWholeContent: Bool = false
    var isOneLinedContent: Bool = false
    func setContent(_ content: String, noOfCharacters: Int, readMoreTapped: (() -> ())? = nil, readLessTapped: (() -> ())? = nil) {
        
        guard content.count != 0 else {
            self.emptyContent = self.emptyContentString
            self.addGestureRecognizer(emptyContentTap)
            return
        }
        
        var charactersUpTo = noOfCharacters
        var finalContent = content
        if self.isOneLinedContent {
            let text = content
            finalContent = String(text.filter { !"\n\t\r".contains($0) })
            //charactersUpTo = Int(self.bounds.size.width/7)
        }

        // Theme
        self.textColor = UIColor.black
        self.removeGestureRecognizer(emptyContentTap) // remove empty content tap gesture
        let customType = ActiveType.custom(pattern: self.readMoreText) //Regex that looks for "with"
        self.setSeeMoreSeeLessFontBold(customType)

        // get string up to noOfCharacters given
        self.wholeContent = content

        func setWholeContent() {
            let customType = ActiveType.custom(pattern: self.readLessText) //Regex that looks for "with"
            self.enabledTypes = [customType]
            self.text = self.wholeContent + readLessText
            
            self.setSeeMoreSeeLessFontBold(customType)
            
            self.customColor[customType] = seeMoreLessColor
            self.font = setTextFont
            self.handleCustomTap(for: customType) { (tappedString) in
                self.removeHandle(for: customType)
                setLessContent()
                readLessTapped?()
            }
        }
        
        let stringValue = finalContent
        let endIndex = stringValue.count > charactersUpTo ? charactersUpTo : stringValue.count
        let index = stringValue.index(stringValue.startIndex, offsetBy: endIndex)
        let mySubstring = String(stringValue.prefix(upTo: index))
        func setLessContent() {
            let customType = ActiveType.custom(pattern: self.readMoreText) //Regex that looks for "with"
            
            self.enabledTypes = [customType]
            self.text = mySubstring + "..." + readMoreText
            self.textColor = UIColor.black
            self.customColor[customType] = seeMoreLessColor
            self.font = setTextFont
            self.setSeeMoreSeeLessFontBold(customType)
            
            self.handleCustomTap(for: customType) { (tappedString) in
                self.removeHandle(for: customType)
                setWholeContent()
                readMoreTapped?()
            }
        }
        
        if isShowWholeContent {
            setWholeContent()
            return
        }
        
        if stringValue.count > noOfCharacters{
            setLessContent()
        }else{
            self.text = mySubstring
        }
        
        // if content is there to show. hide describe your self
        if content.count != 0 {
            self.hideDescribeYourSelfIndicationDefaultTitle()
        }
    }
    var isNeedToUnderlineSeeMoreSeeLess: Bool = false
    func setSeeMoreSeeLessFontBold(_ customType:ActiveType){
        self.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            switch type {
            case customType:
                atts[NSAttributedString.Key.font] = self.seeMoreLessFont
                if self.isNeedToUnderlineSeeMoreSeeLess{
                    atts[NSAttributedString.Key.underlineStyle] =  NSUnderlineStyle.single.rawValue
                }
            default: ()
            }
            return atts
        }
    }
    
    func hideDescribeYourSelfIndicationDefaultTitle() {
        self.addImageView.isHidden = true
    }
    
    func hideAddIcon() {
        self.addImageView.isHidden = true
    }
}
