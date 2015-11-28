//
//  TreeViewController.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 21/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//


import UIKit
import RATreeView

class TreeViewController: UIViewController, RATreeViewDelegate, RATreeViewDataSource {

    var treeView : RATreeView!
    var data : [DataObject]
    var editButton : UIBarButtonItem!

    convenience init() {
        self.init(nibName : nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        data = TreeViewController.commonInit()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        data = TreeViewController.commonInit()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        title = "Things"
        setupTreeView()
        updateNavigationBarButtons()
    }

    func setupTreeView() -> Void {
        treeView = RATreeView(frame: view.bounds)
        treeView.registerNib(UINib.init(nibName: "TreeTableViewCell", bundle: nil), forCellReuseIdentifier: "TreeTableViewCell")
        treeView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue)
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = UIView()
        treeView.backgroundColor = UIColor.clearColor()
        view.addSubview(treeView)
    }

    func updateNavigationBarButtons() -> Void {
        let systemItem = treeView.editing ? UIBarButtonSystemItem.Done : UIBarButtonSystemItem.Edit;
        self.editButton = UIBarButtonItem.init(barButtonSystemItem: systemItem, target: self, action: "editButtonTapped:")
        self.navigationItem.rightBarButtonItem = self.editButton;
    }

    func editButtonTapped(sender : AnyObject) -> Void {
        treeView.setEditing(!treeView.editing, animated: true)
        updateNavigationBarButtons()
    }


    //MARK: RATreeView data source

    func treeView(treeView: RATreeView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item = item as? DataObject {
            return item.children.count
        } else {
            return self.data.count
        }
    }

    func treeView(treeView: RATreeView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let item = item as? DataObject {
            return item.children[index]
        } else {
            return data[index] as AnyObject
        }
    }

    func treeView(treeView: RATreeView, cellForItem item: AnyObject?) -> UITableViewCell {
        let cell = treeView.dequeueReusableCellWithIdentifier("TreeTableViewCell") as! TreeTableViewCell
        let item = item as! DataObject

        let level = treeView.levelForCellForItem(item)
        let detailsText = "Number of children \(item.children.count)"
        cell.selectionStyle = .None
        cell.setup(withTitle: item.name, detailsText: detailsText, level: level, additionalButtonHidden: false)
        cell.additionButtonActionBlock = { [weak treeView] cell in
            guard let treeView = treeView else {
                return;
            }
            let item = treeView.itemForCell(cell) as! DataObject
            let newItem = DataObject(name: "Added value")
            item.addChild(newItem)
            treeView.insertItemsAtIndexes(NSIndexSet.init(index: 0), inParent: item, withAnimation: RATreeViewRowAnimationNone);
            treeView.reloadRowsForItems([item], withRowAnimation: RATreeViewRowAnimationNone)
        }
        return cell
    }

    //MARK: RATreeView delegate

    func treeView(treeView: RATreeView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowForItem item: AnyObject) {
        guard editingStyle == .Delete else { return; }
        let item = item as! DataObject
        let parent = treeView.parentForItem(item) as? DataObject

        var index = 0
        if let parent = parent {
            parent.children.indexOf({ dataObject in
                return dataObject === item
            })!
            parent.removeChild(item)

        } else {
            index = self.data.indexOf({ dataObject in
                return dataObject === item;
            })!
            self.data.removeAtIndex(index)
        }

        self.treeView.deleteItemsAtIndexes(NSIndexSet.init(index: index), inParent: parent, withAnimation: RATreeViewRowAnimationRight)
        if let parent = parent {
            self.treeView.reloadRowsForItems([parent], withRowAnimation: RATreeViewRowAnimationNone)
        }
    }
}


private extension TreeViewController {

    static func commonInit() -> [DataObject] {
        let phone1 = DataObject(name: "Phone 1")
        let phone2 = DataObject(name: "Phone 2")
        let phone3 = DataObject(name: "Phone 3")
        let phone4 = DataObject(name: "Phone 4")
        let phones = DataObject(name: "Phones", children: [phone1, phone2, phone3, phone4])

        let notebook1 = DataObject(name: "Notebook 1")
        let notebook2 = DataObject(name: "Notebook 2")

        let computer1 = DataObject(name: "Computer 1", children: [notebook1, notebook2])
        let computer2 = DataObject(name: "Computer 2")
        let computer3 = DataObject(name: "Computer 3")
        let computers = DataObject(name: "Computers", children: [computer1, computer2, computer3])

        let cars = DataObject(name: "Cars")
        let bikes = DataObject(name: "Bikes")
        let houses = DataObject(name: "Houses")
        let flats = DataObject(name: "Flats")
        let motorbikes = DataObject(name: "motorbikes")
        let drinks = DataObject(name: "Drinks")
        let food = DataObject(name: "Food")
        let sweets = DataObject(name: "Sweets")
        let watches = DataObject(name: "Watches")
        let walls = DataObject(name: "Walls")

        return [phones, computers, cars, bikes, houses, flats, motorbikes, drinks, food, sweets, watches, walls]
    }

}

