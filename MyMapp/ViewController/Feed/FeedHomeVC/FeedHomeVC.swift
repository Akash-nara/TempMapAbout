//
//  FeedHomeVC.swift
//  MyMapp
//
//  Created by Akash on 16/02/22.
//

import UIKit

class FeedHomeVC: UIViewController {
    
    @IBOutlet weak var tableViewFeedList: SayNoForDataTableView!
    @IBOutlet weak var labelFeedTitle: UILabel!
    @IBOutlet weak var buttonNotification: UIButton!
    
    var viewModel = FeedHomeViewModel()
    var isExpand = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func configureTableView(){
        tableViewFeedList.registerCell(type: FeedTableViewCell.self, identifier: "FeedTableViewCell")
        tableViewFeedList.showsVerticalScrollIndicator = false
        
        // Enable automatic row auto layout calculations
        tableViewFeedList.rowHeight = UITableView.automaticDimension;
        tableViewFeedList.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        if #available(iOS 15.0, *) {
            tableViewFeedList.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableViewFeedList.sayNoSection = .noFeedFound("Feed not found.")
//        tableViewFeedList.figureOutAndShowNoResults()
        
    }
    
    @IBAction func buttonNotificationTapped(sender:UIButton){
        
    }
}

//MARK: - TABLEVIEW METHODS
extension FeedHomeVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewFeedList.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        
        cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
        cell.buttonBookmark.tag = indexPath.row
        
        cell.buttonLike.addTarget(self, action: #selector(buttonLikeUnLikedClicked(sender:)), for: .touchUpInside)
        cell.buttonLike.tag = indexPath.row
        
        
        let txt = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
        cell.labelExp.text = txt
        cell.labelExp.isUserInteractionEnabled = true

        if viewModel.arrayOfFeed[indexPath.row].isExpand{
            cell.labelExp.appendReadmore(after: txt, trailingContent: .readmore)
        }else{
            cell.labelExp.appendReadLess(after: txt, trailingContent: .readless)
        }

        return cell
    }
    
    @objc func buttonLikeUnLikedClicked(sender:UIButton){
        sender.isSelected.toggle()
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        sender.isSelected.toggle()
    }
}

enum TrailingContent {
    case readmore
    case readless

    var text: String {
        switch self {
        case .readmore: return "...Read More"
        case .readless: return " Read Less"
        }
    }
}

extension UILabel {

    private var minimumLines: Int { return 4 }
    private var highlightColor: UIColor { return .red }

    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: self.font ?? .systemFont(ofSize: 18)]
    }
    
    public func requiredHeight(for text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = minimumLines
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
      }

    func highlight(_ text: String, color: UIColor) {
        guard let labelText = self.text else { return }
        let range = (labelText as NSString).range(of: text)

        let mutableAttributedString = NSMutableAttributedString.init(string: labelText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = mutableAttributedString
    }

    func appendReadmore(after text: String, trailingContent: TrailingContent) {
        self.numberOfLines = minimumLines
        let fourLineText = "\n\n\n"
        let fourlineHeight = requiredHeight(for: fourLineText)
        let sentenceText = NSString(string: text)
        let sentenceRange = NSRange(location: 0, length: sentenceText.length)
        var truncatedSentence: NSString = sentenceText
        var endIndex: Int = sentenceRange.upperBound
        let size: CGSize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        while truncatedSentence.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height >= fourlineHeight {
            if endIndex == 0 {
                break
            }
            endIndex -= 1

            truncatedSentence = NSString(string: sentenceText.substring(with: NSRange(location: 0, length: endIndex)))
            truncatedSentence = (String(truncatedSentence) + trailingContent.text) as NSString

        }
        self.text = truncatedSentence as String
        self.highlight(trailingContent.text, color: highlightColor)
    }

    func appendReadLess(after text: String, trailingContent: TrailingContent) {
        self.numberOfLines = 0
        self.text = text + trailingContent.text
        self.highlight(trailingContent.text, color: highlightColor)
    }
}


