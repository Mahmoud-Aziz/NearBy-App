//
//  XCTestCase.swift
//  NearBy AppTests
//
//  Created by Mahmoud Aziz on 09/10/2021.
//

import Foundation
import XCTest

extension XCTestCase {
    func loadStubFromBundle(with name: String, extention: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: extention)
        return try! Data(contentsOf: url!)
    }
}
