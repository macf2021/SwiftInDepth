import Cocoa
import Foundation

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

public enum PostalCode {
    case usa(Int, Int)
    case gb(String)
    case can(String)
    
    func asString() -> String {
        switch( self ) {
        case .usa( let primary, let secondary ): return "\(primary)-\(secondary)"
        case .gb( let(s) ): return s;
        case .can( let(s) ): return s;
        }
    }
}

public enum Country: String {
    case usa = "United States"
    case gb  = "United Kingdom"
    case can  = "Canada"

    func getPostalCode(primary:Int, _ secondary:Int) -> PostalCode? {
        switch self {
        case .usa where (1...99999 ~= primary) && (1...9999 ~= secondary):
            return PostalCode.usa(primary, secondary)
        default:
            return nil;
        }
    }
    
    func getPostalCode(value:String) -> PostalCode? {
        // Candadian postal codes take the form "AdA dAd" where A is alphabetic and d is a digit
        // gb postal codes are arbitrary strings are between 6 and 8 characters taking one of
        // the forms:
        // AA0A dAA
        // AdA dAA
        // Ad dAA
        // Add dAA
        // AAd dAA
        // AAdd dAA
        
        let candidate = toCharArray(s:value)
        switch self {
        case .can where matches(template: "AdA dAd", candidate):
            return PostalCode.can(value)
        case .gb where matches(template: "AAdA dAA", candidate): fallthrough
        case .gb where matches(template: "AdA dAA",  candidate): fallthrough
        case .gb where matches(template: "Ad dAA",   candidate): fallthrough
        case .gb where matches(template: "Add dAA",  candidate): fallthrough
        case .gb where matches(template: "AAd dAA",  candidate): fallthrough
        case .gb where matches(template: "AAdd dAA", candidate):
            return PostalCode.gb(value)
            
        default:
            return nil;
        }
    }
    
    private func toCharArray(s: String) -> [Character] {
        var characters:[Character] = []
        for c in s {
            characters.append(c)
        }
        return characters
    }
    
    private func matches(template: String, _ candidate: [Character]) -> Bool {
        if template.count != candidate.count {
            return false
        }
        var i = -1;
        for current in template {
            print("comparing template(\(current)) to candidate(\(candidate[i]))" )
            i += 1
            switch (current, candidate[i]) {
                case (" ", let c) where " " ~= c        : continue
                case ("d", let c) where "0"..."9" ~=  c : continue
                case ("A", let c) where "A"..."Z" ~=  c : continue
                default: print("mismatch"); return false
            }
        }
        return true;
    }
}
