import Swift
import Cocoa
import Foundation

/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */

/// Classic Binary Tree Data Structure to learn Swift language with
public class Tree<T: Comparable>: ExpressibleByArrayLiteral, Collection {
    private var root: Node<T>?
    private var size:    Int = 0;
    public var  count:   Int  { return size }

    //----------------------------------------------------------------------
    /// arrayVersion is used by the [] operator. [] is implemented in an
    /// extenstion, but you can declare new fields (stored properties) in
    /// extenstions. If it's nill, no array version exists, otherwise it
    /// points at an array version of the tree. It's set to nill if the
    /// tree is modified (by an add() or remove() call, for example).
    ///
    private var arrayVersion:[T]?

    public var isEmpty: Bool { return root == nil; }

    public func clear() {
        root = nil
        arrayVersion = nil
        size = 0
    }
    
    //----------------------------------------------------------------------
    /// ArrayLiteralCovertible support. Initilize from and array literal. e.g.
    ///
    ///  var t:Tree<Int> = [0,1,2]
    ///
    public required init( arrayLiteral elements: T...) {
        for element in elements {
            add(element: element)
        }
    }
    
    //----------------------------------------------------------------------
    /// Initialize from an array. e.g.
    /// 
    /// var t:Tree<String>( ["a", "b", "c"] )
    ///
    public init ( _ elements: [T] ) {
        for element in elements {
           add(element: element)
        }
    }

    //----------------------------------------------------------------------
    /// Convert to a String using the indicated delimiter between elements.
    public func asString ( delim: String = " " ) -> String {
        return reduce(first: "", combine:{ return $0.count == 0 ? "\($1)" : "\($0)\(delim)\($1)"})
    }
    
    //----------------------------------------------------------------------
    /// Add a new element. Return false (and do nothing) if the element
    /// is already there
    ///
    @discardableResult
    public func add( element: T ) -> Bool {
        if root == nil {
            root = Node<T>(element)
        } else {
            lazy var current = root!;
            while true {
                if element > current.element { // go right
                    if current.rightChild == nil {
                        current.rightChild = Node(element)
                        break;
                    } else {
                        current = current.rightChild!
                    }
                } else if element < current.element { // go left
                    if current.leftChild == nil {
                        current.leftChild = Node(element)
                        break;
                    } else {
                        current = current.leftChild!
                    }
                } else {  // it's equal. Refuse to add a conflicting node
                    return false;
                }
            }
        }
        size += 1
        arrayVersion = nil; // force a rebild the next time it's needed
        return true
    }
   
// Remove an item from the tree, returning nil if it's not there and the
// item if it is
    
    public func remove( lookingFor: T ) throws -> T? {
        if let (target, parent) = doFind(lookingFor: lookingFor, current:root, parent:nil) {
            let orphanedSubtree = target.leftChild
            let targetSide      = target.isOnSideOf(parent: parent)
            if( target.rightChild == nil ) {
                replaceChildOf(parent: parent, on: targetSide, with: orphanedSubtree );
            } else {
                target.rightChild!.fillFirstAvailableSlotOn(inThisDirection: .Left, with: orphanedSubtree)
                replaceChildOf(parent: parent, on: targetSide, with: target.rightChild );
            }
            arrayVersion = nil; // force a rebild the next time it's needed

            size -= 1
            return target.element
        }
        throw TreeError.Empty
    }

    /// Replace the node on the specified side of the parent with the specified node (can be nil).
    /// If the parent reference is nill, it's assumed to be the root and the root node is
    /// replaced.
    private func replaceChildOf( parent: Node<T>?, on: Direction, with: Node<T>?) {
        if( parent == nil ) {  // parent node is the root node
            root = with;
        } else if on == .Left {
            parent!.leftChild = with
        } else {
            parent!.rightChild = with
        }
    }
    
      public func smallest() -> T? {
        lazy var current = root
        while  current?.leftChild != nil {
            current = current?.leftChild
        }
        return current?.element
    }
   
    public func largest() -> T? {
        lazy var current = root
        while  current?.rightChild != nil {
            current = current?.rightChild
        }
        return current?.element
    }
    
