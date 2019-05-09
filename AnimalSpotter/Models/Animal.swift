//
//  Animal.swift
//  AnimalSpotter
//
//  Created by Michael Flowers on 5/9/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Animal: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let timeseen: Date
    let description: String
    let imageURL: String
}
