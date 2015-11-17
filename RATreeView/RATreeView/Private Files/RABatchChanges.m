
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
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

#import "RABatchChanges.h"
#import "RABatchChangeEntity.h"


@interface RABatchChanges ()

@property (nonatomic, strong) NSMutableArray *operationsStorage;
@property (nonatomic) NSInteger batchChangesCounter;

@end



@implementation RABatchChanges

- (id)init
{
  self = [super init];
  if (self) {
    _batchChangesCounter = 0;
  }
  
  return self;
}

- (void)beginUpdates
{
  if (self.batchChangesCounter++ == 0) {
    self.operationsStorage = [NSMutableArray array];
  }
}

- (void)endUpdates
{
  self.batchChangesCounter--;
  if (self.batchChangesCounter == 0) {
    [self.operationsStorage sortUsingSelector:@selector(compare:)];
    
    for (RABatchChangeEntity *entity in self.operationsStorage) {
      entity.updatesBlock();
    }
    self.operationsStorage = nil;
  }
}

- (void)insertItemWithBlock:(void (^)())update atIndex:(NSInteger)index
{
  RABatchChangeEntity *entity = [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                           type:RABatchChangeTypeItemRowInsertion
                                                                        ranking:index];
  [self addBatchChangeEntity:entity];
}

- (void)expandItemWithBlock:(void (^)())update atIndex:(NSInteger)index
{
  RABatchChangeEntity *entity= [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                          type:RABatchChangeTypeItemRowExpansion
                                                                       ranking:index];
  [self addBatchChangeEntity:entity];
}

- (void)deleteItemWithBlock:(void (^)())update lastIndex:(NSInteger)lastIndex
{
  RABatchChangeEntity *entity = [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                           type:RABatchChangeTypeItemRowDeletion
                                                                        ranking:lastIndex];
  [self addBatchChangeEntity:entity];
}

- (void)collapseItemWithBlock:(void (^)())update lastIndex:(NSInteger)lastIndex
{
  RABatchChangeEntity *entity = [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                           type:RABatchChangeTypeItemRowCollapse
                                                                        ranking:lastIndex];
  [self addBatchChangeEntity:entity];
}

- (void)moveItemWithDeletionBlock:(void (^)())deletionUpdate fromLastIndex:(NSInteger)lastIndex additionBlock:(void (^)())additionUpdate toIndex:(NSInteger)index
{
  RABatchChangeEntity *firstEntity = [RABatchChangeEntity batchChangeEntityWithBlock:deletionUpdate
                                                                                type:RABatchChangeTypeItemRowDeletion
                                                                             ranking:lastIndex];
  
  RABatchChangeEntity *secondEntity = [RABatchChangeEntity batchChangeEntityWithBlock:additionUpdate
                                                                                 type:RABatchChangeTypeItemRowInsertion
                                                                              ranking:index];
  [self addBatchChangeEntity:firstEntity];
  [self addBatchChangeEntity:secondEntity];
}

#pragma mark -

- (void)addBatchChangeEntity:(RABatchChangeEntity *)entity
{
  if (self.batchChangesCounter > 0) {
    [self.operationsStorage addObject:entity];
  } else {
    entity.updatesBlock();
  }
}



@end
