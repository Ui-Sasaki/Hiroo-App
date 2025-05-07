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
  var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let hgk = CLLocationCoordinate2DMake(35.728851235181615, 139.7468261848643)
        let region = MKCoordinateRegion(center: hgk, span: span)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.title = "タイトル"
        pin.subtitle = "サブタイトル"
        pin.coordinate = hgk
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


