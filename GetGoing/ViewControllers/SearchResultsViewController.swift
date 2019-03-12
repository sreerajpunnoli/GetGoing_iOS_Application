//
//  SearchResultsViewController.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-23.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortResult: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var places: [PlaceDetails]!
    
    // MARK: -  Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "SearchResultsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchResultTableViewCell")
        places = places.sorted(by: {$0.name ?? "" < $1.name ?? ""})
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func mapViewAction(_ sender: UIBarButtonItem) {
        guard let mapPreviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapPreviewViewController") as? MapPreviewViewController else { return }
        mapPreviewViewController.places = places
        
//        present(mapPreviewViewController, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(mapPreviewViewController, animated: true)
        }
    }
    
    @IBAction func sortResultAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            places = places.sorted(by: {$0.name ?? "" < $1.name ?? ""})
        } else {
            places = places.sorted(by: {$0.rating ?? 0 > $1.rating ?? 0})
        }
        tableView.reloadData()
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultsTableViewCell else {
            return UITableViewCell();
        }
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        
        cell.vicinityLabel.text = place.address
        if let placeRating = place.rating {
            cell.ratingControl.rating = Int(placeRating.rounded(.down))
        }
        
        guard let iconString = place.icon,
            let iconURL = URL(string: iconString),
            let imageData = try? Data(contentsOf: iconURL) else {
                cell.iconImageView.image = UIImage(named: "StarEmpty")
                return cell
        }
        cell.iconImageView.image = UIImage(data: imageData)
        return cell
    }
    
    func showActivityIndicator() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        //searchButton.isEnabled = false
        
    }
    
    func hideActivityIndicator() {
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        //searchButton.isEnabled = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt resultIndex: IndexPath) {
        print("print index \(resultIndex.row) r:\(resultIndex)")
        let placeId = places[resultIndex.row].placeId
        
        showActivityIndicator()
        if placeId == nil {
            self.presentErrorAlert(message: "No results")
            return
        }
        GooglePlacesAPI.requestPlaceDetail(placeId!) { (status, json) in
            print(json ?? "")
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            guard let jsonObj = json else { return }
            
            let result = APIParser.parsePlaceDetail(jsonObj: jsonObj)
            if result == nil {
                // make it run in main thread
                DispatchQueue.main.async {
                    self.presentErrorAlert(message: "No results")
                }
            } else {
                self.presentSearchResults(place: result!)
            }
        }
    }
    
    func presentErrorAlert(title: String = "Error", message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func presentSearchResults(place: PlaceDetails) {
        guard let placeDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as? PlaceDetailViewController else { return }
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultsTableViewCell else {
//            return
//        }
//        
//        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "VC-ID" as! yourViewController
//        let navigationVC = UINavigationController(rootViewController: secondVC)
//        self.present(navigationVC, animated: true, completion: nil)
        
        
//        placeDetailViewController.setLabels(place: place)
        placeDetailViewController.place = place
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(placeDetailViewController, animated: true)
        }
    }
    
}
