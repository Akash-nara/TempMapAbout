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
        getSocketTripData()
        

//        self.getTripListApi()
//        SHOW_CUSTOM_LOADER()
        DispatchQueue.getMain(delay: 0.2) {
            self.getTripListApi()

        }
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reCallTripListApi), name: Notification.Name("reloadUserTripList"), object: nil) //mdafafasfasfasfafafafafafaasfasfasfsfafsasfasfasfasfddsfsdgdgssgsdgdsgsdgsdgsdgsgsdgsdgsdgsdgssdgsdgsgsgsdgsdgsdgdsgdsfdsfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfs
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    @objc func reCallTripListApi() {
        stopLoaders()
        self.getTripListApi(isPullToRefresh: true)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }//dadasddasdasdsaddasdasdasdasdasdasdasasfdsfdsfsfsdfsdfdssdrwerwerwerwerwerwerwerwerwerwerwerwewerwegdfgdfgfdgdgfdgdfgdfgasdadasdsadasdadasdasdasdvdfsvfdvdffdvdvdffvdvdfvfdvxvzxczxcvxzvnzxvxzvzxvzvxzvadadsdwewqeeqeewqwqeqweewqeqwewqeweqwewqewqeqeweqwewe
    
    func configureTableView(){
        tableViewFeedList.registerCell(type: FeedTableViewCell.self, identifier: "FeedTableViewCell")
        tableViewFeedList.registerCell(type: SkeletonTripTVCell.self, identifier: "SkeletonTripTVCell")
        
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
        tableViewFeedList.reloadData()
        tableViewFeedList.addRefreshControlForPullToRefresh { [weak self] in
            self?.viewModel.isTripListFetched = false
            self?.stopLoaders()
            self?.getTripListApi(isPullToRefresh: true) // refresh
        }
    }
    
    @IBAction func buttonNotificationTapped(sender:UIButton){
    }
}

//MARK: - TABLEVIEW METHODS
extension FeedHomeVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.viewModel.isTripListFetched else { return 10 }
        return viewModel.arrayOfTripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // show skelton while fetch firsyt time data or refresh data
        guard self.viewModel.isTripListFetched else {
            let cell = tableViewFeedList.dequeueReusableCell(withIdentifier: "SkeletonTripTVCell", for: indexPath) as! SkeletonTripTVCell
            cell.startAnimating(index: indexPath.row)
            return cell
        }

        let cell = self.tableViewFeedList.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        
        cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
        cell.buttonBookmark.tag = indexPath.row
        
        cell.buttonLike.addTarget(self, action: #selector(buttonLikeUnLikedClicked(sender:)), for: .touchUpInside)
        cell.buttonLike.tag = indexPath.row
        
        
//        let txt = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
//        cell.labelExp.text = txt
//        cell.labelExp.isUserInteractionEnabled = true
//
//        if viewModel.arrayOfTripList[indexPath.row].isExpand{
//            cell.labelExp.appendReadmore(after: txt, trailingContent: .readmore)
//        }else{
//            cell.labelExp.appendReadLess(after: txt, trailingContent: .readless)
//        }
        
        cell.configureCell(modelData:viewModel.arrayOfTripList[indexPath.row])

        return cell
    }
    
    @objc func buttonLikeUnLikedClicked(sender:UIButton){
        sender.isSelected.toggle()
        viewModel.arrayOfTripList[sender.tag].isLiked.toggle()
        viewModel.arrayOfTripList[sender.tag].increaeeDecreaseLikeUNLIkeCount()
        let cell = tableViewFeedList.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! FeedTableViewCell
        cell.configureCell(modelData: viewModel.arrayOfTripList[sender.tag])
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        sender.isSelected.toggle()
        viewModel.arrayOfTripList[sender.tag].isBookmarked.toggle()
        viewModel.arrayOfTripList[sender.tag].increaeeDecreaseBookmarkCount()
        let cell = tableViewFeedList.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! FeedTableViewCell
        cell.configureCell(modelData: viewModel.arrayOfTripList[sender.tag])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return !viewModel.isTripListFetched ? 150 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tripPageDetailVC = UIStoryboard.trip.tripPageDetailVC, self.viewModel.arrayOfTripList.indices.contains(indexPath.row){
            tripPageDetailVC.hidesBottomBarWhenPushed = true
            tripPageDetailVC.enumCurrentFlow = .otherUser
            tripPageDetailVC.detailTripDataModel = self.viewModel.arrayOfTripList[indexPath.row]
            self.navigationController?.pushViewController(tripPageDetailVC, animated: true)
        }
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

extension FeedHomeVC{
    /*
     requestJson:{"status":"C","pager":{"pageSize":5,"currentPage":1,"sortField":"CITY","sortOrder":1,"searchValue":""}}
     */
    func getTripListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        guard !self.tableViewFeedList.isAPIstillWorking else { return } // Shouldn't me making another call if already running.
        
        if !isNextPageRequest && !isPullToRefresh{
            // API_LOADER.show(animated: true)
            self.viewModel.isTripListFetched = false // show skeleton
            self.tableViewFeedList.reloadData() // show skeleton
            self.tableViewFeedList.figureOutAndShowNoResults() // don't show no schedule or scene when skeleton is being shown.
        }
        
        var param = viewModel.getPageDict(isPullToRefresh)
            param["searchValue"] = ""
            param["sortField"] = "CITY"
        
        self.tableViewFeedList.isAPIstillWorking = true
        viewModel.getTripListApi(paramDict: ["status":"C", "pager":param], success: { response in
            self.stopLoaders()
        })
    }
    
    func stopLoaders() {
        self.viewModel.isTripListFetched = true
        self.tableViewFeedList.isAPIstillWorking = false
        self.tableViewFeedList.stopPullToRefresh()
        self.tableViewFeedList.reloadData()
        self.tableViewFeedList.figureOutAndShowNoResults()
    }
}

// MARK: - UIScrollViewDelegate
extension FeedHomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            // pagination
            
            if viewModel.getTotalElements > viewModel.getAvailableElements &&
                !self.tableViewFeedList.isAPIstillWorking {
                self.getTripListApi(isNextPageRequest: true, isPullToRefresh: false)
            }
        }
    }
}

extension FeedHomeVC{
    func getSocketTripData(){
        SocketIOManager.sharedInstance.callbackClouserOfTrip = { [weak self] dataModel in
            guard let tripDataModel = dataModel else {
                return
            }
            self?.viewModel.addNewTripInArray(objTripModel: tripDataModel)
            self?.tableViewFeedList.reloadData()
            self?.tableViewFeedList.figureOutAndShowNoResults()
        }
    }
}
