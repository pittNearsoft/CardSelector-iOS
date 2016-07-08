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
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var mapPinImage: UIImageView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!

  var locationManager = CLLocationManager()
  let placeViewModel = CCPlaceViewModel()
  
  let searchRadius: Double = 1000
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    setupLocationManager()
  }
  
  //MARK: - Map methods
  func showMapWithLatitude(latitude: Double, longitude: Double, zoom: Float){
    
    mapView.camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: zoom)

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
  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    
    geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
      self.locationLabel.unlock()
      
      if let address = response?.firstResult(){
        self.locationLabel.text = address.lines?.joinWithSeparator("\n")
        
        //this adds padding to the top and bottom of the map.
        //The top padding equals the navigation bar’s height, while the bottom padding equals the label’s height.
        let labelHeight = self.locationLabel.intrinsicContentSize().height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,bottom: labelHeight, right: 0)
        
        UIView.animateWithDuration(0.25, animations: {
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
          self.view.layoutIfNeeded()
        })
        
      }
    }
  }
  
  func fetchNearbyPlacesWithCoordinate(coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    
    placeViewModel.fetchNearbyPlacesWithCoordinate(coordinate, radius: searchRadius, types: CCPlaceType.acceptedTypes,
      completion: { places in
        for place in places{
          let marker = CCPlaceMarker(place: place)
          marker.map = self.mapView
        }
      },
      onError: { error in
        print(error.localizedDescription)
      }
    )
  }
  
  @IBAction func refreshPlaces(sender: AnyObject) {
    fetchNearbyPlacesWithCoordinate(mapView.camera.target)
  }

}

extension PlacesViewController: GMSMapViewDelegate{
  func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
    reverseGeocodeCoordinate(position.target)
  }
  
  func mapView(mapView: GMSMapView, willMove gesture: Bool) {
    locationLabel.lock()
  }
}

extension PlacesViewController: CLLocationManagerDelegate{
  func setupLocationManager() {
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    let coordinate = newLocation.coordinate
    print("latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")
    //configure a default area to get near places
    //let neBoundsCorner = CLLocationCoordinate2D(latitude: coordinate.latitude - 0.1, longitude: coordinate.longitude  - 0.1)
    //let swBoundsCorner = CLLocationCoordinate2D(latitude: coordinate.latitude + 0.1, longitude: coordinate.longitude  + 0.1)
    //let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)
    
    //configureAutoCompleteWithBound(bounds)
    showMapWithLatitude(coordinate.latitude, longitude: coordinate.longitude , zoom: 15)
    self.locationManager.stopUpdatingLocation()
    fetchNearbyPlacesWithCoordinate(coordinate)
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      locationManager.startUpdatingLocation()
      mapView.myLocationEnabled = true
      mapView.settings.myLocationButton = true
    }
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    self.locationManager.stopUpdatingLocation()
    print("Failed to load location. Error: \(error.localizedDescription)")
  }
}
