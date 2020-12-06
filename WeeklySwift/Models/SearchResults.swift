//
//  SearchResults.swift
//  WeeklySwift
//
//  Created by Viachaslau on 12/5/20.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnspashPhoto]
}

struct UnspashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue: String]
}

enum URLKind: String {
    case raw
    case full
    case regular
    case small
    case thumb
}
