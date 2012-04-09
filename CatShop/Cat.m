#import "Cat.h"


@interface Cat ()

+ (NSString*) genderByBool:(BOOL)gender;

- (id)initWithDict:(NSDictionary*)dict;

@property (weak) UIImage *_image;

@end


@implementation Cat

@synthesize breed;
@synthesize name;
@synthesize male;
@synthesize price;
@synthesize birth;
@synthesize imagePath;

@synthesize myId;
@synthesize fatherId;
@synthesize motherId;

@synthesize _image;


#pragma mark - Static

+ (NSArray*) cats
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
            Cat *kitten = [[Cat new] initWithDict:dict];
            NSAssert(kitten, @"Error loading kitten in %@", dict);
            [cats addObject:kitten];
        }
        
        catArray = [cats copy];
    }  
    
    return catArray;
}

+ (NSArray*) catsOnSale
{
    NSMutableArray *catArr = [NSMutableArray new];
    
    for (Cat *k in [self cats])
    {
        if (k.price > 0)
        {
            [catArr addObject:k];
        }
    }
    
    return [catArr copy];
}

+ (Cat*) catWithId:(NSInteger)CatId
{
    for (Cat *k in [self cats])
    {
        if (k.myId == CatId)
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

+ (NSInteger)count
{
    return [[self cats] count];
}

#pragma mark - Instance


#pragma Getters

- (UIImage*)image
{
    UIImage *img = self._image;
    if (img == nil) {
        img = [UIImage imageWithContentsOfFile:self.imagePath];
        self._image = img;
    }
    return img;
}

- (NSString*)gender
{
    return [Cat genderByBool:male];
}

#pragma Lifetime


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


@end
