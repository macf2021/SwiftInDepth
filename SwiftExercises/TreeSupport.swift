//  TreeSupport.swift
//  Copyright © 2015 Allen Holub. All rights reserved.
//
// Various tree-support classes needed for the generic versions.
//
// These need to be global becuase we can't nest enums in a generic
// class.
/* Allen Holub's Pluralsite Swift 2.x code Sept 2015 converted to Swift 5.1 by hand
 * by Michael MacFaden Sept 2022.
 */
public enum Ordering { case Inorder, Postorder, Preorder }
public enum Direction{ case Left, Right }
public enum TreeError : Error { case Empty }    // used by remove()

