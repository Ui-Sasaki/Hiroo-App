//
//  koishikawamap.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/04/23.
//

import UIKit
import MapKit
import CoreLocation

class koishikawamap: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("位置情報の使用が制限または拒否されています")
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("現在地：\(location.coordinate.latitude), \(location.coordinate.longitude)")
        // ここで地図にピンを立てたり、表示位置を更新したりできます
    }
}
