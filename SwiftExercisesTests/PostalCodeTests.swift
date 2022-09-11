//  PostalCodeTests.swift
//  Copyright © 2015 Allen Holub. All rights reserved.

import XCTest
@testable import SwiftExercises

class PostalCodeTests: XCTestCase {

    func testPostalCodeAsString () {
        XCTAssertEqual( PostalCode.usa(12345,6789).asString(), "12345-6789" )
        XCTAssertEqual( PostalCode.CA("A0A 0A0" ).asString(), "A0A 0A0" )
        XCTAssertEqual( PostalCode.gb("SW1A 1AA").asString(), "SW1A 1AA" )
    }

    func testCountryRawValues() {
        XCTAssertEqual( Country.USA.rawValue, "United States" )
        XCTAssertEqual( Country.gb.rawValue,  "United Kingdom" )
        XCTAssertEqual( Country.CA.rawValue,  "Canada" )
    }

    func testCountryGetPostalCode() {

        switch( Country.USA.getPostalCode(12345,6789)! ) {
        case .usa(12345,6789): break
        default: XCTFail()
        }

        switch( Country.USA.getPostalCode(12345,6789)! ) {
        case .usa(00000,0000): XCTFail()
        default: break
        }

        switch( Country.CA.getPostalCode("A0A 0A0")! ) {
        case .CA("A0A 0A0"): break
        default: XCTFail()
        }

        switch( Country.gb.getPostalCode("SW1A 1AA")! ) {
        case .gb("SW1A 1AA"): break
        default: XCTFail()
        }

        XCTAssertNil( Country.gb.getPostalCode("A0A 0A0") )
    }
}