    //----------------------------------------------------------------------
    /// Return the element that matches (==) lookingFor or nil if you can't find it.
    /// Returns a tuple holding optional references to both the
    /// found node and its parent (see doFind()).
    public func findMatchOf(lookingFor: T) -> T? {
        if let (found, _) = doFind(lookingFor: lookingFor, current:root, parent:nil) {
            return found.element
        }
        return nil
    }
    
    public func contains(lookingFor: T) -> Bool {
        return findMatchOf(lookingFor: lookingFor) != nil
    }
  
    //----------------------------------------------------------------------
    /// The workhorse method used by both findMatchOf and remove.
    /// When you find something, all you need is the node you're looking for, but when you're
    /// removing, you'll need both that node and its parent. Consequently, this method returns
    /// an optional tuple that's nil if you can't find what you're looking for. The tuple holds
    /// a reference to the current node and also a reference to an optional parent node. The latter
    /// is nil when found item is the root node.
    private func doFind(lookingFor: T, current: Node<T>?, parent: Node<T>?)->
                                                    (found: Node<T>, parent: Node<T>?)?
    {
        if let c = current {
            return  lookingFor > c.element ? doFind(lookingFor: lookingFor, current: c.rightChild, parent: current):
            lookingFor < c.element ? doFind(lookingFor: lookingFor, current: c.leftChild,  parent: current):
                    /* == */                 (c, parent)
        }
        return nil
    }
    
    public func traverse( direction: Ordering, visit: (T)->Bool ) {
        switch( direction ) {
           case .Inorder:   traverseIn(current: root, visit)
           case .Preorder:  traversePre(current: root, visit)
           case .Postorder: traversePost(current: root, visit)
        }
    }

    // Need these two to conform to the Collection protocol. Can't do that
    // by defaulting the first argument, unfortunately.
    public func traverse( iterator: (T)->Bool   ) {
        return traverse(direction: .Inorder, visit: iterator)
    }

    public func forEveryElement( iterator: (T)->()   ) {
        return traverse(direction: .Inorder, visit: { iterator($0); return true })
    }

    public func printAll () {
        forEveryElement{ print( "\($0)" ) }
    }
    
    @discardableResult
    private func traverseIn(current: Node<T>?, _ visit: (T)->Bool) -> Bool {
        if let c = current {
            if !traverseIn(current: c.leftChild, visit) {
                return false
            }
            if !visit(c.element) {
                return false
            }
            if !traverseIn(current: c.rightChild, visit) {
                return false
            }
        }
        return true;
    }
    
    @discardableResult
    private func traversePost( current: Node<T>?, _ visit: (T)->Bool) -> Bool {
        if let c = current {
            if !traversePost(current: c.leftChild, visit) {
                return false
            }
            if !traversePost(current: c.rightChild, visit) {
                return false
            }
            if !visit(c.element) {
                return false
            }
        }
        return true;
    }
    
    @discardableResult
    private func traversePre( current: Node<T>?, _ visit: (T)->Bool) -> Bool {
        if let c = current {
            if !visit       ( c.element           ){ return false }
            if !traversePre (current: c.leftChild, visit  ){ return false }
            if !traversePre (current: c.rightChild, visit ){ return false }
        }
        return true;
    }

    //======================================================================
    // Test methods (internal access)

    func _verifyChildren( parent: T, left: T?, right: T? ) -> Bool {
        guard let (found, _) = doFind(lookingFor: parent, current:root, parent:nil)
        else { return false }

        switch (found.leftChild, found.rightChild ) {
            case (nil,   nil  ) where left==nil         && right==nil          : return true
            case (nil,   let r) where left==nil         && right!==r?.element  : return true
            case (let l, nil  ) where left!==l?.element && right==nil          : return true
            case (let l, let r) where left!==l?.element && right!==r?.element  : return true
            default                                                            : return false
        }
    }
}

//======================================================================
// A Node can't be a struct because we can't have references to
// value objects.
//
// We can't nest the definition inside of Tree, where it belongs, because
// of a COMPILER BUG. (Causes a hard crash.)
//
private class Node<T> {
    var rightChild: Node?
    var leftChild:  Node?
    
    let element: T
    init( _ element: T ) {
        self.element = element
    }

