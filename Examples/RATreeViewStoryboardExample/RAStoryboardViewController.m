
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//Copyright (c) 2016 Patrick Schneider
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RAStoryboardViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"

#import "RAStoryboardTableViewCell.h"


@interface RAStoryboardViewController () <RATreeViewDelegate, RATreeViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) IBOutlet RATreeView *treeView;

@property (strong, nonatomic) UIBarButtonItem *editButton;

@end

@implementation RAStoryboardViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self loadData];
  
  self.treeView.treeFooterView = [UIView new];
  self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;

  UIRefreshControl *refreshControl = [UIRefreshControl new];
  [refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
  [self.treeView.scrollView addSubview:refreshControl];
  
  [self.treeView reloadData];
  [self.treeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
  
  [self.navigationController setNavigationBarHidden:NO];
  [self updateNavigationItemButton];
  
  self.treeView.scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  int systemVersion = [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue];
  if (systemVersion == 7) {
    CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
    float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
    self.treeView.scrollView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
    self.treeView.scrollView.contentOffset = CGPointMake(0.0, -heightPadding);
  }
}


#pragma mark - Actions 

- (void)refreshControlChanged:(UIRefreshControl *)refreshControl
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [refreshControl endRefreshing];
  });
}

- (void)editButtonTapped:(id)sender
{
  [self.treeView setEditing:!self.treeView.isEditing animated:YES];
  [self updateNavigationItemButton];
}

- (void)updateNavigationItemButton
{
  UIBarButtonSystemItem systemItem = self.treeView.isEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
  self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(editButtonTapped:)];
  self.navigationItem.rightBarButtonItem = self.editButton;
}


#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
  return 44;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
  return YES;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
  RAStoryboardTableViewCell *cell = (RAStoryboardTableViewCell *)[treeView cellForItem:item];
  [cell setAdditionButtonHidden:NO animated:YES];
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
  RAStoryboardTableViewCell *cell = (RAStoryboardTableViewCell *)[treeView cellForItem:item];
  [cell setAdditionButtonHidden:YES animated:YES];
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
  if (editingStyle != UITableViewCellEditingStyleDelete) {
    return;
  }
  
  RADataObject *parent = [self.treeView parentForItem:item];
  NSInteger index = 0;
  
  if (parent == nil) {
    index = [self.data indexOfObject:item];
    NSMutableArray *children = [self.data mutableCopy];
    [children removeObject:item];
    self.data = [children copy];
    
  } else {
    index = [parent.children indexOfObject:item];
    [parent removeChild:item];
  }
  
  [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
  if (parent) {
    [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
  }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
  RADataObject *dataObject = item;
  
  NSInteger level = [self.treeView levelForCellForItem:item];
  NSInteger numberOfChildren = [dataObject.children count];
  NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
  BOOL expanded = [self.treeView isCellForItemExpanded:item];
  
  RAStoryboardTableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RAStoryboardTableViewCell class])];
  [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:!expanded];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  __weak typeof(self) weakSelf = self;
  cell.additionButtonTapAction = ^(id sender){
    if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
      return;
    }
    RADataObject *newDataObject = [[RADataObject alloc] initWithName:@"Added value" children:@[]];
    [dataObject addChild:newDataObject];
    [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
    [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
  };
  
  return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
  if (item == nil) {
    return [self.data count];
  }
  
  RADataObject *data = item;
  return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
  RADataObject *data = item;
  if (item == nil) {
    return [self.data objectAtIndex:index];
  }
  
  return data.children[index];
}

#pragma mark - Helpers 

- (void)loadData
{
  RADataObject *phone1 = [RADataObject dataObjectWithName:@"Phone 1" children:nil];
  RADataObject *phone2 = [RADataObject dataObjectWithName:@"Phone 2" children:nil];
  RADataObject *phone3 = [RADataObject dataObjectWithName:@"Phone 3" children:nil];
  RADataObject *phone4 = [RADataObject dataObjectWithName:@"Phone 4" children:nil];
  
  RADataObject *phone = [RADataObject dataObjectWithName:@"Phones"
                                                children:[NSArray arrayWithObjects:phone1, phone2, phone3, phone4, nil]];
  
  RADataObject *notebook1 = [RADataObject dataObjectWithName:@"Notebook 1" children:nil];
  RADataObject *notebook2 = [RADataObject dataObjectWithName:@"Notebook 2" children:nil];
  
  RADataObject *computer1 = [RADataObject dataObjectWithName:@"Computer 1"
                                                    children:[NSArray arrayWithObjects:notebook1, notebook2, nil]];
  RADataObject *computer2 = [RADataObject dataObjectWithName:@"Computer 2" children:nil];
  RADataObject *computer3 = [RADataObject dataObjectWithName:@"Computer 3" children:nil];
  
  RADataObject *computer = [RADataObject dataObjectWithName:@"Computers"
                                                   children:[NSArray arrayWithObjects:computer1, computer2, computer3, nil]];
  RADataObject *car = [RADataObject dataObjectWithName:@"Cars" children:nil];
  RADataObject *bike = [RADataObject dataObjectWithName:@"Bikes" children:nil];
  RADataObject *house = [RADataObject dataObjectWithName:@"Houses" children:nil];
  RADataObject *flats = [RADataObject dataObjectWithName:@"Flats" children:nil];
  RADataObject *motorbike = [RADataObject dataObjectWithName:@"Motorbikes" children:nil];
  RADataObject *drinks = [RADataObject dataObjectWithName:@"Drinks" children:nil];
  RADataObject *food = [RADataObject dataObjectWithName:@"Food" children:nil];
  RADataObject *sweets = [RADataObject dataObjectWithName:@"Sweets" children:nil];
  RADataObject *watches = [RADataObject dataObjectWithName:@"Watches" children:nil];
  RADataObject *walls = [RADataObject dataObjectWithName:@"Walls" children:nil];
  
  self.data = [NSArray arrayWithObjects:phone, computer, car, bike, house, flats, motorbike, drinks, food, sweets, watches, walls, nil];
}

#pragma mark - Scroll View Test

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  NSLog(@"Test: scrollViewDidEndDecelerating - %@ = %@", scrollView.delegate, self);
}

@end
