
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
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

#import "RAViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface RAViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation RAViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  RADataObject *phone1 = [RADataObject dataObjectWithName:@"Phone 1" children:nil];
  RADataObject *phone2 = [RADataObject dataObjectWithName:@"Phone 2" children:nil];
  RADataObject *phone3 = [RADataObject dataObjectWithName:@"Phone 3" children:nil];
  RADataObject *phone4 = [RADataObject dataObjectWithName:@"Phone 4" children:nil];
  
  RADataObject *phone = [RADataObject dataObjectWithName:@"Phones"
                                                children:[NSArray arrayWithObjects:phone1, phone2, phone3, phone4, nil]];
  
  RADataObject *notebook1 = [RADataObject dataObjectWithName:@"Notebook 1" children:nil];
  RADataObject *notebook2 = [RADataObject dataObjectWithName:@"Notebook 2" children:nil];
  self.expanded = notebook1;
  
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
  
  RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
  
  treeView.delegate = self;
  treeView.dataSource = self;
  treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
  
  [treeView reloadData];
  [treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
  [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
  
  self.treeView = treeView;
  [self.view addSubview:treeView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
    CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
    float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
    self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
    self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
  }
  self.treeView.frame = self.view.bounds;
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
  if ([item isEqual:self.expanded]) {
    return YES;
  }
  return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  if (treeNodeInfo.treeDepthLevel == 0) {
    cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
  } else if (treeNodeInfo.treeDepthLevel == 1) {
    cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
  } else if (treeNodeInfo.treeDepthLevel == 2) {
    cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
  }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  NSInteger numberOfChildren = [treeNodeInfo.children count];
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
  cell.textLabel.text = ((RADataObject *)item).name;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (treeNodeInfo.treeDepthLevel == 0) {
    cell.detailTextLabel.textColor = [UIColor blackColor];
  }
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
  return [data.children objectAtIndex:index];
}

@end
