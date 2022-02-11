//
//  UIStoryboard+Controllers.swift
//  BaseProject
//
//  Created by MAC240 on 04/06/18.
//  Copyright © 2018 MAC240. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static var authentication: UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: nil)
    }

    static var tabbar: UIStoryboard {
        return UIStoryboard(name: "Tabbar", bundle: nil)
    }

    static var trip: UIStoryboard {
        return UIStoryboard(name: "Trip", bundle: nil)
    }

    static var search: UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }
}

extension UIStoryboard {
    
    var firstViewVC: FirstViewVC? {
        return getViewController(vcClass: FirstViewVC.self)
    }
    
    var onboardingObjVC: OnboardingVC? {
        return getViewController(vcClass: OnboardingVC.self)
    }

    var profilePhotoUploadVC: ProfilePhotoUploadVC? {
        return getViewController(vcClass: ProfilePhotoUploadVC.self)
    }
    
    var personalDetailsVC: PersonalDetailsVC? {
        return getViewController(vcClass: PersonalDetailsVC.self)
    }

    var signinVC: SigninVC? {
        return getViewController(vcClass: SigninVC.self)
    }
    
    var forgotPasswordVC: ForgotPasswordVC? {
        return getViewController(vcClass: ForgotPasswordVC.self)
    }

    var locationServicesVC: LocationServicesVC? {
        return getViewController(vcClass: LocationServicesVC.self)
    }

    var signupVC: SignupVC? {
        return getViewController(vcClass: SignupVC.self)
    }    

    var addTripInfoVC: AddTripInfoVC? {
        return getViewController(vcClass: AddTripInfoVC.self)
    }

    var tripAddedSuccessFullVC: TripAddedSuccessFullVC? {
        return getViewController(vcClass: TripAddedSuccessFullVC.self)
    }
    
    var addTripHomeVC: AddTripHomeVC? {
        return getViewController(vcClass: AddTripHomeVC.self)
    }
    
    
    var addTripSecondStepVC: AddTripSecondStepVC? {
        return getViewController(vcClass: AddTripSecondStepVC.self)
    }

    var addTripFavouriteLocationsVC: AddTripFavouriteLocationsVC? {
        return getViewController(vcClass: AddTripFavouriteLocationsVC.self)
    }
    
    var tripPageDetailVC: TripDetailVC? {
        return getViewController(vcClass: TripDetailVC.self)
    }
    

    var tripPhotoExpansionDetailsVC: TripPhotoExpansionDetailsVC? {
        return getViewController(vcClass: TripPhotoExpansionDetailsVC.self)
    }

    var latestTripVC: LatestTripVC? {
        return getViewController(vcClass: LatestTripVC.self)
    }

    var tripImagesUploadVC: TripImagesUploadVC? {
        return getViewController(vcClass: TripImagesUploadVC.self)
    }

    var testTableViewUseCase: TestTableViewUseCase? {
        return getViewController(vcClass: TestTableViewUseCase.self)
    }

    
    
    
    func getViewController<T: UIViewController>(vcClass: T.Type) -> T? {
        guard let viewController = instantiateViewController(withIdentifier: vcClass.className()) as? T else {
            return nil
        }
        return viewController
    }
}