    // Stuff to support remove
    //
    /// Returns the side of the parent node that that the current node is on.
    /// Returns .Left if this is the root node.
    func isOnSideOf (parent: Node<T>?) -> Direction {
        return parent != nil && parent?.rightChild === self ? .Right : .Left
    }

    /// Finds the first available (nil) slot in the indicated direction, then inserts
    /// "insertsThis" into that slot. For example, if isThisDirection is .Left, it starts
    /// traversing at the current node, following links specified in the leftChild
    /// reference until it finds a nil leftChild. Then it inserts the insertNode
    /// in place of the nil.
    fileprivate func fillFirstAvailableSlotOn(inThisDirection: Direction, with insertThis: Node<T>?) {
        switch (inThisDirection) {
        case (.Left ) where leftChild  == nil : leftChild  = insertThis
        case (.Right) where rightChild == nil : rightChild = insertThis
            
        case (.Left ): leftChild! .fillFirstAvailableSlotOn(inThisDirection: .Left,  with: insertThis )
        case (.Right): rightChild!.fillFirstAvailableSlotOn(inThisDirection: .Right, with: insertThis )
        }
    }
}

func += <T>( left: Tree<T>, right: T ) {
    left.add(element: right)
}

func -= <T>(left: Tree<T>, right: T) {
    try! _ = left.remove(lookingFor: right)  // ignore the rvalue to silence the compiler
}

infix operator <> : LogicalConjunctionPrecedence
func <> <T>( left: Tree<T>, right: T ) -> Bool {
    return left.contains(lookingFor: right)
}

infix operator !<> :  LogicalConjunctionPrecedence
func !<> <T>( left: Tree<T>, right: T ) -> Bool {
    return !left.contains(lookingFor: right)
}

extension Tree {
    subscript (index:Int)->T {      // read-only access, so explicit get{...} not
        return asArray()[index]     // required
    }

    // One could take two approaches to finding the Nth element. One is to
    // traverse the tree in order, increment a counter on each visit, and stop
    // when we reach the Nth node. The other approach is to do a full traversal
    // an build an array that holds the nodes in order. The latter approach
    // makes more sense if we're going to do things like traverse the tree as
    // if it were an array, or if we access the nodes by array index regularly.
    // So, that's what I've done. Note that that I only rebuild the array if
    // I have to (i.e. the tree hasn't been modified since the last time I
    // used it). The add() and remove() methods set arrayVersion to nil to
    // force me to rebuild it.

    public func asArray() -> [T] {
        if let array = arrayVersion {
            return array
        }
        else {
            arrayVersion = []
            traverse(direction: .Inorder ){ self.arrayVersion!.append($0); return true }
        }
        return arrayVersion!
    }
}

extension Tree {
    public func filter( okay: (T)->Bool ) -> Tree<T> {
        let result: Tree<T> = [];
        forEveryElement {
            if(okay($0)) {
                result.add(element: $0)
            }
        }
        return result
    }

    public func map( transform: (T)->T ) -> Tree<T> {
        let result: Tree<T> = [];
        forEveryElement {
            result.add(element: transform($0) )
        }
        return result
    }

    public func reduce<U>(first: U, combine: (U, T) -> U) -> U {
        var combined = first;
        forEveryElement {
            combined = combine(combined, $0)
        }
        return combined
    }
}


// @TODO Remaining work for class Tree
// https://xploden.com/swift-extending-sequencetype-for-custom-array-sorting-6dba17f36552
// overload operarators <> and !<>
// Contains operator:
//    t <> "x"  is true if t is a Tree<String> that contains "x"
//    t !<> "x" is true if t is a Tree<String> that doesn't contain "x"
// https://swiftdoc.org/v5.1/protocol/sequence/
// https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#grammar_precedence-group-declaration
// infix operator <> { associativity left precedence 130 } // same as other relational ops
// infix operator !<> { associativity left precedence 130 } // same as other relational ops

public class TreeGenerator<T>: IteratorProtocol {
    var current = 0;
    let items:[T]
    init(items:[T]) { self.items = items }
    public func next() -> T? {
        if current >= items.count {
            return nil
        }
        current += 1
        return items[current]
    }
}

extension Tree: Sequence {
    public func makeIterator() -> TreeGenerator<T> {
       return TreeGenerator<T>(items: asArray())
    }
}
