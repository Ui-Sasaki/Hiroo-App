

//
//  koishikawamap.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/04/23.
//

import UIKit
import MapKit
import CoreLocation

class hiroomap: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextViewDelegate {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var urltextView: UITextView!
  @IBOutlet weak var hibiyalineTextView: UITextView!
    @IBOutlet weak var titletextView: UITextView!
    @IBOutlet weak var bustextView: UITextView!
  
    
  var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titletextView.text = "アクセス"
        titletextView.layer.borderColor = UIColor.gray.cgColor
        titletextView.layer.borderWidth = 1
        titletextView.layer.cornerRadius = 8.0
        titletextView.font = UIFont.systemFont(ofSize: 15)
        titletextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titletextView)
        
        urltextView.layer.borderColor = UIColor.gray.cgColor
        urltextView.layer.borderWidth = 1
        urltextView.layer.cornerRadius = 8.0
        urltextView.font = UIFont.systemFont(ofSize: 15)
        urltextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(urltextView)
        
        hibiyalineTextView.text = "東京メトロ日比谷線 広尾駅下車 4番出口すぐ"
        hibiyalineTextView.layer.borderColor = UIColor.gray.cgColor
        hibiyalineTextView.layer.borderWidth = 1
        hibiyalineTextView.layer.cornerRadius = 8.0
        hibiyalineTextView.font = UIFont.systemFont(ofSize: 15)
        hibiyalineTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hibiyalineTextView)
        
        bustextView.text = "都営バス [品97] 品川駅前-新宿駅西口 [黒77] 目黒駅前-千駄ヶ谷駅前 日赤医療センター下・広尾学園前下車すぐ"
        bustextView.layer.borderColor = UIColor.gray.cgColor
        bustextView.layer.borderWidth = 1
        bustextView.layer.cornerRadius = 8.0
        bustextView.font = UIFont.systemFont(ofSize: 15)
        bustextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bustextView)
        
        NSLayoutConstraint.activate([
            
            titletextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titletextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titletextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titletextView.heightAnchor.constraint(equalToConstant: 21),
            
            hibiyalineTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            hibiyalineTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hibiyalineTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hibiyalineTextView.heightAnchor.constraint(equalToConstant: 21),
            
            bustextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bustextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bustextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bustextView.heightAnchor.constraint(equalToConstant: 21),
            
            urltextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            urltextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urltextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            urltextView.heightAnchor.constraint(equalToConstant: 21),
        ])
        
        let baseString = "これは設定アプリへのリンクを含む文章です。\n\nこちらのリンクはGoogle検索です"
        let attributedString = NSMutableAttributedString(string: baseString)
        mapView.delegate = self
        
        attributedString.addAttribute(.link,
                                            value: "https://www.jorudan.co.jp/",
                                            range: NSString(string: baseString).range(of: "乗車案内"))
              
        urltextView.attributedText = attributedString
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let hg = CLLocationCoordinate2DMake(35.654674743683124, 139.72223883698695)
        let region = MKCoordinateRegion(center: hg, span: span)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.title = "広尾学園"
        pin.subtitle = "hiroo gakuen"
        pin.coordinate = hg
        mapView.addAnnotation(pin)
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





