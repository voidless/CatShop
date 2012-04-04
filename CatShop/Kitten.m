#import "Kitten.h"


@interface Kitten ()

+ (NSString*) genderByBool:(BOOL)gender;

- (id)initWithDict:(NSDictionary*)dict;

@end



@implementation Kitten

@synthesize breed;
@synthesize name;
@synthesize male;
@synthesize imagePath;
@synthesize price;
@synthesize birth;

@synthesize myId;
@synthesize fatherId;
@synthesize motherId;

#define SORT_INFO_FILENAME @"sortInfo.dat"


#pragma mark - Static

+ (NSArray*) kittens
{
    static NSArray *catArray;

    if (catArray == nil)
    {        
        NSString *plpath = [[NSBundle mainBundle] pathForResource:@"catlist.plist" ofType:@""];
        NSAssert(plpath, @"catlist.plist not found");
        NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:plpath];
        NSAssert(plist, @"catlist.plist incorrect format: %@", plist);
        
        NSArray *catDict = [plist objectForKey:@"cats"];
        NSAssert(catDict, @"catlist.plist incorrect format: %@", catDict);
        
        NSMutableArray *cats = [NSMutableArray new];
        
        for (NSDictionary *dict in catDict)
        {
            Kitten *kitten = [[Kitten new] initWithDict:dict];
            NSAssert(kitten, @"Error loading kitten in %@", dict);
            [cats addObject:kitten];
        }
        
        catArray = [cats copy];
    }  
    
    return catArray;
}

+ (NSArray*) kittensOnSale
{
    NSMutableArray *catArr = [NSMutableArray new];
    
    for (Kitten *k in [self kittens])
    {
        if (k.price > 0)
        {
            [catArr addObject:k];
        }
    }
    
    return [catArr copy];
}

+ (Kitten*) kittenWithKittenId:(NSInteger)kittenId
{
    for (Kitten *k in [self kittens])
    {
        if (k.myId == kittenId)
        {
            return k;
        }
    }
    
    return nil;
}

+ (NSString*) genderByBool:(BOOL)gender
{
    static NSDictionary* genders;
    
    if (genders == nil)
    {
        NSString *plpath = [[NSBundle mainBundle] pathForResource:@"gender.plist" ofType:@""];
        NSAssert(plpath, @"gender.plist not found");
        genders = [[NSDictionary alloc] initWithContentsOfFile:plpath];
        NSAssert(genders, @"gender.plist incorrect format: %@", genders);        
    }
    
    return (gender ? [genders objectForKey:@"male"] : [genders objectForKey:@"female"]);
}

+ (NSInteger)kittensCount
{
    return [[self kittens] count];
}

#pragma mark Sorting

+ (NSMutableArray*) sortInfo
{
    static NSMutableArray *sortInfo;
    if (sortInfo == nil)
    {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sortInfoPath = [docPath stringByAppendingPathComponent:SORT_INFO_FILENAME];
        
        sortInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:sortInfoPath];
    }
    if (sortInfo == nil)
    {
        sortInfo = [NSMutableArray new];
        for (Kitten *k in [self kittens])
        {
            [sortInfo addObject:[NSNumber numberWithInteger:k.myId]];
        }
        NSLog(@"created sorted array: %@", sortInfo);
    }
    
    // TODO: add new cats to the array
    
    return sortInfo;
}

+ (Kitten*) kittenSortedAtIndex:(NSInteger)index
{
    NSInteger idx = [[[self sortInfo] objectAtIndex:index] integerValue];
    return [self kittenWithKittenId:idx];
}

+ (void) moveKittenSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx
{
    NSMutableArray *ma = [self sortInfo];
    NSNumber *myId = [ma objectAtIndex:sourceIdx];
    [ma removeObjectAtIndex:sourceIdx];
    [ma insertObject:myId atIndex:destinationIdx];
}

#pragma mark - Instance

- (id)initWithDict:(NSDictionary*)dict
{


#define KITTEN_VALUE(val) \
    ({\
        id obj = val;\
        if (!obj) {\
            self = nil;\
            return self;\
        }\
        obj;\
    })

    if((self = [super init])) {
        imagePath = KITTEN_VALUE([[NSBundle mainBundle]
                              pathForResource:KITTEN_VALUE([dict objectForKey:@"image"])
                              ofType:@""]);
        breed = KITTEN_VALUE([dict objectForKey:@"breed"]);
        male = [KITTEN_VALUE([dict objectForKey:@"gender"]) boolValue];
        name = KITTEN_VALUE([dict objectForKey:@"name"]);
        price = [KITTEN_VALUE([dict objectForKey:@"price"]) integerValue];
        birth = KITTEN_VALUE([dict objectForKey:@"birth"]);
        
        myId = [KITTEN_VALUE([dict objectForKey:@"id"]) integerValue];
        fatherId = [KITTEN_VALUE([dict objectForKey:@"father"]) integerValue];
        motherId = [KITTEN_VALUE([dict objectForKey:@"mother"]) integerValue];
    }

    return self;
}

- (NSString*)gender
{
    return [Kitten genderByBool:male];
}


@end
