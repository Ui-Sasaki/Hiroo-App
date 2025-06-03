//
//  koishikawamap.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/04/23.
//

import UIKit
import MapKit
import CoreLocation

class koishikawamap: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urltextView: UILabel!
    @IBOutlet weak var mitalinetextView: UILabel!
    @IBOutlet weak var titletextView: UILabel!
    @IBOutlet weak var bustextView: UILabel!
  
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up constraints (commented out sections can be uncommented if needed)
        NSLayoutConstraint.activate([
            // Uncomment these if you want to programmatically set constraints
            /*
            titletextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titletextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titletextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titletextView.heightAnchor.constraint(equalToConstant: 21),
            
            mitalinetextView.topAnchor.constraint(equalTo: titletextView.bottomAnchor, constant: 10),
            mitalinetextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mitalinetextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mitalinetextView.heightAnchor.constraint(equalToConstant: 21),
            
            bustextView.topAnchor.constraint(equalTo: mitalinetextView.bottomAnchor, constant: 10),
            bustextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bustextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bustextView.heightAnchor.constraint(equalToConstant: 21),
            
            urltextView.topAnchor.constraint(equalTo: bustextView.bottomAnchor, constant: 10),
            urltextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urltextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            urltextView.heightAnchor.constraint(equalToConstant: 21),
            */
        ])
        
        // Set up the URL text with attributed string
        let baseString = "これは設定アプリへのリンクを含む文章です。\n\n乗車案内はこちらのリンクです"
        let attributedString = NSMutableAttributedString(string: baseString)
        
        // Add link attribute to specific text
        if let range = baseString.range(of: "乗車案内") {
            let nsRange = NSRange(range, in: baseString)
            attributedString.addAttribute(.link,
                                        value: "https://www.jorudan.co.jp/",
                                        range: nsRange)
        }
        
        // For UILabel, you need to enable user interaction to make links tappable
        urltextView.attributedText = attributedString
        urltextView.isUserInteractionEnabled = true
        
        // Add tap gesture to handle link taps
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:)))
        urltextView.addGestureRecognizer(tapGesture)
        
        // Set up map
        mapView.delegate = self
        
        // Set up location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        // Set up map region and annotation
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let hgk = CLLocationCoordinate2DMake(35.728851235181615, 139.7468261848643)
        let region = MKCoordinateRegion(center: hgk, span: span)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.title = "広尾学園小石川"
        pin.subtitle = "hiroo gakuen koishikawa"
        pin.coordinate = hgk
        mapView.addAnnotation(pin)
    }
    
    @objc func handleLinkTap(_ gesture: UITapGestureRecognizer) {
        // Handle the link tap - open URL
        if let url = URL(string: "https://www.jorudan.co.jp/") {
            UIApplication.shared.open(url)
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                let url = userActivity.webpageURL else {
            return true
        }
        // 任意の画面に遷移させるなどの処理を書く
        return true
    }
}
