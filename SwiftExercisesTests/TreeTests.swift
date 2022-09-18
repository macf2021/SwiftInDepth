//  TreeTests.swift
//  Copyright © 2015 Allen Holub. All rights reserved.
//

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

import XCTest
@testable import SwiftExercises

class TreeTests: XCTestCase {

    var t: Tree<String>!
    
    override func setUp() {
        super.setUp()
        t = Tree<String>( ["d", "b", "f", "a", "c", "e", "g"] )
    }

    func testTreeStructure() {
        XCTAssertTrue(t._verifyChildren(parent: "d", left: "b", right: "f"))
        XCTAssertTrue(t._verifyChildren(parent: "b", left: "a", right: "c"))
        XCTAssertTrue(t._verifyChildren(parent: "f", left: "e", right: "g"))
        XCTAssertTrue(t._verifyChildren(parent: "a", left: nil, right: nil))
        XCTAssertTrue(t._verifyChildren(parent: "c", left: nil, right: nil))
        XCTAssertTrue(t._verifyChildren(parent: "e", left: nil, right: nil))
        XCTAssertTrue(t._verifyChildren(parent: "g", left: nil, right: nil))

        _ = t.add(element: "h")

        XCTAssertTrue(t._verifyChildren(parent: "d", left: "b", right: "f"))
        XCTAssertTrue(t._verifyChildren(parent: "b", left: "a", right: "c"))
        XCTAssertTrue(t._verifyChildren(parent: "f", left: "e", right: "g"))
        XCTAssertTrue(t._verifyChildren(parent: "a", left: nil, right: nil))
        XCTAssertTrue(t._verifyChildren(parent: "c", left: nil, right: nil))
        XCTAssertTrue(t._verifyChildren(parent: "e", left: nil, right: nil))
        XCTAssertTrue(t._verifyChildren(parent: "g", left: nil, right: "h"))
        XCTAssertTrue(t._verifyChildren(parent: "h", left: nil, right: nil))
    }

    func testArrayInit() {
        let t = Tree<String>( ["a", "b", "c"] )
        XCTAssertTrue(t.contains(lookingFor: "a") && t.contains(lookingFor: "b") && t.contains(lookingFor: "c"))
    }


    func testZeroAndOneElement() {
        t.clear()
        XCTAssertTrue(t.isEmpty)
        XCTAssertNil (t.smallest())
        XCTAssertNil (t.largest())

        _ = t.add(element: "x");

        XCTAssertTrue(t.count ==  1 )
        XCTAssertTrue(t.smallest() == "x")
        XCTAssertTrue(t.largest() == "x")
    }

    func testContains() {
        XCTAssertTrue (t.contains(lookingFor: "a"))
        XCTAssertTrue (t.contains(lookingFor: "b"))
        XCTAssertTrue (t.contains(lookingFor: "c"))
        XCTAssertTrue (t.contains(lookingFor: "d"))
        XCTAssertTrue (t.contains(lookingFor: "e"))
        XCTAssertTrue (t.contains(lookingFor: "f"))
        XCTAssertTrue (t.contains(lookingFor: "g"))
        XCTAssertFalse(t.contains(lookingFor: "h"))
    }

    func testFindMatchOf() {
        XCTAssertTrue(t.findMatchOf(lookingFor: "a") == "a")
        XCTAssertTrue(t.findMatchOf(lookingFor: "b") == "b")
        XCTAssertTrue(t.findMatchOf(lookingFor: "c") == "c")
        XCTAssertTrue(t.findMatchOf(lookingFor: "d") == "d")
        XCTAssertTrue(t.findMatchOf(lookingFor: "e") == "e")
        XCTAssertTrue(t.findMatchOf(lookingFor: "f") == "f")
        XCTAssertTrue(t.findMatchOf(lookingFor: "g") == "g")
        XCTAssertNil(t.findMatchOf(lookingFor: "h"))
    }

    func testRemove() {
        try! _ = t.remove(lookingFor: "c");
        try! _ = t.remove(lookingFor: "b");
        try! _ = t.remove(lookingFor: "e");
        try! _ = t.remove(lookingFor: "f");
        try! _ = t.remove(lookingFor: "d");

        XCTAssertTrue(t.count == 2)
        XCTAssertTrue(t.contains("a"))
        XCTAssertTrue(t.contains("g"))

        do {
            try _ = t.remove(lookingFor: "xxxx")
            XCTFail()
        }
        catch TreeError.Empty {}
        catch { XCTFail() }

        do {
            t.clear()
            try _ = t.remove(lookingFor: "xxxx")
            XCTFail()
        }
        catch TreeError.Empty {}
        catch { XCTFail() }
    }

    func testAsString() {
        t.clear()
        t += "b"
        t += "a"
        t += "c"
        XCTAssertEqual(t.asString(delim: ","), "a,b,c")
    }

    func testTraversal() {
        var s = ""
        t.traverse(direction: .Inorder){s += $0; return true}
        XCTAssertEqual(s, "abcdefg" )

        s = ""
        t.traverse(direction: .Preorder){s += $0; return true}
        XCTAssertEqual(s, "dbacfeg")

        s = ""
        t.traverse(direction: .Postorder){s += $0; return true}
        XCTAssertEqual(s, "acbegfd" )

        s = ""
        t.traverse{s += $0; return true}
        XCTAssertEqual(s, "abcdefg" )

        s = ""
        t.traverse {
            if( $0 <= "c") {
                s += $0
                return true // allow traversal to continue
            }
            return false // stop the traversal
        }
        XCTAssertEqual(s, "abc" )

        s = ""
        t.forEveryElement{ s += $0 }
        XCTAssertEqual(s, "abcdefg" )

    }

    func testOperators() {
        XCTAssertTrue( t <> "a" )
        t -= "a"
        XCTAssertFalse( t <> "a" )
        t += "a"
        XCTAssertTrue( t <> "a" )

        XCTAssertEqual(t[0], "a" )
        XCTAssertEqual(t[6], "g" )

        // No way to test an exception toss on overflow
        // because that's not a catchable exception. Hopefully
        // Apple will fix that at some point. Could get arround
        // that by returning an auto-unwrapping optional from the
        // subscript method, but that would push the error downstream
        // to the first time the item was used, which would make the
        // bug harder to find.
    }

    func testFilterMapReduce() {
        let result = t.filter{ $0 <= "d" }
                      .map   { return $0.uppercased() }
                      .reduce("-"){ $0 + $1 }

        XCTAssertEqual(result, "-ABCD")
    }

    func testIterators() {
        var s = ""
        for element in t {
            s += element
        }
        XCTAssertEqual( s, "abcdefg" )
    }

}
