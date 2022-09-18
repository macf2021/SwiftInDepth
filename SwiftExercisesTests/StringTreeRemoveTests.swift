//  StringTreeTests.swift
//  Copyright © 2015 Allen Holub. All rights reserved.
//

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

import XCTest
@testable import SwiftExercises

class StringTreeRemoveTests: XCTestCase {

    var t: StringTreeWithRemove! = nil
    
    override func setUp() {
        super.setUp()
        t = StringTreeWithRemove(["d", "b", "f", "a", "c", "e", "g"])
    }

    func testArrayInit() {
        let t = StringTreeWithRemove(["a", "b", "c"])
        XCTAssertTrue(t.contains(lookingFor: "a") && t.contains(lookingFor: "b") && t.contains(lookingFor: "c"))
    }

    func testZeroAndOneElement() {
        t.clear()
        XCTAssertTrue(t.isEmpty)
        XCTAssertNil(t.smallest())
        XCTAssertNil(t.largest())
        _ = t.add(element: "x");
        XCTAssertTrue(t.count  ==  1 )
        XCTAssertTrue(t.smallest() == "x")
        XCTAssertTrue(t.largest() == "x")
    }

    func testContains() {
        XCTAssertTrue(t.contains(lookingFor: "a"))
        XCTAssertTrue(t.contains(lookingFor: "b"))
        XCTAssertTrue(t.contains(lookingFor: "c"))
        XCTAssertTrue(t.contains(lookingFor: "d"))
        XCTAssertTrue(t.contains(lookingFor: "e"))
        XCTAssertTrue(t.contains(lookingFor: "f"))
        XCTAssertTrue(t.contains(lookingFor: "g"))
        XCTAssertFalse(t.contains(lookingFor: "h"))
    }

    func testFindMatchOf() {
        XCTAssertTrue(t.findMatchOf(lookingFor: "a") == "a")
        XCTAssertTrue(t.findMatchOf(lookingFor: "b") == "b")
        XCTAssertTrue(t.findMatchOf(lookingFor: "c") == "c")
        XCTAssertTrue(t.findMatchOf(lookingFor: "d") == "d")
        XCTAssertTrue(t.findMatchOf(lookingFor: "e") == "e")
        XCTAssertTrue(t.findMatchOf(lookingFor: "f") == "f")
        XCTAssertTrue ( t.findMatchOf(lookingFor: "g") == "g" )
        XCTAssertNil  ( t.findMatchOf(lookingFor: "h") )
    }

    func testRemove() {
        _ = t.remove(lookingFor: "c");
        _ = t.remove(lookingFor: "b");
        _ = t.remove(lookingFor: "e");
        _ = t.remove(lookingFor: "f");
        _ = t.remove(lookingFor: "d");

        XCTAssertTrue( t.count == 2 )
        XCTAssertTrue( t.contains(lookingFor: "a") )
        XCTAssertTrue( t.contains(lookingFor: "g") )
    }
}
