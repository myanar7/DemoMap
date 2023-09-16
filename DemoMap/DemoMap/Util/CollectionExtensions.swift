//
//  CollectionExtensions.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 14.09.2023.
//

import Foundation

extension String {
    
    /// Turns center coordinates string into the two double value for X and Y
    public func coordinate2D() -> (Double,Double)? {
        let splittedCoordinates = self.split(separator: ",")
        guard let coordinateX = Double(splittedCoordinates[0]),
              let coordinateY = Double(splittedCoordinates[1]) else { return nil }

        return (coordinateX, coordinateY)
    }
}
