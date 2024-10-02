//
//  CountryModel.swift
//  CountryListUIKit
//
//  Created by Abouzar Moradian on 10/2/24.
//

import Foundation

struct CountryModel: Codable, Equatable {
    let capital: String?
    let code: String
    let currency: Currency
    let flag: String?
    let language: Language
    let name: String
    let region: String
}

struct Currency: Codable, Equatable {
    let code: String
    let name: String
    let symbol: String?
}

struct Language: Codable, Equatable {
    let code: String?
    let name: String
}

/*
 {
   "capital": "Kabul",
   "code": "AF",
   "currency": {
     "code": "AFN",
     "name": "Afghan afghani",
     "symbol": "؋"
   },
   "flag": "https://restcountries.eu/data/afg.svg",
   "language": {
     "code": "ps",
     "name": "Pashto"
   },
   "name": "Afghanistan",
   "region": "AS"
 }
 */
