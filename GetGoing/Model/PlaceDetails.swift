//
//  PlaceDetails.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-23.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import Foundation
import CoreLocation
class PlaceDetails: NSObject, NSCoding {
    
    struct PropertyKey {
        static let idKey = "id"
        static let nameKey = "name"
        static let longitudeKey = "longitude"
        static let latitudeKey = "latitude"
        static let vicinityKey = "vicinity"
        static let formatterAddressKey = "formattedAddress"
        static let ratingKey = "rating"
        static let iconKey = "icon"
        static let placeIdKey = "placeId"
    }
    
    var id: String
    var name: String?
    var coordinate: CLLocationCoordinate2D?
    var vicinity: String?
    var formatedAddress: String?
    var rating: Double?
    var icon: String?
    var placeId: String?
    var phone: String?
    var website: String?
    
    var address: String? {
        return formatedAddress ?? vicinity
    }
    
    //Mark: - NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(id, forKey: PropertyKey.idKey)
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(vicinity, forKey: PropertyKey.vicinityKey)
        aCoder.encode(formatedAddress, forKey: PropertyKey.formatterAddressKey)
        if let rating = rating {
            aCoder.encode(rating, forKey: PropertyKey.ratingKey)
        }
        if let coordinate = coordinate {
            aCoder.encode(coordinate.latitude, forKey: PropertyKey.latitudeKey)
            aCoder.encode(coordinate.longitude, forKey: PropertyKey.longitudeKey)
        }
        
        aCoder.encode(icon, forKey: PropertyKey.iconKey)
        aCoder.encode(placeId, forKey: PropertyKey.placeIdKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: PropertyKey.idKey) as? String  ?? ""
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as? String
        let vicinity = aDecoder.decodeObject(forKey: PropertyKey.vicinityKey) as? String
        let formattedAddress = aDecoder.decodeObject(forKey: PropertyKey.formatterAddressKey) as? String
        let rating = aDecoder.decodeDouble(forKey: PropertyKey.ratingKey)
        let icon = aDecoder.decodeObject(forKey: PropertyKey.iconKey) as? String
        let placeID = aDecoder.decodeObject(forKey: PropertyKey.placeIdKey) as? String
        let latitude = aDecoder.decodeDouble(forKey: PropertyKey.latitudeKey)
        let longitude = aDecoder.decodeDouble(forKey: PropertyKey.longitudeKey)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(id: id, name: name, vicinity: vicinity, formattedAddress: formattedAddress, rating: rating, icon: icon, placeId: placeID, coordinate: coordinate)
    }
    
    // Mark: - Initializers
    
    init(id: String, name: String?,vicinity: String?, formattedAddress: String?, rating: Double?, icon: String?, placeId: String?, coordinate: CLLocationCoordinate2D?) {
        self.id = id
        self.name = name
        self.vicinity = vicinity
        self.formatedAddress = formattedAddress
        self.rating = rating
        self.icon = icon
        self.placeId=placeId
        self.coordinate=coordinate
    }
    
    init?(json: [String: Any]){
        guard let id = json["id"] as? String else { return nil }
        self.id = id
        
        self.name = json["name"] as? String
        self.vicinity = json["vicinity"] as? String
        self.formatedAddress = json["formatted_address"] as? String
        
        if let geometry = json["geometry"] as? [String: Any]
        {
            if let location = geometry["location"] as? [String: Any] {
                if let latitude = location["lat"] as? Double,
                    let longitude = location["lng"] as? Double {
                    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
            }
        }
        
        self.rating = json["rating"] as? Double
        self.icon = json["icon"] as? String
        self.phone = json["international_phone_number"] as? String
        self.website = json["website"] as? String
        self.placeId = json["place_id"] as? String
    }

    

}

