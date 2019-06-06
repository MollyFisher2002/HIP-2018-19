//
//  ViewController.swift
//  Hip
//
//  Created by Kids Macbook on 10/9/18.
//  Copyright © 2018 Molly. All rights reserved.
//

import UIKit
import GoogleMaps
class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate{
    //var destinationText = UITextField()
   @IBOutlet weak var destinationText: UITextField!
   @IBOutlet weak var mapView: GMSMapView!
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        print("inside view did load")
        
        GMSServices.provideAPIKey("AIzaSyBInUoQmIaXF9tyQ_vAWY4uchKJaBcLWf8")
        super.viewDidLoad()
        mapView.isMyLocationEnabled=true
        mapView.delegate=self
        destinationText.delegate = self
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last

        self.currentLatitude = (location?.coordinate.latitude)!
        self.currentLongitude = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude : (location?.coordinate.longitude)!,zoom:14)
        mapView.animate(to: camera)
        
        //Finally stop updating loaction otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("User Destination \(String(describing: textField.text))")
        destinationText.resignFirstResponder()
        return true
    
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("User Destination \(String(describing: textField.text))")
        destinationText.resignFirstResponder()
        var address_escaped =  textField.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        var url = "https://maps.googleapis.com/maps/api/geocode/json?" + "address=" + address_escaped! + "&key=AIzaSyBInUoQmIaXF9tyQ_vAWY4uchKJaBcLWf8"
        let geocodeurl = NSURL(string: url )
        let urlresult = NSData(contentsOf: geocodeurl! as URL)
        do{
        var jsonResult = try JSONSerialization.jsonObject(with: urlresult! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
              print(jsonResult as Any)
           let status = jsonResult["status"] as! String
            if status == "OK" {
               let allResults = jsonResult["results"] as! Array<NSDictionary>
                //var lookupAddressResults: Dictionary<NSObject, AnyObject>!
                var lookupAddressResults = allResults[0]
                let geometry = lookupAddressResults.object(forKey: "geometry") as! NSDictionary
                    //lookupAddressResults["geometry"] as NSDictionary
                var location = geometry.object(forKey: "location") as! NSDictionary
               var fetchedAddressLongitude = location.object(forKey: "lng") as! Double
                var fetchedAddressLatitude = location.object(forKey: "lat") as! Double
               
            }
        }
        catch {}
        //get directions
        url = "https://maps.googleapis.com/maps/api/directions/json?" + "origin=" + self.currentLatitude + "," + self.currentLongitude +  "&key=AIzaSyBInUoQmIaXF9tyQ_vAWY4uchKJaBcLWf8"
        
    }
    
    
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//
//        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
//

}
