//
//  Station.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 13.09.2023.
//

import Foundation

struct Station: Codable {
    var id: Int
    var name: String
    var tripsCount: Int
    var centerCoordinates: String
    var trips: [Trip]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case tripsCount = "trips_count"
        case centerCoordinates = "center_coordinates"
        case trips = "trips"
    }
}
