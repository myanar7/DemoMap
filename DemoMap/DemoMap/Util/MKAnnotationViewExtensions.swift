//
//  MKAnnotationViewExtensions.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 16.09.2023.
//

import MapKit

extension MKAnnotationView {
    
    func updateImage(with newImage: UIImage?) {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.image = newImage },
                          completion: nil)
    }
}
