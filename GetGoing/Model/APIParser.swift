//
//  APIParser.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-23.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import Foundation

class APIParser {
    
    class func parseNearbySearchResults(jsonObj: [String:Any]) -> [PlaceDetails]{
        
        var places: [PlaceDetails] = []
        
        if let results = jsonObj["results"] as? [[String: Any]]{
            
            results.forEach { (result) in
                if let place = PlaceDetails(json: result) {
                    places.append(place)
                }
            }
            
        }
        return places
    }
    
    class func parsePlaceDetail(jsonObj: [String:Any]) -> PlaceDetails? {
        if let result = jsonObj["result"] as? [String: Any]{
            if let place = PlaceDetails(json: result) {
                return place
            }
        }
        return nil
    }
    
}
