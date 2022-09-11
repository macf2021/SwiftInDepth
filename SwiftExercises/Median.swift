//  Median.swift
//  Copyright © 2015 Allen Holub. All rights reserved.

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

import Foundation

extension Collection {
    func median() -> T? {
        var i = 0;
        var found : T?
        if count > 0 {
            traverse {
                if  i == self.count / 2 {
                    found = $0
                    return false;
                }
                i += 1
                return true
            }
        }
        return found
    }
}
