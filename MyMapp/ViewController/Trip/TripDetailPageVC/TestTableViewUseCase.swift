//
//  TestTableViewUseCase.swift
//  MyMapp
//
//  Created by Akash on 09/02/22.
//

import UIKit

class TestTableViewUseCase: UIViewController {

    @IBOutlet weak var tblviewTrip:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuretableVIew()
    }
    
    func configuretableVIew(){
        tblviewTrip.setDefaultProperties(vc: self)
        tblviewTrip.registerCell(type: TripMainPageHeaderCellXIB.self, identifier: TripMainPageHeaderCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageHeaderNameXIB.self, identifier: TripMainPageHeaderNameXIB.identifier)
        tblviewTrip.registerCell(type: TripMainLocationCellXIB.self, identifier: TripMainLocationCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageTopCellXIB.self, identifier: TripMainPageTopCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageCommentsCellXIB.self, identifier: TripMainPageCommentsCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageTableCell.self, identifier: TripMainPageTableCell.identifier)
        if #available(iOS 15.0, *) {
            tblviewTrip.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
//        tblviewTrip.sectionHeaderHeight = 1
//        [self.tableView setSectionHeaderTopPadding:0.0f];

        
    }
}


//MARK: - TABLEVIEW METHODS
extension TestTableViewUseCase:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageTopCellXIB", for: indexPath) as! TripMainPageTopCellXIB
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.11
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let abcview = UIView()
        return abcview
    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView  = UIView()
//        footerView.backgroundColor = .blue
//       return footerView
//   }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1.0
//   }
//
}
