//
//  Car.swift
//  Carangas
//
//  Created by Victor Feitosa on 28/12/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation


class Car: Codable {
    var _id: String?
    var brand: String = ""
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.0
    var gas: String {
        switch gasType {
            case 0:
                return "Flex"
            case 1:
                return "Álcool"
            default:
                return "Gasolina"
        }
    }
}

struct Brand: Codable {
    var nome: String = ""
}
