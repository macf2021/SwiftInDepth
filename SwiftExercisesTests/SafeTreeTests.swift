//  TreeTests.swift
//  Copyright © 2015 Allen Holub. All rights reserved.
//

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

import XCTest
@testable import SwiftExercises

class SafeTreeTests: XCTestCase {

    func testSafeTree() {
        let st = SafeTree<MyClass>()

        do {
            let node = MyClass(value:"hello")
            _ = st.add(element: node )
            try node.modify(newValue: "goodbye")
            XCTAssert(false, "Shouldn't get here")
        }
        catch LockedObjectException.ObjectLocked {
            // It's actally a success if we get here.
        }
        catch {
            XCTAssert(false, "Shouldn't get here")
        }
    }
}

//----------------------------------------------------------------------
// A class for use as an element in a SafeTree. It has to adopt Lockable
// for the sake of the SafeTree, and it has to adopt Comparable becuase
// all Tree elements have to be comparable.
//

class MyClass : Comparable, Lockable {
    fileprivate var value: String
    private var isLocked = false;

    init(value: String) {self.value = value}
    func lock()   {isLocked = true}
    func unlock() {isLocked = false}
    func modify(newValue: String) throws {
        if isLocked {
            throw LockedObjectException.ObjectLocked
        }
        value = newValue
    }
}

func == (l: MyClass, r:MyClass ) -> Bool { return l.value == r.value  }
func <= (l: MyClass, r:MyClass ) -> Bool { return l.value <= r.value  }
func >= (l: MyClass, r:MyClass ) -> Bool { return l.value >= r.value  }
func <  (l: MyClass, r:MyClass ) -> Bool { return l.value <  r.value  }
func >  (l: MyClass, r:MyClass ) -> Bool { return l.value >  r.value  }
