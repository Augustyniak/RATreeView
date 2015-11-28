//
//  DataObject.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 22/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import Foundation


class DataObject
{
    let name : String
    private(set) var children : [DataObject]

    init(name : String, children: [DataObject]) {
        self.name = name
        self.children = children
    }

    convenience init(name : String) {
        self.init(name: name, children: [DataObject]())
    }

    func addChild(child : DataObject) {
        self.children.append(child)
    }

    func removeChild(child : DataObject) {
        self.children = self.children.filter( {$0 !== child})
    }
}