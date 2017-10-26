//
//  ViewController.swift
//  maps
//
//  Created by kamil on 26/10/2017.
//  Copyright © 2017 kamil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    var myLocationManager : CLLocationManager?
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBAction func stopButtonAction(_ sender: UIButton) {
        myLocationManager?.stopUpdatingLocation()
        stopButton.isEnabled = false
    }
    @IBAction func startButtonAction(_ sender: UIButton) {
        myLocationManager?.startUpdatingLocation()
        stopButton.isEnabled = true
    }
    @IBAction func clearButtonAction(_ sender: UIButton) {
        let allAnnotations = self.myMapView.annotations
        self.myMapView.removeAnnotations(allAnnotations)
    }
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false

        if (CLLocationManager.locationServicesEnabled())
        {
            myLocationManager = CLLocationManager()
            myLocationManager?.delegate = self
            myLocationManager?.requestWhenInUseAuthorization()
            //myLocationManager?.startUpdatingLocation()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let lastLocation = locations.last else {
            return
        }
        print(lastLocation.coordinate)
        print(lastLocation.speed)
        let zoom = lastLocation.speed/1500
        myMapView.setCenter(lastLocation.coordinate, animated: true)
        let span = MKCoordinateSpan(latitudeDelta:  zoom,longitudeDelta: zoom)
        let region = MKCoordinateRegion(center: lastLocation.coordinate,span: span)
        let annotation = MKPointAnnotation()
        annotation.coordinate = lastLocation.coordinate
        myMapView.addAnnotation(annotation)
        
        
        myMapView.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(lastLocation, completionHandler: {(placemarks, error) -> Void in
            print(lastLocation)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0] as CLPlacemark!
                let aa = pm?.administrativeArea as String!
                let saa = pm?.subAdministrativeArea as String!
                let locality = pm?.locality as String!
            
                self.addressLabel.text = "\(aa!), \(saa!), \(locality!)"
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    
    


}

