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
    var isShowWholeContent = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        getSocketTripData()
        
        API_LOADER.SHOW_CUSTOM_LOADER()
//        self.getTripListApi()
//        SHOW_CUSTOM_LOADER()
        DispatchQueue.getMain(delay: 0.2) {
            self.getTagData()
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reCallTripListApi), name: Notification.Name("reloadUserTripList"), object: nil) //
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
    }//
    
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
        
        self.viewModel.isTripListFetched = true
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
        
        cell.configureCell(modelData:viewModel.arrayOfTripList[indexPath.row])
//        let str = "The city is very vibrant at night, especially in summerThe city is very vibrant at night, especially in summerThe city is very vibrant at night, especially in summer"//viewModel.arrayOfTripList[indexPath.row].tripDescription
        let str = viewModel.arrayOfTripList[indexPath.row].tripDescription//

        if str.isEmpty {
            cell.labelExpDescription.isHidden = true
        } else {
            cell.labelExpDescription.isHidden = false
            cell.labelExpDescription.isShowWholeContent = isShowWholeContent
            cell.labelExpDescription.readLessText = " " + "see less"
            cell.labelExpDescription.readMoreText = " " + "see more"
            cell.labelExpDescription.isOneLinedContent = true
            cell.labelExpDescription.setContent(str, noOfCharacters: 35, readMoreTapped: {
                self.isShowWholeContent = true
                self.tableViewFeedList.reloadData()
            }) {
                self.isShowWholeContent = false
                self.tableViewFeedList.reloadData()
            }
        }
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
        return !viewModel.isTripListFetched ? 210 : UITableView.automaticDimension
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


extension FeedHomeVC{
    /*
     requestJson:{"status":"C","pager":{"pageSize":5,"currentPage":1,"sortField":"CITY","sortOrder":1,"searchValue":""}}
     */
    func getTripListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        guard !self.tableViewFeedList.isAPIstillWorking else { return } // Shouldn't me making another call if already running.
        
        if !isNextPageRequest && !isPullToRefresh{
            // API_LOADER.show(animated: true)
//            self.viewModel.isTripListFetched = false // show skeleton
//            self.tableViewFeedList.reloadData() // show skeleton
//            self.tableViewFeedList.figureOutAndShowNoResults() // don't show no schedule or scene when skeleton is being shown.
        }
        
        var param = viewModel.getPageDict(isPullToRefresh)
            param["searchValue"] = ""
            param["sortField"] = "CITY"
        
        self.tableViewFeedList.isAPIstillWorking = true
        viewModel.getTripListApi(paramDict: ["status":"C", "pager":param], success: { response in
            self.stopLoaders()
            self.loadTagArray()
        })
    }
    
    func stopLoaders() {
        API_LOADER.HIDE_CUSTOM_LOADER()
        self.viewModel.isTripListFetched = true
        self.tableViewFeedList.isAPIstillWorking = false
        self.tableViewFeedList.stopPullToRefresh()
        self.tableViewFeedList.reloadData()
        self.tableViewFeedList.figureOutAndShowNoResults()
    }
    
    func loadTagArray() {
        self.viewModel.arrayOfTripList.forEach { objTrip in
            objTrip.locationList.forEach { objLocation in
                let primaryTags = objLocation.firstTagFeed.components(separatedBy: ",").map({ Int($0) })
                let secondaryTags = objLocation.secondTagFeed.components(separatedBy: ",").map({ Int($0) })
                appDelegateShared.tagsData.forEach { parentTag in
                    if primaryTags.contains(parentTag.id) {
                        objLocation.arrayTagsFeed.append(parentTag.name)

                        parentTag.subTagsList.forEach { subTag in
                            if secondaryTags.contains(subTag.id) {
                                objLocation.arrayTagsFeed.append(subTag.name)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getTagData(){
        API_SERVICES.callAPI([:], path: .getTags, method: .get) { [weak self] dataResponce in
            
//            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200, let listArray =  dataResponce?["responseJson"]?["tagList"].arrayObject else {
                return
            }
            
            appDelegateShared.tagsData.removeAll()
            listArray.forEach { (singleObj) in
                let sampleModel = TagListModel(fromJson: JSON(singleObj))
                appDelegateShared.tagsData.append(sampleModel)
            }
            
            self?.getTripListApi()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            API_LOADER.HIDE_CUSTOM_LOADER()
//            self.HIDE_CUSTOM_LOADER()
        }
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
