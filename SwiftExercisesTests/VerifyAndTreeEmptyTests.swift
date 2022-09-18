//  verifyAndTreeEmptyTests.swift
//  Copyright © 2015 Allen Holub. All rights reserved.

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */


import XCTest
@testable import SwiftExercises

class VerifyAndTreeEmptyTests: XCTestCase {

    var t: StringTreeWithVerify! = nil
    
    override func setUp() {
        super.setUp()
        t = StringTreeWithVerify( ["d", "b", "f", "a", "c", "e", "g"] )
    }

    func testTreeStructure() {
        XCTAssertTrue( t._verifyChildren(parent: "d", left: "b", right: "f") )
        XCTAssertTrue( t._verifyChildren(parent: "b", left: "a", right: "c") )
        XCTAssertTrue( t._verifyChildren(parent: "f", left: "e", right: "g") )
        XCTAssertTrue( t._verifyChildren(parent: "a", left: nil, right: nil) )
        XCTAssertTrue( t._verifyChildren(parent: "c", left: nil, right: nil) )
        XCTAssertTrue( t._verifyChildren(parent: "e", left: nil, right: nil) )
        XCTAssertTrue( t._verifyChildren(parent: "g", left: nil, right: nil) )

        _ = t.add(element: "h")

        XCTAssertTrue( t._verifyChildren(parent: "d", left: "b", right: "f") )
        XCTAssertTrue( t._verifyChildren(parent: "b", left: "a", right: "c") )
        XCTAssertTrue( t._verifyChildren(parent: "f", left: "e", right: "g") )
        XCTAssertTrue( t._verifyChildren(parent: "a", left: nil, right: nil) )
        XCTAssertTrue( t._verifyChildren(parent: "c", left: nil, right: nil) )
        XCTAssertTrue( t._verifyChildren(parent: "e", left: nil, right: nil) )
        XCTAssertTrue( t._verifyChildren(parent: "g", left: nil, right: "h") )
        XCTAssertTrue( t._verifyChildren(parent: "h", left: nil, right: nil) )
    }

    func testRemove() {
        try! _ = t.remove(lookingFor: "c");
        try! _ = t.remove(lookingFor: "b");
        try! _ = t.remove(lookingFor: "e");
        try! _ = t.remove(lookingFor: "f");
        try! _ = t.remove(lookingFor: "d");

        XCTAssertTrue(t.count == 2)
        XCTAssertTrue(t.contains(lookingFor: "a"))
        XCTAssertTrue(t.contains(lookingFor: "g"))

        do {
            try _ = t.remove(lookingFor: "xxxx")
            XCTFail()
        }
        catch StringTreeWithVerify.Error.Empty {}
        catch { XCTFail() }

        do {
            t.clear()
            try _ = t.remove(lookingFor: "xxxx")
            XCTFail()
        }
        catch StringTreeWithVerify.Error.Empty {}
        catch { XCTFail() }
    }
}
