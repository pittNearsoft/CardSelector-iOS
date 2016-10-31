//
//  PlacesViewController.swift
//  CardSelector
//
//  Created by projas on 7/4/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AlamofireImage
import SeamlessSlideUpScrollView
import LKAlertController
import Crashlytics

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
    resultView.isHidden = true
    
    resultTableView.dataSource = self
    resultTableView.delegate = self
    
    
    mapView.delegate = self
    setupLocationManager()
  }
  
  //MARK: - Map methods
  func showMapWithLatitude(latitude: Double, longitude: Double, zoom: Float, place: CCPlace?){
    
    mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
    if place != nil {
      setMarkerToMapSubViewWithLocation(location: CLLocationCoordinate2DMake(latitude, longitude), place: place!)
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
        self.locationLabel.text = address.lines?.joined(separator: "\n")
        
        //this adds padding to the top and bottom of the map.
        //The top padding equals the navigation bar’s height, while the bottom padding equals the label’s height.
        let labelHeight = self.locationLabel.intrinsicContentSize.height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,bottom: labelHeight, right: 0)
        
        UIView.animate(withDuration: 0.25, animations: {
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
          self.view.layoutIfNeeded()
        })
        
      }
    }
  }
  
  func fetchNearbyPlacesWithCoordinate(coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    
    placeViewModel.fetchNearbyPlacesWithCoordinate(coordinate: coordinate, radius: searchRadius, types: CCPlaceType.acceptedTypes,
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
    fetchNearbyPlacesWithCoordinate(coordinate: mapView.camera.target)
  }
  
  func reappearMapPinImage() {
    mapPinImage.fadeIn(duration: 0.25)
    
    //Setting the map’s selectedMarker to nil will remove the currently presented infoView.
    mapView.selectedMarker = nil
    
  }
  
  func closeListOfSuggestions() {
    
    DispatchQueue.main.async {
      self.slideUpView.hide()
    }
    
    
  }
  
  func showSuggestionsWithPlace(place: CCPlace) {
    if slideUpView.isHidden {
      slideUpView.show()
    }
    
    
    slideUpTableView.lock()
    
    let user = CCUserViewModel.getLoggedUser()
    suggestionViewModel.getSuggestionsWithUser(user: user!, merchant: place, completion: { (listSuggestions) in
      
      guard listSuggestions.count > 0 else{
        self.closeListOfSuggestions()
        Alert(title: "Oops!", message: "You have not added any card yet. Please add one first.").showOkay()
        return
      }
      
      self.listSuggestions = listSuggestions
      
      
      listSuggestions.forEach({ (suggestion) in
        Answers.logCustomEvent(withName: "List of suggestions", customAttributes: [
          "Suggestion Message": suggestion.message,
          "Bank": suggestion.bankName
          ])
      })
      
      self.slideUpTableView.unlock()
      self.slideUpTableView.reloadData()
    }) { (error) in
      self.slideUpTableView.unlock()
      print(error.localizedDescription)
      self.slideUpView.hide()
      Alert(title: "Oops!", message: "Something went wrong, try again later.").showOkay()
    }
  }
  
  func showMarkerInfoWindowWithPlace(place: CCPlace) {
    let marker = CCPlaceMarker(place: place)
    marker.map = mapView
    marker.position = mapView.camera.target
    mapView.selectedMarker = marker
    _ = mapView(mapView, markerInfoWindow: mapView.selectedMarker!)
  }
  
  //MARK: - Autocomplete methods
  func configureAutoCompleteWithBound(bounds: GMSCoordinateBounds?) {
    
    //Set up the autocomplete filter
    let filter = GMSAutocompleteFilter()
    filter.type = .establishment
    
    //Create the fetcher, engine for autocomplete
    fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
    fetcher?.delegate = self
  }
  

}

