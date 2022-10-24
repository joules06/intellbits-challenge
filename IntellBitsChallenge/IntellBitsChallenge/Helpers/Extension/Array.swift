//
//  Array.swift
//  IntellBitsChallenge
//
//  Created by Julio Rico on 24/10/22.
//

import Foundation

extension Array where Element == URLQueryItem {
    init<T: LosslessStringConvertible>(_ dictionary: [String: T]) {
        self = dictionary.map({ (key, value) -> Element in
            URLQueryItem(name: key, value: String(value))
        })
    }
}
