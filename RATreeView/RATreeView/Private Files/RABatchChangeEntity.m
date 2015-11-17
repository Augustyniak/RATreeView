//
//  RABatchChangesEntity.m
//  RATreeView
//
//  Created by Rafal Augustyniak on 17/11/15.
//  Copyright © 2015 Rafal Augustyniak. All rights reserved.
//


#import "RABatchChangeEntity.h"


@implementation RABatchChangeEntity

+ (instancetype)batchChangeEntityWithBlock:(void (^)())updates type:(RABatchChangeType)type ranking:(NSInteger)ranking
{
    NSParameterAssert(updates);
    RABatchChangeEntity *entity = [RABatchChangeEntity new];
    entity.type = type;
    entity.ranking = ranking;
    entity.updatesBlock = updates;

    return entity;
}

- (NSComparisonResult)compare:(RABatchChangeEntity *)otherEntity
{
    if ([self destructiveOperation]) {
        if (![otherEntity destructiveOperation]) {
            return NSOrderedAscending;
        } else {
            return [@(otherEntity.ranking) compare:@(self.ranking)];
        }
    } else if (self.type == RABatchChangeTypeItemMove && otherEntity.type != RABatchChangeTypeItemMove) {
        return [otherEntity destructiveOperation] ? NSOrderedAscending : NSOrderedDescending;

    } else if ([self constructiveOperation]) {
        if (![otherEntity constructiveOperation]) {
            return NSOrderedDescending;
        } else {
            return [@(self.ranking) compare:@(otherEntity.ranking)];
        }

    } else {
        return NSOrderedSame;
    }
}

- (BOOL)constructiveOperation
{
    return self.type == RABatchChangeTypeItemRowExpansion
    || self.type == RABatchChangeTypeItemRowInsertion;
}

- (BOOL)destructiveOperation
{
    return self.type == RABatchChangeTypeItemRowCollapse
    || self.type == RABatchChangeTypeItemRowDeletion;
}

@end

