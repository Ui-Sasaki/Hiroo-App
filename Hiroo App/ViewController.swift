//
//  ViewController.swift
//  Hiroo App
//
//  Created by ard on 2025/02/19.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func toNEXT() {
        performSegue(withIdentifier: "toNEXT", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNEXT" {
            let mapView = segue.destination as! koishikawamap
        }
    }
}
