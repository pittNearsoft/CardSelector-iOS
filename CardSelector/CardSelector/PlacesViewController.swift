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
import AlamofireImage
import SeamlessSlideUpScrollView

class PlacesViewController: BaseViewController {

  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var mapPinImage: UIImageView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var slideUpView: SeamlessSlideUpView!
  @IBOutlet var slideUpTableView: SeamlessSlideUpTableView!
  

  var locationManager = CLLocationManager()
  let placeViewModel = CCPlaceViewModel()
  let suggestionViewModel = CCSuggestionViewModel()
  
  let searchRadius: Double = 1000
  
  var listSuggestions: [String] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    slideUpTableView.dataSource = self
    
    slideUpView.tableView = slideUpTableView
    slideUpView.delegate  = self
    slideUpView.topWindowHeight = self.view.frame.size.height/2
    
    
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
  
  func reappearMapPinImage() {
    mapPinImage.fadeIn(0.25)
    
    //Setting the map’s selectedMarker to nil will remove the currently presented infoView.
    mapView.selectedMarker = nil
    
  }

}

extension PlacesViewController: GMSMapViewDelegate{
  func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
    reverseGeocodeCoordinate(position.target)
  }
  
  func mapView(mapView: GMSMapView, willMove gesture: Bool) {
    
    locationLabel.lock()
    if gesture {
      dispatch_async(dispatch_get_main_queue()) {
        self.slideUpView.hide()
      }
      reappearMapPinImage()
    }
  }
  

  func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    let placeMarker = marker as! CCPlaceMarker
    placeMarker.tracksInfoWindowChanges = true
    
    if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
      infoView.nameLabel.text = placeMarker.place.name
      
      if infoView.placePhoto.image == nil {
        infoView.placePhoto.image = UIImage(named: "ccGeneric")
        infoView.placePhoto.af_setImageWithURLRequest(CCPlaceRouter.fetchPlacePhotoFromReference(reference: placeMarker.place.photo_reference))
      }
      

      return infoView
    }
    
    return nil
  }
  
  
  func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
    
    slideUpView.show()
    
    let placeMarker = marker as! CCPlaceMarker
    let user = CCUserViewModel.getLoggedUser()
    suggestionViewModel.getSuggestionsWithUser(user!, merchant: placeMarker.place.name, completion: { (listSuggestions) in
      self.listSuggestions = listSuggestions
      self.slideUpTableView.reloadData()
    }) { (error) in
      print(error.localizedDescription)
    }
  }
  
  func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
    mapPinImage.fadeOut(0.25)
    return false
  }
  
  func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
    reappearMapPinImage()
    return false
  }
}

extension PlacesViewController: CLLocationManagerDelegate{
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    let coordinate = newLocation.coordinate
    print("latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")
    
    showMapWithLatitude(coordinate.latitude, longitude: coordinate.longitude , zoom: 15)
    self.locationManager.stopUpdatingLocation()
    fetchNearbyPlacesWithCoordinate(coordinate)
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      //locationManager.startUpdatingLocation()
      mapView.myLocationEnabled = true
      mapView.settings.myLocationButton = true
    }else if status == .Denied{
      performSegueWithIdentifier("enableLocationSegue", sender: self)
    }

  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    self.locationManager.stopUpdatingLocation()
    print("Failed to load location. Error: \(error.localizedDescription)")
  }
}



extension PlacesViewController: SeamlessSlideUpViewDelegate{
  func slideUpViewWillAppear(slideUpView: SeamlessSlideUpView, height: CGFloat) {
    UIView.animateWithDuration(0.3) { [weak self] in self?.view.layoutIfNeeded() }
    //addBlurEffect()
  }
  
  func slideUpViewDidAppear(slideUpView: SeamlessSlideUpView, height: CGFloat) {
  }
  
  func slideUpViewWillDisappear(slideUpView: SeamlessSlideUpView) {
    UIView.animateWithDuration(0.3) { [weak self] in self?.view.layoutIfNeeded() }
    //removeBlurEffect()
  }
  
  func slideUpViewDidDisappear(slideUpView: SeamlessSlideUpView) {
  }
  
  func slideUpViewDidDrag(slideUpView: SeamlessSlideUpView, height: CGFloat) {
    self.view.layoutIfNeeded()
  }
}

extension PlacesViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listSuggestions.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("suggestionCell", forIndexPath: indexPath) as! SuggestionViewCell
    
    cell.suggestionDescription.text = listSuggestions[indexPath.row]
    
    return cell
  }
  
}

