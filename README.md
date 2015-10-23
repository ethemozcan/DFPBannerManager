# DFPBannerManager
Easy implementation of Google DFP Banner. 

## Installation

just add the **DFPBannerManager.swift** file to your project

## Usage

Make sure that you already added Google Mobile Ads framework to your project.
https://developers.google.com/mobile-ads-sdk/docs/dfp/ios/download 

Define **DFPBannerManager** as an instance variable and call managerWithRootViewController(...  method. 


```swift
var DFPManager: DFPBannerManager?

override func viewDidLoad() {
		super.viewDidLoad()
		
		self.DFPManager = DFPBannerManager.managerWithRootViewController(self.navigationController!,
			containerView: (self.navigationController?.view)!,
			loadImmediately: true,
			adUnitID: "ca-mb-app-pub-XXXXXXXXXXXX")
	}
```

If you don't want DFPBannerManager to load banner immediately, you can pass false to loadImmediately parameter and call loadAdBanner() function anytime you want, also you can make your request with loadAdBanner(additionalParameters : [NSObject : AnyObject]) request. 

```swift
	 	// normal
		self.DFPManager?.loadAdBanner()

		// with additional parameters
		self.DFPManager?.loadAdBanner(["testCategory" : "game"])
```

You access some useful info like below; 

```swift
		self.DFPManager?.adViewVisible
		self.DFPManager?.adViewLoaded
		self.DFPManager?.adSize
```



### Delegate Methods

You can handle if banner loaded or failed by delegate methods. Just conform to DFPBannerManagerDelegate protocol. 

```swift
	 func adViewDidReceiveAd(bannerView: GADBannerView!){
	 // Do something 
	}
	 
	func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!){
	// Do something 
	}
```


