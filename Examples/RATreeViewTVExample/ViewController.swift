//
//  ViewController.swift
//  RATreeViewTVExample
//
//  Created by Rafal Augustyniak on 21/08/16.
//  Copyright © 2016 com.Augustyniak. All rights reserved.
//

import UIKit
import RATreeView

class ViewController: UIViewController, RATreeViewDataSource {
    
    var data : [DataObject] = DataObject.defaultTreeRootChildren()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let treeView = RATreeView()
        view.addSubview(treeView)
        treeView.frame = view.bounds
        treeView.dataSource = self
        treeView.registerNib(UINib.init(nibName: String(TreeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(TreeTableViewCell.self))
    }
    
    func treeView(treeView: RATreeView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item = item as? DataObject {
            return item.children.count
        } else {
            return data.count
        }
    }
    
    func treeView(treeView: RATreeView, cellForItem item: AnyObject?) -> UITableViewCell {
        guard let cell = treeView.dequeueReusableCellWithIdentifier(String(TreeTableViewCell.self)) as? TreeTableViewCell,
            let item = item as? DataObject else {
                fatalError()
        }
        
        let level = treeView.levelForCellForItem(item)
        cell.setup(withTitle: item.name, detailsText: "Number of children: \(item.children.count)", level: level)
        
        return cell
    }
    
    func treeView(treeView: RATreeView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            return data[index]
        } else if let item = item as? DataObject {
            return item.children[index]
        } else {
            fatalError()
        }
    }
    
    func treeView(treeView: RATreeView, canEditRowForItem item: AnyObject) -> Bool {
        return false
    }
    
    func treeView(treeView: RATreeView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowForItem item: AnyObject) {
        
    }
    
}

