#import "Cat.h"
#import "DBModel.h"


@interface Cat ()

+ (NSString*) genderByBool:(BOOL)gender;

- (id)initWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)ctx;

@property (weak) UIImage *_image;

@end


@implementation Cat

@dynamic breed;
@dynamic name;
@dynamic male;
@dynamic price;
@dynamic birth;
@dynamic imagePath;

@dynamic myId;
@dynamic fatherId;
@dynamic motherId;

@synthesize _image;


#pragma mark - Core Data

+ (NSEntityDescription *)entityFromContext:(NSManagedObjectContext *)ctx
{
    return [NSEntityDescription entityForName:@"Cat" inManagedObjectContext:ctx];
}

+ (NSArray*)catsFromPlist:(NSString *)plistPath andContext:(NSManagedObjectContext *)ctx
{
    NSString *plpath = [[NSBundle mainBundle] pathForResource:plistPath ofType:@""];
    NSAssert(plpath, @"catlist.plist not found");
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:plpath];
    NSAssert(plist, @"catlist.plist incorrect format: %@", plist);
    
    NSArray *catDict = [plist objectForKey:@"cats"];
    NSAssert(catDict, @"catlist.plist incorrect format: %@", catDict);
    
    NSMutableArray *cats = [NSMutableArray new];
    
    for (NSDictionary *dict in catDict)
    {
        Cat *kitten = [[Cat alloc] initWithDict:dict andContext:ctx];
        NSAssert(kitten, @"Error loading kitten in %@", dict);
        [cats addObject:kitten];
    }
    
    NSError *err;
    if (![ctx save:&err]) {
        NSLog(@"DB save error: %@", [err localizedDescription]);
    }
    
    return [cats copy];
}


#pragma mark - Static

+ (NSManagedObjectContext *)context
{
    return [[DBModel dbModel] managedObjectContext];
}

+ (NSManagedObjectModel *)model
{
    return [[DBModel dbModel] managedObjectModel];
}

+ (NSArray*) cats
{
    static NSArray *catArray;
#define CAT_REQ_ALL @"AllCats"

    if (catArray == nil)
    {
        NSFetchRequest *fetchRequest = [[self model] fetchRequestTemplateForName:CAT_REQ_ALL];
//        fetchRequest.entity = [Cat entityFromContext:[self context]];
        NSError *err;
        
        catArray = [[self context] executeFetchRequest:fetchRequest error:&err];
        NSAssert(catArray,@"fetchRequest %@ failed: %@", CAT_REQ_ALL, [err localizedDescription]);
        
        NSLog(@"loaded %d cats from DB", catArray.count);
        
        if (catArray.count == 0)
        {
            NSLog(@"loading from plist");
            catArray = [self catsFromPlist:@"catlist.plist" andContext:[self context]];
        }
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
    return [Cat genderByBool:self.male];
}

#pragma Lifetime

- (BOOL)delete:(NSError **)error
{
    [[Cat context] deleteObject:self];
    
    return [[Cat context] save:error];
}

- (BOOL)save:(NSError **)error
{
    return [[Cat context] save:error];
}

- (id)init
{
    return [self initWithEntity:[Cat entityFromContext:[Cat context]] insertIntoManagedObjectContext:[Cat context]];
}


- (id)initWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)ctx
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

    if((self = [self initWithEntity:[Cat entityFromContext:ctx] insertIntoManagedObjectContext:ctx]))
    {
        self.imagePath = KITTEN_VALUE([[NSBundle mainBundle]
                              pathForResource:KITTEN_VALUE([dict objectForKey:@"image"])
                              ofType:@""]);
        self.breed = KITTEN_VALUE([dict objectForKey:@"breed"]);
        self.male = [KITTEN_VALUE([dict objectForKey:@"gender"]) boolValue];
        self.name = KITTEN_VALUE([dict objectForKey:@"name"]);
        self.price = [KITTEN_VALUE([dict objectForKey:@"price"]) integerValue];
        self.birth = KITTEN_VALUE([dict objectForKey:@"birth"]);
        
        self.myId = [KITTEN_VALUE([dict objectForKey:@"id"]) integerValue];
        self.fatherId = [KITTEN_VALUE([dict objectForKey:@"father"]) integerValue];
        self.motherId = [KITTEN_VALUE([dict objectForKey:@"mother"]) integerValue];
    }
    return self;
}

@end
