#import "SortedCat.h"

@interface SortedCat ()

@end

@implementation SortedCat

@synthesize catId;
@synthesize sortRating;

static NSInteger Cat_old_count;
static BOOL Cat_DB_Changed;

#define SORT_INFO_FILENAME @"sortInfo.dat"

#pragma mark Sorting

+ (NSMutableArray*) sortInfo
{
    static NSMutableArray *sortInfo;
    if (sortInfo == nil)
    {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sortInfoPath = [docPath stringByAppendingPathComponent:SORT_INFO_FILENAME];
        
        sortInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:sortInfoPath];
        
        if (sortInfo == nil)
        {
            sortInfo = [NSMutableArray new];
            for (Cat *k in [Cat cats])
            {
                [sortInfo addObject:[NSNumber numberWithInteger:k.myId]];
            }
        }
        
        Cat_DB_Changed = YES;
    }
    
    if (Cat_DB_Changed)
    {
        for (Cat *k in [Cat cats])
        {
            if ([sortInfo indexOfObject:[NSNumber numberWithInteger:k.myId]] == NSNotFound)
            {
//                NSLog(@"added cat with id: %d", k.myId);
                [sortInfo addObject:[NSNumber numberWithInteger:k.myId]];
            }
        }
    }
    
    return sortInfo;
}

+ (Cat*) catSortedAtIndex:(NSInteger)index
{
    Cat *k = nil;

    NSInteger _index = index;
    
    if (Cat_old_count != [Cat count])
    {
        Cat_DB_Changed = YES;
        Cat_old_count = [Cat count];
    }
    
    NSAssert(index < [Cat count], @"kittenSortedAtIndex: index %d out of range", index);
    
    // assume sortInfo.count always >= [Kitten count]
    for (int idx = 0; idx < [self sortInfo].count; idx++)
    {
        k = [Cat catWithId:[[[self sortInfo] objectAtIndex:idx] integerValue]];
        if (k) {
            if (index == 0) {
                return k;
            }
            // skip 'index' number of existing kittens to allow removed kittens
            index --;
        }
    }
    NSAssert(k == nil, @"kitten not found with id: %d. sortTable: %@", _index, [self sortInfo]);
    return k;
}

+ (void) moveCatSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx
{
    NSMutableArray *sortInfo = [self sortInfo];
    NSNumber *myId = [sortInfo objectAtIndex:sourceIdx];
    [sortInfo removeObjectAtIndex:sourceIdx];
    [sortInfo insertObject:myId atIndex:destinationIdx];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sortInfoPath = [docPath stringByAppendingPathComponent:SORT_INFO_FILENAME];
    [NSKeyedArchiver archiveRootObject:sortInfo toFile:sortInfoPath];
}

@end
