//
//  RABatchChangeEntityTests.m
//  RATreeView
//
//  Created by Rafal Augustyniak on 17/11/15.
//  Copyright © 2015 Rafal Augustyniak. All rights reserved.
//


#import "RABatchChangeEntity.h"

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>


@interface RABatchChangeEntityTests : XCTestCase

@end


@implementation RABatchChangeEntityTests

- (void)testWhetherExpansionOperationWithGreaterRankingIsGreaterThanExpansionOperationWithLowerRanking
{
    RABatchChangeEntity *entity1 = [RABatchChangeEntity batchChangeEntityWithBlock:^{}
                                                                              type:RABatchChangeTypeItemRowExpansion
                                                                           ranking:1];
    RABatchChangeEntity *entity2 = [RABatchChangeEntity batchChangeEntityWithBlock:^{}
                                                                              type:RABatchChangeTypeItemRowExpansion
                                                                           ranking:2];
    NSArray *items = @[entity1, entity2];
    items = [items sortedArrayUsingSelector:@selector(compare:)];

    XCTAssertTrue(RAIsAscendingOrder(items, entity1, entity2));
}

- (void)testWhetherCollapseOperationWithLowerRankingIsGreaterThanCollapseOperationWithGreaterRanking
{
    RABatchChangeEntity *entity1 = [RABatchChangeEntity batchChangeEntityWithBlock:^{}
                                                                              type:RABatchChangeTypeItemRowCollapse
                                                                           ranking:1];
    RABatchChangeEntity *entity2 = [RABatchChangeEntity batchChangeEntityWithBlock:^{}
                                                                              type:RABatchChangeTypeItemRowCollapse
                                                                           ranking:2];
    NSArray *items = @[entity1, entity2];
    items = [items sortedArrayUsingSelector:@selector(compare:)];
    XCTAssertTrue(RAIsDescendingOrder(items, entity1, entity2));
}

- (void)testWhetherExpansionOperationsAreGreaterThanCollapseOperations
{
    void (^performTestScenarion)(NSInteger expansionRanking, NSInteger collapseRanking) = ^(NSInteger expansionRanking, NSInteger collapseRanking) {
        RABatchChangeEntity *entity1 = [RABatchChangeEntity batchChangeEntityWithBlock:^{}
                                                                                  type:RABatchChangeTypeItemRowExpansion
                                                                               ranking:expansionRanking];
        RABatchChangeEntity *entity2 = [RABatchChangeEntity batchChangeEntityWithBlock:^{}
                                                                                  type:RABatchChangeTypeItemRowCollapse
                                                                               ranking:collapseRanking];
        NSArray *items = @[entity1, entity2];
        items = [items sortedArrayUsingSelector:@selector(compare:)];
        XCTAssertTrue(RAIsDescendingOrder(items, entity1, entity2));
    };

    performTestScenarion(1, 0);
    performTestScenarion(1, 1);
    performTestScenarion(1, 2);
}


#pragma mark -

static BOOL RAIsAscendingOrder(NSArray *items, id item1, id item2)
{
    return RAOrdering(items, item1, item2) == NSOrderedAscending;
}

static BOOL RAIsDescendingOrder(NSArray *items, id item1, id item2)
{
    return RAOrdering(items, item1, item2) == NSOrderedDescending;
}

static NSComparisonResult RAOrdering(NSArray *items, id item1, id item2)
{
    NSInteger index1 = [items indexOfObject:item1];
    NSInteger index2 = [items indexOfObject:item2];
    return [@(index1) compare:@(index2)];
}

@end
