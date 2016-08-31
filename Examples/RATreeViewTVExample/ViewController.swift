//
//  ViewController.swift
//  RATreeViewTVExample
//
//  Created by Rafal Augustyniak on 21/08/16.
//  Copyright © 2016 com.Augustyniak. All rights reserved.
//

import UIKit
import RATreeView

class ViewController: UITableViewController, RATreeViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        let treeView = RATreeView()
        view.addSubview(treeView)
        treeView.frame = view.bounds
        treeView.dataSource = self
    }

    func treeView(treeView: RATreeView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item = item {
            return 0
        } else {
            return 1
        }
    }

    func treeView(treeView: RATreeView, cellForItem item: AnyObject?) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") else {
            fatalError()
        }
        return cell
    }

    func treeView(treeView: RATreeView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        return "1"
    }

    func treeView(treeView: RATreeView, canEditRowForItem item: AnyObject) -> Bool {
        return false
    }

    func treeView(treeView: RATreeView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowForItem item: AnyObject) {
    }

}

