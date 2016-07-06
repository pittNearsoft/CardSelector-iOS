//
//  PlacesViewController.swift
//  CardSelector
//
//  Created by projas on 7/4/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class PlacesViewController: UIViewController {

  @IBOutlet weak var mapView: GMSMapView!
  var locationManager: CLLocationManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.

    
    setupLocationManager()
  }
  
  //MARK: - Map methods
  func showMapWithLatitude(latitude: Double, longitude: Double, zoom: Float,  enablePosition: Bool){
    
    let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: zoom)
    if enablePosition {
      setMarkerToMapSubViewWithLocation(CLLocationCoordinate2DMake(latitude, longitude), address: "")
    }
    mapView.camera = camera
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  func setMarkerToMapSubViewWithLocation(location: CLLocationCoordinate2D, address: String) {
    let camera = GMSCameraPosition.cameraWithLatitude(location.latitude, longitude: location.longitude, zoom: 15)
    mapView.clear()
    let marker = GMSMarker()
    marker.position = camera.target
    marker.title = address
    marker.snippet = address
    marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
  }
}

extension PlacesViewController: CLLocationManagerDelegate{
  func setupLocationManager() {
    self.locationManager = CLLocationManager()
    self.locationManager!.delegate = self
    self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager!.requestWhenInUseAuthorization()
    self.locationManager!.startUpdatingLocation()
    
    self.locationManager?.startUpdatingLocation()
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    let coordinate = newLocation.coordinate
    
    //configure a default area to get near places
    let neBoundsCorner = CLLocationCoordinate2D(latitude: coordinate.latitude - 0.1, longitude: coordinate.longitude  - 0.1)
    let swBoundsCorner = CLLocationCoordinate2D(latitude: coordinate.latitude + 0.1, longitude: coordinate.longitude  + 0.1)
    let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)
    
    //configureAutoCompleteWithBound(bounds)
    showMapWithLatitude(coordinate.latitude, longitude: coordinate.longitude , zoom: 15, enablePosition: false)
    self.locationManager?.stopUpdatingLocation()
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    self.locationManager?.stopUpdatingLocation()
    print("Failed to load location. Error: \(error.localizedDescription)")
  }
}
