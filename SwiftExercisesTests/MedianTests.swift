//
//  MedianTests.swift
//  SwiftExercises
//
//  Created by allen on 9/27/15.
//  Copyright © 2015 allen. All rights reserved.
//

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */
import XCTest
@testable import SwiftExercises

class MedianTests: XCTestCase {
    func testMedian() {
        let t = SimpleGenericTree<String>(["a", "b", "c"])
        XCTAssertEqual(t.median(), "b")
    }

}
