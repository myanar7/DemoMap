//
//  File.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 13.09.2023.
//

import Foundation

struct Trip: Codable {
    var id: Int
    var busName: String
    var time: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case busName = "bus_name"
        case time = "time"
    }
}
