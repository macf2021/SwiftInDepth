//
//  UndoableTreeTests.swift
//  SwiftExercises
//
//  Created by allen on 9/22/15.
//  Copyright © 2015 allen. All rights reserved.
//

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

import XCTest
@testable import SwiftExercises

class UndoableTreeTests: XCTestCase {

    func testUndoRedo() {
        let t = UndoableTree<String>()
        _ = t.add(element: "b")
        _ = t.add(element: "a")
        _ = t.add(element: "c"); XCTAssertEqual(asString(t: t), "abc")
        _ = t.undo();   XCTAssertEqual(asString(t: t), "ab")
        _ = t.undo();   XCTAssertEqual(asString(t: t), "b")
        _ = t.redo();   XCTAssertEqual(asString(t: t), "ab")
        _ = t.redo();   XCTAssertEqual(asString(t: t), "abc")
    }

    func asString(t: UndoableTree<String>) -> String {
        var result = ""
        t.traverse { result += $0; return true }
        return result
    }
}
