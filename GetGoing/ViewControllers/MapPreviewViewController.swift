//
//  MapPreviewViewController.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-02-22.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import UIKit
import MapKit

class MapPreviewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var places: [PlaceDetails]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMapViewCoordinate()
        // Do any additional setup after loading the view.
    }
    
    func setMapViewCoordinate() {
        mapView.delegate = self
        for place in places {
            guard let coordinate = place.coordinate else { return }
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            centerMapOnLocation(location: coordinate)
        }
        // Indicates in blue user's current location if available
        mapView.showsUserLocation = true
    }
    
    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //        let destVC : MapPreviewViewController = segue.destination as! MapPreviewViewController
//        //        destVC.places = places
//        if segue.identifier == "FilterSegue" {
//            if let sourceVC = segue.source as? SearchResultsViewController {
//                sourceVC.places = places
//            }
//        }
//    }

    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let radius = 5000
        
        let distance = CLLocationDistance(Double(radius) * 2)
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        
        mapView.setRegion(region, animated: true)
    }
}

extension MapPreviewViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusablePin")
        // allowing to show extra information in the pin view
        view.canShowCallout = true
        // "i" button
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.pinTintColor = UIColor.red
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation
        
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
        if let coordnate = location?.coordinate {
            location?.mapItem(coordinate: coordnate).openInMaps(launchOptions: launchingOptions)
        }
    }
}
