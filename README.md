RATreeView (iOS 7.0+, tvOS 9.0+) 
==============

👷 Project created and maintained by [Rafał Augustyniak](http://augustyniak.me). You can find me on twitter ([@RaAugustyniak](https://twitter.com/RaAugustyniak)).


Introduction
-----------------

[![Twitter: @raaugustyniak](https://img.shields.io/badge/contact-@raaugustyniak-blue.svg?style=flat)](https://twitter.com/raaugustyniak)
[![Build Status](https://img.shields.io/travis/Augustyniak/RATreeView/master.svg?style=flat)](https://travis-ci.org/Augustyniak/RATreeView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/RATreeView.svg?style=flat)](https://github.com/Augustyniak/RATreeView)
[![Platform](https://img.shields.io/cocoapods/p/RATreeView.svg?style=flat)](http://cocoadocs.org/docsets/RATreeView)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Augustyniak/RATreeView/blob/master/LICENCE.md)

iOS             |  tvOS
:-------------------------:|:-------------------------:
[![](https://raw.github.com/Augustyniak/RATreeView/master/Screens/animation.gif)](https://raw.github.com/Augustyniak/RATreeView/master/Screens/animation.gif)  | [![](https://raw.github.com/Augustyniak/RATreeView/master/Screens/tvos_animation.gif)](https://raw.github.com/Augustyniak/RATreeView/master/Screens/tvos_animation.gif)





RATreeView is a class designed to provide easy and pleasant way to work with tree views on iOS and tvOS. It works as a wrapper for the UITableView, defining its own delegate and data source methods which make working with tree data structures really easy.

RATreeView is highly customizable and has a lot of features. 


Installation
-----------------

### CocoaPods

[CocoaPods](http://www.cocoapods.org) is the recommended way to add RATreeView to your project.

1. Add additional entry to your Podfile.

  ```ruby
  pod "RATreeView", "~> 2.1.2"
  ```

2. Install Pod(s) running `pod install` command.
3. Include RATreeView using `#import <RATreeView.h>`.

###Source files

1. Downloaded the latest version of the library using [link](https://github.com/Augustyniak/RATreeView/archive/master.zip).
2. Copy content of the downloaded (and unzipped) zip file into your project by dragging it into Project's navigator files structure. 



Requirements
-----------------


* Xcode 5
* iOS 7 or newer/tvOS 9 or newer


Usage
-----------------


Check out the demo for example usage of library. Make sure you read the [RATreeView documentation on Cocoa Docs](http://cocoadocs.org/docsets/RATreeView/2.1.2).


### Basics

1. Add following import in file of your project when you want to use RATreeView:
 
   ```objc
   // In case you are using RATreeView with CocoaPods
   #import <RATreeView.h>
   ```
      
   ```objc
   // In case you are using RATreeView by simply copying 
   // source files of the RATreeView into your project
   #import "RATreeView.h"
   ``` 
 
2. Simplest way to initialize and configure RATreeView:

   ```objc
   RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
   treeView.delegate = self;
   treeView.dataSource = self;       
   [self.view addSubview:treeView];
   [treeView reloadData];
   ```
         
3. Implement required methods of the RATreeView's data source:
 
   ```objc
   - (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
   {
       return item ? 3 : 0;
   }
   ```

   ```objc
   - (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
   {
      // create and configure cell for *item*
      return cell
   }
   ```

   ```objc
   - (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
   {
      return @(index);
   }
   ```

###Adding Pull to Refresh control

Adding pull to refresh gesture is really easy using `RATreeView` and standard `UIRefreshControl` control.

[![](https://raw.github.com/Augustyniak/RATreeView/master/Screens/PullToRefresh.png)](https://raw.github.com/Augustyniak/RATreeView/master/Screens/PullToRefresh.png)

   ```objc
UIRefreshControl *refreshControl = [UIRefreshControl new];
[refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
[treeView.scrollView addSubview:refreshControl];
   ```

Documentation
-----------------

Documentation is available on [CocoaPods](http://cocoadocs.org/docsets/RATreeView/2.1.2).

TODO
-----------------

- Better delegate callbacks in case of recursive collapse and expand operations.
- Improved documentation.
- Unit tests.
- Re-order rows feature.
  
Author
-----------------

RATreeView was created by Rafał Augustyniak. You can find me on twitter ([@RaAugustyniak](https://twitter.com/RaAugustyniak)).


Release Notes 
-----------------

Information about newer versions of the library can be found in the [releases section](https://github.com/Augustyniak/RATreeView/releases) of the repository.

Version 1.0.2
- Fixed bug in select and deselect operations.
- Fixed bug in recursive expand operation (via @Arrnas).

Version 1.0.1
- Fixed bug in recursive expand operation.

Version 1.0.0

- Improved performance.
- Added recursive expand operation. It can be performed by using `expandRowForItem: expandChildren:withRowAnimation:` method. Default behavior is non recursive expand.
- Added recursive collapse operation. It can be performed by using `collapseRowForItem: expandChildren:withRowAnimation:` method. Default behavior is non recursive collapse.
- Fixed bug in `itemForRowAtPoint:` method when passed point isn't inside any cell.

Version 0.9.2

- Fixed bug in `endUpdates` method.

Version 0.9.1

- Fixed behaviour of treeView:willSelectRowForItem: delegate method.

Version 0.9.0

- Added possiblity to change content of the RATreeView dynamically. Possible row operations:
	- additions 
	- deletions 
    - repositions
- Added additional 'cell accessing' methods.
- Removed `RATreeNodeInfo` class.
- Added additional instance methods in RATreeView which substitute functionality provided by `RATreeNodeInfo` class.
- Bug fixes.

License
-----------------

MIT licensed, Copyright (c) 2014 Rafał Augustyniak, [@RaAugustyniak](http://twitter.com/RaAugustyniak)

