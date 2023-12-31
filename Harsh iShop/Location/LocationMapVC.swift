//
//  LocationMapVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 04/08/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import GooglePlaces
import SwiftyJSON

// protocol used for sending data back
protocol LocationSelectedDelegate: class {
    func locationSelected(strAdress : String , strLat :String , strLong :String)
}


class LocationMapVC: UIViewController {
    
    //MARK: -  @IBOutlet
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblSelectedLocation: UILabel!
    @IBOutlet weak var lblMarkerAddress: UILabel!
    @IBOutlet weak var lblMarkerTitle: UILabel!
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var markerYposition: NSLayoutConstraint!
    @IBOutlet weak var viewBottomLocation: UIView!
    
    
    
    //MARK: -  Properties
    
    weak var delegate: LocationSelectedDelegate? = nil
    
    let placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    
    
    var marrAutoComplete :Array <JSON> = []
    var marrplaceId :Array <JSON> = []
    
    
    var lat : String = ""
    var long : String = ""
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkUsersLocationServicesAuthorization()
        tblSearch.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblSearch.isHidden = true
        txtSearch.delegate = self
        
    }
    
    
    //MARK: -  Buttons Actions
    ion()
                
                let lat = Double("22.3039")
                let lon = Double("70.8022")
                
                let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 10)
                self.mapView.camera = camera
                self.mapView.animate(to: camera)
                
                
                break
            @unknown default:
                print("Default Swich Locatiuon")
            }
        }
    }
    func placeAutocompleteApi() {
        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        placesClient.findAutocompletePredictions(fromQuery: txtSearch.text!, filter: filter, sessionToken: token) { (results, error) in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                
                let dictResponse = JSON(results)
                print(dictResponse)
                
            
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    //                    print(pm.country)
                    //                    print(pm.locality)
                    //                    print(pm.subLocality)
                    //                    print(pm.thoroughfare)
                    //                    print(pm.postalCode)
                    //                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                
                    print(addressString)
                }
        })
        
    }
    
}

extension LocationMapVC : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        tblSearch.isHidden = true
        viewBottomLocation.isHidden =  false
        
        
        self.lat =  "\(String(describing: coordinate.latitude))"
        self.long =  "\(String(describing: coordinate.longitude))"
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
     
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 12)
        mapView.camera = camera
        mapView.animate(to: camera)
        
        getAddressFromLatLon(pdblLatitude: "\(coordinate.latitude)", withLongitude: "\(coordinate.longitude)")
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        lblMarkerTitle.isHidden = true
        lblMarkerAddress.isHidden = true
        
        
        
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.markerYposition.constant = -50
        }) { finished in
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.markerYposition.constant = -20
        }) { finished in
            
        }
        
        getAddressFromLatLon(pdblLatitude: "\(mapView.camera.target.latitude)", withLongitude: "\(mapView.camera.target.longitude)")
        
        
    }
    
}

extension LocationMapVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
     
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude, zoom: 15)
        mapView.camera = camera
        mapView.animate(to: camera)
    }
    
}


extension LocationMapVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        placeAutocompleteApi()
        return true
    }
}
// MARK:  UITableViewDelegate, UITableViewDataSource

extension LocationMapVC : UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amarrAutoComplete.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    // MARK:  Table cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = amarrAutoComplete[indexPath.row].stringValue
        
        cell?.selectionStyle = .none
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        txtSearch.resignFirstResponder()
        
        self.tblSearch.isHidden = true
        
        lblSelectedLocation.text = marrAutoComplete[indexPath.row].stringValue
        lblMarkerAddress.text = marrAutoComplete[indexPath.row].stringValue
        
        
        
        self.placesClient.lookUpPlaceID(marrplaceId[indexPath.row].stringValue) { (response, eror) in
            
            print(response!.coordinate.latitude)
            
            self.lat =  "\(String(describing: response!.coordinate.latitude))"
            self.long =  "\(String(describing: response!.coordinate.longitude))"
            
            self.mapView.clear()
            
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(response!.coordinate.latitude, response!.coordinate.longitude)
            marker.map = self.mapView
            
            let camera = GMSCameraPosition.camera(withLatitude: response!.coordinate.latitude, longitude: response!.coordinate.longitude, zoom: 15.0)
            self.mapView.camera = camera
            self.mapView.animate(to: camera)
            
            
        }
    }
    
}
