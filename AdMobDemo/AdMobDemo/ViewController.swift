//
//  ViewController.swift
//  AdMobDemo
//
//  Created by Bhargav Kaneriya on 14/05/21.
//


//i - ca-app-pub-7824825343496351/6500942860
//b - ca-app-pub-7824825343496351/4213497359

import UIKit
import GoogleMobileAds

struct AdsIds {
    static let interstitialTestAds = "ca-app-pub-3940256099942544/4411468910"
    static let bannerTestAds = "ca-app-pub-3940256099942544/2934735716"
    
    static let interstitialAds = "ca-app-pub-7824825343496351/6500942860"
    static let bannerAds = "ca-app-pub-7824825343496351/4213497359"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var btnInterstitialAds: UIButton!
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // FOR Banner ADs
        self.setupBannerAds()
        
        // FOR Interstitial ADs
        self.createInterstitial()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func btnInterstitialAdsAction(_ sender: UIButton) {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
}

// ******************************* Banner Ads START ******************************* //

extension ViewController {
    func setupBannerAds() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = AdsIds.bannerTestAds
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([
            NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
             NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
        ])
    }
}

extension ViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    private func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func adViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
// ******************************* Banner Ads END ******************************* //


// ******************************* Interstitial Ads START ******************************* //
extension ViewController {
    func createInterstitial() {
        interstitial = GADInterstitial(adUnitID: AdsIds.interstitialTestAds)
        interstitial!.load(AdMobHelper.createRequest())
        interstitial!.delegate = self
    }
    
    func presentInterstitial() {
        guard let interstitial = self.interstitial, interstitial.isReady else { return }
        DispatchQueue.main.async {
            interstitial.present(fromRootViewController: self)
        }
    }
}

extension ViewController: GADInterstitialDelegate {
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(#function): \(error.localizedDescription)")
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // Recycle interstitial
        createInterstitial()

//        unpauseGame() // Some method from GameViewController
    }

    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
//        pauseGame() // Some method from GameViewController
    }
}

class AdMobHelper {
    static func createRequest() -> GADRequest {
        let request = GADRequest()
        request.testDevices = ["Check this in your logs"]
        return request
    }
}

// ******************************* Interstitial Ads END ******************************* //
