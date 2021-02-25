//
//  DogList.swift
//  doggoAPI
//
//  Created by Jagdeep Singh on 23/02/21.
//

import Foundation

struct DogList: Codable {
    let message: [String: [String]]
    let status: String
}
