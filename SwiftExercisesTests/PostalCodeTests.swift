//  PostalCodeTests.swift
//  Copyright © 2015 Allen Holub. All rights reserved.

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

import XCTest
@testable import SwiftExercises

class PostalCodeTests: XCTestCase {

    func testPostalCodeAsString () {
        XCTAssertEqual( PostalCode.usa(12345,6789).asString(), "12345-6789" )
        XCTAssertEqual( PostalCode.can("A0A 0A0" ).asString(), "A0A 0A0" )
        XCTAssertEqual( PostalCode.gb("SW1A 1AA").asString(), "SW1A 1AA" )
    }

    func testCountryRawValues() {
        XCTAssertEqual( Country.usa.rawValue, "United States" )
        XCTAssertEqual( Country.gb.rawValue,  "United Kingdom" )
        XCTAssertEqual( Country.can.rawValue,  "Canada" )
    }

    func testCountryGetPostalCode() {

        switch( Country.usa.getPostalCode(primary: 12345,6789)! ) {
        case .usa(12345,6789): break
        default: XCTFail()
        }

        switch( Country.usa.getPostalCode(primary: 12345,6789)! ) {
        case .usa(00000,0000): XCTFail()
        default: break
        }

        switch(Country.can.getPostalCode(value: "A0A 0A0")!) {
        case .can("A0A 0A0"): break
        default: XCTFail()
        }

        switch( Country.gb.getPostalCode(value: "SW1A 1AA")! ) {
        case .gb("SW1A 1AA"): break
        default: XCTFail()
        }

        XCTAssertNil( Country.gb.getPostalCode(value: "A0A 0A0") )
    }
}