extension PlacesViewController: GMSMapViewDelegate{
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocodeCoordinate(coordinate: position.target)
  }
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    
    locationLabel.lock()
    if gesture {
      closeListOfSuggestions()
      reappearMapPinImage()
    }
  }
  

  func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    let placeMarker = marker as! CCPlaceMarker
    placeMarker.tracksInfoWindowChanges = true
    
    if let infoView = UIView.viewFromNibName(name: "MarkerInfoView") as? MarkerInfoView {
      infoView.nameLabel.text = placeMarker.place.name
      
      if infoView.placePhoto.image == nil {
        infoView.placePhoto.image = UIImage(named: "ccGeneric")
        infoView.placePhoto.af_setImage(withURLRequest: CCPlaceRouter.fetchPlacePhotoFromReference(reference: placeMarker.place.photo_reference))
      }
      

      infoView.addShadowEffect()
      
      return infoView
    }
    
    
    
    return nil
  }
  
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    if slideUpView.isHidden == false {
      return
    }
    
    
    
    let placeMarker = marker as! CCPlaceMarker
    
    Answers.logCustomEvent(withName: "Place selected", customAttributes: ["Place": placeMarker.place.name])
    
    showSuggestionsWithPlace(place: placeMarker.place)
  }
  
  func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
    closeListOfSuggestions()
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapPinImage.fadeOut(duration: 0.25)
    return false
  }
  
  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
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
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let coordinate = locations.first?.coordinate {
      print("latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")
      
      //configure a default area to get near places
      let bounds = GMSCoordinateBounds(region: GMSVisibleRegion(nearLeft: coordinate, nearRight: coordinate, farLeft: coordinate, farRight: coordinate))
      
      configureAutoCompleteWithBound(bounds: bounds)
      
      
      showMapWithLatitude(latitude: coordinate.latitude, longitude: coordinate.longitude , zoom: 15, place: nil)
      self.locationManager.stopUpdatingLocation()
      fetchNearbyPlacesWithCoordinate(coordinate: coordinate)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = true
    }else if status == .denied{
      performSegue(withIdentifier: "enableLocationSegue", sender: self)
    }

  }
  
  private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    self.locationManager.stopUpdatingLocation()
    print("Failed to load location. Error: \(error.localizedDescription)")
  }
}



extension PlacesViewController: SeamlessSlideUpViewDelegate{
  func slideUpViewWillAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
    UIView.animate(withDuration: 0.3) { [weak self] in self?.view.layoutIfNeeded() }
    //addBlurEffect()
  }
  
  func slideUpViewDidAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
  }
  
  func slideUpViewWillDisappear(_ slideUpView: SeamlessSlideUpView) {
    UIView.animate(withDuration: 0.3) { [weak self] in self?.view.layoutIfNeeded() }
    //removeBlurEffect()
  }
  
  func slideUpViewDidDisappear(_ slideUpView: SeamlessSlideUpView) {
  }
  
  func slideUpViewDidDrag(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
    self.view.layoutIfNeeded()
  }
}

extension PlacesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if slideUpTableView ==  tableView {
      return listSuggestions.count
    }else{
      return listPlaces.count
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if slideUpTableView == tableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath) as! SuggestionViewCell
      
      cell.configureWithSuggestion(suggestion: listSuggestions[indexPath.row])
      
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultViewCell
      
      cell.resultLabel.text = listPlaces[indexPath.row].address
      
      return cell
      
    }
  }
}

extension PlacesViewController: UITableViewDelegate{

  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if tableView == resultTableView {
      
      let place = listPlaces[indexPath.row]
      searchTextField.text = place.address
      
      placeViewModel.getGeocodeByPlaceId(placeId: listPlaces[indexPath.row].id,
                                         completion: { (coordinate) in
          //dismiss keyboard
          self.searchTextField.resignFirstResponder()
          
          self.showMapWithLatitude(latitude: coordinate.latitude, longitude: coordinate.longitude , zoom: 15, place: place)
          self.showSuggestionsWithPlace(place: place)
          self.mapPinImage.fadeOut(duration: 0.25)
          self.showMarkerInfoWindowWithPlace(place: place)
                                          
                                          
                                          
        },
         onFailure: { (error) in
          print(error.localizedDescription)
        }
      )
    }
  }
}

extension PlacesViewController: UITextFieldDelegate{
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    mapPinImage.fadeOut(duration: 0.25)
    mapView.isUserInteractionEnabled = false
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    reappearMapPinImage()
    resultView.hideViewAnimated()
    searchTextField.text = ""
    mapView.isUserInteractionEnabled = true
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    reappearMapPinImage()
    resultView.hideViewAnimated()
    mapView.isUserInteractionEnabled = true
    searchTextField.text = ""
    searchTextField.resignFirstResponder()
    return false
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    resultView.hideViewAnimated()
    mapView.isUserInteractionEnabled = true
    searchTextField.text = ""
    searchTextField.resignFirstResponder()

    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
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

  
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    listPlaces.removeAll()
    for prediction in predictions {
      listPlaces.append(CCPlace(WithPrediction: prediction))
    }
    resultTableView.reloadData()
  }
  

  
  func didFailAutocompleteWithError(_ error: Error) {
    print(error.localizedDescription)
  }
  
  
}



