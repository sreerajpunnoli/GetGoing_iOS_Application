//
//  GooglePlacesAPI.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-21.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlacesAPI {
    
    class func requestPlaces(radius: Int, opennow: Bool,_ query: String, completion: @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems =
            [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "opennow", value: "\(opennow)"),
                URLQueryItem(name: "key", value: Constants.apikey)
        ]
        if let url = urlComponents.url {
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in
                
                if let responseData = data,
                    let jsonResponse = try?
                        JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                    
                } else {
                    completion(status, nil)
                }
            }
        }
    }
    
    class func requestPlacesNearby(for coordinate: CLLocationCoordinate2D, radius: Int, rankby: String, opennow: Bool, _ query: String?, completion: @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.nearbySearch
        
        urlComponents.queryItems =
            [
                URLQueryItem(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
//                URLQueryItem(name: "location", value: "\(-33.8670522),\(151.1957362)"),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "opennow", value: "\(opennow)"),
                URLQueryItem(name: "rankby", value: rankby),
                URLQueryItem(name: "key", value: Constants.apikey)

        ]
                    
        if let keyword = query {
            urlComponents.queryItems?.append(URLQueryItem(name: "keyword", value: keyword))
        }
        if let url = urlComponents.url {
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in
                
                if let responseData = data,
                    let jsonResponse = try?
                        JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                    
                } else {
                    completion(status, nil)
                }
            }
        }
    }
    
    class func requestPlaceDetail(_ placeId: String, completion: @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.placeDetails
        
        urlComponents.queryItems =
            [
                URLQueryItem(name: "placeid", value: placeId),
                URLQueryItem(name: "key", value: Constants.apikey)
        ]
        if let url = urlComponents.url {
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in
                
                if let responseData = data,
                    let jsonResponse = try?
                        JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                    
                } else {
                    completion(status, nil)
                }
            }
        }
    }
}
