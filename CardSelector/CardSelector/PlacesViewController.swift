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
import LKAlertController

class PlacesViewController: BaseViewController {

  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var mapPinImage: UIImageView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var slideUpView: SeamlessSlideUpView!
  @IBOutlet var slideUpTableView: SeamlessSlideUpTableView!
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var resultTableView: UITableView!
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var resultView: UIView!
  

  var locationManager = CLLocationManager()
  let placeViewModel = CCPlaceViewModel()
  let suggestionViewModel = CCSuggestionViewModel()
  
  let searchRadius: Double = 1000
  
  var listSuggestions: [CCSuggestion] = []
  
  var fetcher: GMSAutocompleteFetcher?
  var listPlaces: [CCPlace] = []
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    slideUpTableView.dataSource = self
    slideUpTableView.delegate = self
    
    slideUpView.tableView = slideUpTableView
    slideUpView.delegate  = self
    slideUpView.topWindowHeight = self.view.frame.size.height/2
    
    searchTextField.addDoneButtonOnKeyboard()
    searchTextField.delegate = self
    
    searchView.addShadowEffect()
    resultView.addShadowEffect()
    resultView.hidden = true
    
    resultTableView.dataSource = self
    resultTableView.delegate = self
    
    
    mapView.delegate = self
    setupLocationManager()
  }
  
  //MARK: - Map methods
  func showMapWithLatitude(latitude: Double, longitude: Double, zoom: Float, place: CCPlace?){
    
    mapView.camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: zoom)
    if place != nil {
      setMarkerToMapSubViewWithLocation(CLLocationCoordinate2DMake(latitude, longitude), place: place!)
    }

  }
  
  func setMarkerToMapSubViewWithLocation(location: CLLocationCoordinate2D, place: CCPlace) {
    //let camera = GMSCameraPosition.cameraWithLatitude(location.latitude, longitude: location.longitude, zoom: 15)
    mapView.clear()
    let marker = CCPlaceMarker(place: place)
    marker.position = mapView.camera.target
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
  
  func closeListOfSuggestions() {
    
      dispatch_async(dispatch_get_main_queue()) {
        self.slideUpView.hide()
      }
    
    
  }
  
  //MARK: - Autocomplete methods
  func configureAutoCompleteWithBound(bounds: GMSCoordinateBounds?) {
    
    //Set up the autocomplete filter
    let filter = GMSAutocompleteFilter()
    filter.type = .Establishment
    
    //Create the fetcher, engine for autocomplete
    fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
    fetcher?.delegate = self
  }
  

}

extension PlacesViewController: GMSMapViewDelegate{
  func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
    reverseGeocodeCoordinate(position.target)
  }
  
  func mapView(mapView: GMSMapView, willMove gesture: Bool) {
    
    locationLabel.lock()
    if gesture {
      closeListOfSuggestions()
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
      

      infoView.addShadowEffect()
      return infoView
    }
    
    return nil
  }
  
  
  func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
    
    if slideUpView.hidden == false {
      return
    }
    
    slideUpView.show()
    slideUpTableView.lock()
    
    let placeMarker = marker as! CCPlaceMarker
    let user = CCUserViewModel.getLoggedUser()
    suggestionViewModel.getSuggestionsWithUser(user!, merchant: placeMarker.place, completion: { (listSuggestions) in
      
      guard listSuggestions.count > 0 else{
        self.closeListOfSuggestions()
        Alert(title: "Oops!", message: "You have not added any card yet. Please add one first.").showOkay()
        return
      }
      
      self.listSuggestions = listSuggestions
      
      self.slideUpTableView.unlock()
      self.slideUpTableView.reloadData()
    }) { (error) in
      self.slideUpTableView.unlock()
      print(error.localizedDescription)
      self.slideUpView.hide()
      Alert(title: "Oops!", message: "Something went wrong, try again later.").showOkay()
    }
  }
  
  func mapView(mapView: GMSMapView, didCloseInfoWindowOfMarker marker: GMSMarker) {
    closeListOfSuggestions()
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
    
    //configure a default area to get near places
    let neBoundsCorner = CLLocationCoordinate2D(latitude: coordinate.latitude - 0.1, longitude: coordinate.longitude  - 0.1)
    let swBoundsCorner = CLLocationCoordinate2D(latitude: coordinate.latitude + 0.1, longitude: coordinate.longitude  + 0.1)
    let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)
    
    configureAutoCompleteWithBound(bounds)
    
    
    showMapWithLatitude(coordinate.latitude, longitude: coordinate.longitude , zoom: 15, place: nil)
    self.locationManager.stopUpdatingLocation()
    fetchNearbyPlacesWithCoordinate(coordinate)
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
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
    if slideUpTableView ==  tableView {
      return listSuggestions.count
    }else{
      return listPlaces.count
    }
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if slideUpTableView == tableView {
      let cell = tableView.dequeueReusableCellWithIdentifier("suggestionCell", forIndexPath: indexPath) as! SuggestionViewCell
      
      cell.configureWithSuggestion(listSuggestions[indexPath.row])
      
      return cell
    }else{
      let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! ResultViewCell
      
      cell.resultLabel.text = listPlaces[indexPath.row].address
      
      return cell
      
    }
  }
  
}

extension PlacesViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if tableView == resultTableView {
      
      let place = listPlaces[indexPath.row]
      searchTextField.text = place.address
      
      placeViewModel.getGeocodeByPlaceId(listPlaces[indexPath.row].id,
        completion: { (coordinate) in
          //dismiss keyboard
          self.searchTextField.resignFirstResponder()
          
          self.showMapWithLatitude(coordinate.latitude, longitude: coordinate.longitude , zoom: 15, place: place)
          self.mapPinImage.fadeOut(0.25)
        },
        onFailure: { (error) in
          print(error.localizedDescription)
        }
      )
    }
  }
}

extension PlacesViewController: UITextFieldDelegate{
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    mapPinImage.fadeOut(0.25)
//    resultView.showViewAnimated()
    mapView.userInteractionEnabled = false
    return true
  }
  
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    reappearMapPinImage()
    resultView.hideViewAnimated()
    searchTextField.text = ""
    mapView.userInteractionEnabled = true
    return true
  }
  
  func textFieldShouldClear(textField: UITextField) -> Bool {
    reappearMapPinImage()
    resultView.hideViewAnimated()
    mapView.userInteractionEnabled = true
    searchTextField.text = ""
    searchTextField.resignFirstResponder()
    return false
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    resultView.hideViewAnimated()
    mapView.userInteractionEnabled = true
    searchTextField.text = ""
    searchTextField.resignFirstResponder()

    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let text = searchTextField.text!
    let textFieldRange = NSMakeRange(0, text.characters.count)
    
    
    
    if (NSEqualRanges(range, textFieldRange) && string.characters.count == 0) {
      resultView.hideViewAnimated()
    }else{
      resultView.showViewAnimated()
      fetcher?.sourceTextHasChanged(text)
    }

    
    return true
  }
}


//MARK: - Fetcher Methods
extension PlacesViewController: GMSAutocompleteFetcherDelegate{
  func didAutocompleteWithPredictions(predictions: [GMSAutocompletePrediction]) {
    
    listPlaces.removeAll()
    for prediction in predictions {
      listPlaces.append(CCPlace(WithPrediction: prediction))
    }
    resultTableView.reloadData()
  }
  
  func didFailAutocompleteWithError(error: NSError) {
    print(error.localizedDescription)
  }
  
  
}



