//
//  Constants.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-21.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import Foundation

class Constants {
    
	// Give the api key below to make the application work
    static let apikey = ""
    
    static let scheme = "https"
    static let host = "maps.googleapis.com"
    static let textPlaceSearch = "/maps/api/place/textsearch/json"
    static let nearbySearch = "/maps/api/place/nearbysearch/json"
    static let placeDetails = "/maps/api/place/details/json"
    
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("PlaceDetails")
    
}
