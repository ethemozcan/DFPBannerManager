//
//  DFPBannerManager.swift
//
//  Created by Ethem Ozcan on 23/10/15.
//  Copyright © 2015 Ethem Ozcan. All rights reserved.
//

import UIKit
import GoogleMobileAds

public protocol DFPBannerManagerDelegate{
	func adViewDidReceiveAd(bannerView: GADBannerView!)
	func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!)
}

class DFPBannerManager: NSObject, GADBannerViewDelegate{

	var delegate : DFPBannerManagerDelegate?
	private(set) var adViewVisible : Bool = false
	private(set) var adViewLoaded : Bool = false
	private(set) var adSize : CGSize = CGSizeZero

	private var adView : DFPBannerView = DFPBannerView(adSize: kGADAdSizeBanner)
	private var adViewHolder : UIView = UIView(frame: CGRectZero)
	private var adViewBottomConstraint : NSLayoutConstraint = NSLayoutConstraint()
	private var rootViewController : UIViewController
	private var adUnitID : String
	private var additionalParameters : [NSObject : AnyObject]?

	// MARK: - Class
	static func managerWithRootViewController(rootViewController: UIViewController, containerView : UIView, loadImmediately : Bool, adUnitID : String) -> DFPBannerManager{
		let manager = DFPBannerManager(rootViewController: rootViewController, adUnitID: adUnitID)
		if loadImmediately{
			manager.customizeDFPBanerWithContainerView(containerView)
			manager.loadAdBanner()
		}
		return manager
	}

	private init(rootViewController : UIViewController, adUnitID : String){
		self.rootViewController = rootViewController
		self.adUnitID = adUnitID
		super.init()
	}

	// MARK: - Banner
	private func customizeDFPBanerWithContainerView(containerView : UIView){

		// Create Holder
		containerView.addSubview(adViewHolder)

		// Intialize Holder constraints
		adViewHolder.translatesAutoresizingMaskIntoConstraints = false
		adViewBottomConstraint = NSLayoutConstraint(item: adViewHolder, attribute: .Bottom, relatedBy: .Equal,
			toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0)

		let holderConstraints : [NSLayoutConstraint] = [
			NSLayoutConstraint(item: adViewHolder,
				attribute: .Leading,
				relatedBy: .Equal,
				toItem: containerView,
				attribute: .Leading,
				multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: adViewHolder,
				attribute: .Trailing,
				relatedBy: .Equal,
				toItem: containerView,
				attribute: .Trailing,
				multiplier: 1.0,
				constant: 0),
			adViewBottomConstraint
		]
		containerView.addConstraints(holderConstraints)


		// Create Banner
		adViewHolder.addSubview(adView)


		// Intialize Banner constraints
		adView.translatesAutoresizingMaskIntoConstraints = false
		let adViewConstraints : [NSLayoutConstraint] = [
			NSLayoutConstraint(item: adView,
				attribute: .Top,
				relatedBy: .Equal,
				toItem: adView,
				attribute: .Top,
				multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: adView,
				attribute: .CenterX,
				relatedBy: .Equal,
				toItem: adViewHolder,
				attribute: .CenterX,
				multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: adView,
				attribute: .Bottom,
				relatedBy: .Equal,
				toItem: adViewHolder,
				attribute: .Bottom,
				multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: adView,
				attribute: .Width,
				relatedBy: .Equal,
				toItem: nil,
				attribute: .NotAnAttribute,
				multiplier: 1.0, constant: 320)
		]

		adViewHolder.addConstraints(adViewConstraints)
	}

	func showBannerView(){
		adViewVisible = true
		adViewHolder.layoutIfNeeded()
		adViewBottomConstraint.constant = 0.0

		UIView.animateWithDuration(0.3,
			delay: 0.0,
			options: .CurveEaseInOut,
			animations: { () -> Void in
				self.adViewHolder.layoutIfNeeded()
			}, completion: nil)
	}

	func hideBannerView(){
		adViewVisible = false
		adViewHolder.layoutIfNeeded()
		adViewBottomConstraint.constant = adSize.height

		UIView.animateWithDuration(0.3,
			delay: 0.0,
			options: .CurveEaseInOut,
			animations: { () -> Void in
				self.adViewHolder.layoutIfNeeded()
			}, completion: nil)
	}

	func loadAdBanner(){
		additionalParameters = nil
		adView.adUnitID = adUnitID
		adView.rootViewController = rootViewController
		adView.delegate = self
		DFPRequest()
	}

	func loadAdBanner(additionalParameters : [NSObject : AnyObject]){
		self.additionalParameters = additionalParameters
		adView.adUnitID = adUnitID
		adView.rootViewController = rootViewController
		adView.delegate = self
		DFPRequest()
	}

	private func DFPRequest(){
		let request = GADRequest()
		request.testDevices = [ kDFPSimulatorID ]

		if let additionalParameters = additionalParameters{
			let extras = GADExtras()
			extras.additionalParameters = additionalParameters
			request.registerAdNetworkExtras(extras)
		}

		adView.loadRequest(request)
	}


	// MARK: - GADBannerViewDelegate
	func adViewDidReceiveAd(bannerView: GADBannerView!) {
		adViewLoaded = true
		showBannerView()
		adSize = bannerView.bounds.size
		delegate?.adViewDidReceiveAd(bannerView)
	}

	func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
		adViewLoaded = false
		hideBannerView()
		delegate?.adView(bannerView, didFailToReceiveAdWithError: error)
	}
}
