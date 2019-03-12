//
//  SearchViewController.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-16.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    //TODO: - fix it
    var searchParameter: String?
    var currentLocation: CLLocationCoordinate2D?
    
    // default
    var radius: Int = 10
    var rankBy: String = RankBy.prominence.description()
    var isOpen: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        searchTextField.delegate = self
    }
    
    @IBAction func loadLastSavedResults(_ sender: UIButton) {
        guard let places = loadPlacesFromLocalStorage() else {
            presentErrorAlert(message: "No Result Were Stored!")
            return
        }
        presentSearchResults(places: places)
        
    }
    // Mark: - Main Activity
    
    func showActivityIndicator() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchButton.isEnabled = false
        
    }
    
    func hideActivityIndicator() {
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        searchButton.isEnabled = true
        
    }
    @IBAction func presentFilter(_ sender: UIButton) {
//        performSegue(withIdentifier: "FiltersSegue", sender: self)
        
        guard let filtersViewController = UIStoryboard(name: "Filters", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController else { return }
        
        filtersViewController.delegate = self
        filtersViewController.rankBy = rankBy
        filtersViewController.isOpen = isOpen
        filtersViewController.radius = radius
        present(filtersViewController, animated: true, completion: nil)

    }
    
    @IBAction func segmentedObserver(_ sender: UISegmentedControl) {
        
        print("segmented control option was changed to \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 1 {
            LocationService.shared.startUpdatingLocation()
            LocationService.shared.delegate = self
        }
        
    }
    
    
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        // TODO: radius and rankby open-now
        print("Search Button Tapped")
        guard let query = searchTextField.text else {
            print("Query is Nil")
            return
        }
        
        searchTextField.resignFirstResponder() //Keyboard Hiding!
        showActivityIndicator()
        
        switch segmentControl.selectedSegmentIndex{
        case 0:
            GooglePlacesAPI.requestPlaces(radius: radius, opennow: isOpen, query) { (status, json) in
                print(json ?? "")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                guard let jsonObj = json else { return }
                
                let results = APIParser.parseNearbySearchResults(jsonObj: jsonObj)
                self.savePlacesToLocalStorage(places: results)
                
                if results.isEmpty {
                    // make it run in main thread
                    DispatchQueue.main.async {
                        self.presentErrorAlert(message: "No results")
                    }
                } else {
                    self.presentSearchResults(places: results)
                }
            }
        case 1:
            guard let location = currentLocation else { return }
            GooglePlacesAPI.requestPlacesNearby(for: location, radius: radius, rankby: rankBy.lowercased(), opennow: isOpen, query) { (status, json) in
                print(json ?? "")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                guard let jsonObj = json else { return }
                
                let results = APIParser.parseNearbySearchResults(jsonObj: jsonObj)
                
                self.savePlacesToLocalStorage(places: results)
                if results.isEmpty {
                    // make it run in main thread
                    DispatchQueue.main.async {
                        self.presentErrorAlert(message: "No results")
                    }
                } else {
                    self.presentSearchResults(places: results)
                }
            }
        default:
            break
        }
        
    }
    
    func presentSearchResults(places: [PlaceDetails]){
        guard let searchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController else { return }
        
        searchResultsViewController.places = places
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        }
    }
    
    func presentErrorAlert(title: String = "Error", message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    // Mark: - NSCoding
    func savePlacesToLocalStorage(places: [PlaceDetails]) {
        //save data to the local storage
        NSKeyedArchiver.archiveRootObject(places, toFile: Constants.ArchiveURL.path)
    }
    
    func loadPlacesFromLocalStorage() -> [PlaceDetails]? {
        //pull data from the local storage
        return NSKeyedUnarchiver.unarchiveObject(withFile: Constants.ArchiveURL.path) as? [PlaceDetails]
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchTextField.resignFirstResponder()
            print("textFieldShouldReturn")
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTextField{
            searchParameter = textField.text
            print(textField.text ?? "Nil")
        }
    }
    
}

extension SearchViewController: LocationServiceDelegate {
    func didUpdateLocation(location: CLLocation) {
        print("Latitude \(location.coordinate.latitude) longitute \(location.coordinate.longitude)")
        currentLocation = location.coordinate
    }
    
    
}

extension SearchViewController: FilterServiceDelegate {
    func didUpdateFilter(radius: Int, rankBy: String, isOpen: Bool) {
        self.radius = radius
        self.rankBy = rankBy
        self.isOpen = isOpen
        if radius == 10 && rankBy == RankBy.prominence.description() && isOpen {
            filterButton.setImage( UIImage.init(named: "filtersDefault"), for: .normal)
        } else {
            filterButton.setImage( UIImage.init(named: "filters"), for: .normal)
        }
    }
    
//    func didUpdateLocation(location: CLLocation) {
//        print("Latitude \(location.coordinate.latitude) longitute \(location.coordinate.longitude)")
//        currentLocation = location.coordinate
//    }
    
    
}
