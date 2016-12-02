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
        treeView.register(UINib(nibName: String(describing: TreeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TreeTableViewCell.self))
    }
    
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? DataObject {
            return item.children.count
        } else {
            return data.count
        }
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        guard let cell = treeView.dequeueReusableCell(withIdentifier: String(describing: TreeTableViewCell.self)) as? TreeTableViewCell,
            let item = item as? DataObject else {
                fatalError()
        }
        
        let level = treeView.levelForCell(forItem: item)
        cell.setup(withTitle: item.name, detailsText: "Number of children: \(item.children.count)", level: level)
        
        return cell
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return data[index]
        } else if let item = item as? DataObject {
            return item.children[index]
        } else {
            fatalError()
        }
    }
    
    func treeView(_ treeView: RATreeView, canEditRowForItem item: Any) -> Bool {
        return false
    }
    
    func treeView(_ treeView: RATreeView, commit editingStyle: UITableViewCellEditingStyle, forRowForItem item: Any) {
        
    }
    
}

