#import "Cat.h"
#import "NSManagedObjectContext+CatShopUtilities.h"

@interface Cat ()

+ (NSString *)genderByBool:(BOOL)gender;

- (id)initWithDict:(NSDictionary *)dict andContext:(NSManagedObjectContext *)ctx;

#define CAT_REQ_ALL @"AllCats"

@end


@implementation Cat

@dynamic breed;
@dynamic name;
@dynamic male;
@dynamic price;
@dynamic birth;
@dynamic imagePath;
@dynamic rating;

@dynamic myId;
@dynamic fatherId;
@dynamic motherId;

@synthesize image;


#pragma mark - Core Data

+ (NSEntityDescription *)entityFromContext:(NSManagedObjectContext *)ctx
{
    return [NSEntityDescription entityForName:@"Cat" inManagedObjectContext:ctx];
}

+ (NSArray *)catsFromPlist:(NSString *)plistPath andContext:(NSManagedObjectContext *)ctx
{
    NSString *plpath = [[NSBundle mainBundle] pathForResource:plistPath ofType:@""];
    NSAssert(plpath, @"catlist.plist not found");
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:plpath];
    NSAssert(plist, @"catlist.plist incorrect format: %@", plist);

    NSArray *catDict = [plist objectForKey:@"cats"];
    NSAssert(catDict, @"catlist.plist incorrect format: %@", catDict);

    NSMutableArray *cats = [NSMutableArray new];

    for (NSDictionary *dict in catDict) {
        Cat *kitten = [[Cat alloc] initWithDict:dict andContext:ctx];
        NSAssert(kitten, @"Error loading kitten in %@", dict);
        [cats addObject:kitten];
    }

    NSError *err;
    [ctx save:&err];
    NSAssert(err == nil, @"DB save error: %@", [err localizedDescription]);

    return [cats copy];
}


#pragma mark - Static

+ (NSArray *)loadFromPlistToContext:(NSManagedObjectContext *)context
{
    NSArray *catArray = [self catsFromPlist:@"catlist.plist" andContext:context];
    NSLog(@"loaded %d cats from plist", catArray.count);
    return catArray;
}

#pragma mark Public methods

+ (NSArray *)catsWithContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [Cat entityFromContext:context];
    NSArray *catArray = [context execFetch:fetchRequest];

    if (catArray.count == 0) {
        [self loadFromPlistToContext:context];
    }

    return catArray;
}

+ (NSInteger)countWithContext:(NSManagedObjectContext *)context
{
    return [[self catsWithContext:context] count];
}

+ (NSArray *)catsOnSaleFromContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [Cat entityFromContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"price > 0"];

    return [context execFetch:fetchRequest];
}

+ (Cat *)catWithId:(NSManagedObjectID *)CatId andContext:(NSManagedObjectContext *)context;
{
    if (CatId == nil) {
        return nil;
    }

    NSError *err;
    Cat *cat = (Cat *) [context existingObjectWithID:CatId error:&err];
    if (err) {
        NSLog(@"Fetching catWithId failed: %@", [err localizedDescription]);
    }
    return cat;

//TODO: test this
//
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    fetchRequest.entity = [Cat entityFromContext:context];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self == %@", CatId];
//
//    NSArray *result = [DBManager execFetch:fetchRequest withContext:context];
//
//    if (result.count > 0) {
//        return [result objectAtIndex:0];
//    }
//
//    return nil;
}

- (void)delete
{
    [self deleteImageFromDisk];

    [self.managedObjectContext deleteObject:self];

    NSError *err;
    [self.managedObjectContext save:&err];
    NSAssert(err == nil, @"Error saving context: %@", [err localizedDescription]);
}

- (NSString *)imageFolder
{
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    folderPath = [folderPath stringByAppendingPathComponent:@"Images"];

    NSError *err;
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        NSLog(@"error creating folder: %@", [err localizedDescription]);
    }
    return folderPath;
}

- (void)deleteImageFromDisk
{
    // if path is not pointing to app bundle
    if (self.imagePath.length > 0
            && ![self.imagePath isEqualToString:[self.imagePath lastPathComponent]]) {
        NSError *err;
        [[NSFileManager defaultManager] removeItemAtPath:self.imagePath error:&err];
        if (err) {
            NSLog(@"cat image deletion failed: %@", [err localizedDescription]);
        }
    }
}

- (void)saveImageToDisk
{
    if (image) {
        [self deleteImageFromDisk];

        CFUUIDRef uuid = CFUUIDCreate(nil);
        NSString *uuidStr = (__bridge_transfer NSString *) CFUUIDCreateString(nil, uuid);
        CFRelease(uuid);

        NSString *imgPath = [[self imageFolder] stringByAppendingPathComponent:[uuidStr stringByAppendingFormat:@".png"]];

        if (![UIImagePNGRepresentation(image) writeToFile:imgPath atomically:YES]) {
            NSLog(@"Error saving image for cat %@ to path: %@", self.objectID, imgPath);
        }

        self.imagePath = imgPath;
        image = nil;
        NSLog(@"imgPath: %@", imgPath);
    }

}

- (void)save
{
    NSError *err;
    [self.managedObjectContext save:&err];
    NSAssert(err == nil, @"Error saving context: %@", [err localizedDescription]);
}

- (void)willSave
{
    if ([self isDeleted]) {
        [self deleteImageFromDisk];
    } else {
        [self saveImageToDisk];
    }
}

#pragma mark - Instance


#pragma Properties

- (void)setImage:(UIImage *)img
{
    image = img;
}

- (UIImage *)image
{
    return image ? image : [UIImage imageWithContentsOfFile:self.imagePath];
}

+ (NSString *)genderByBool:(BOOL)gender
{
    static NSDictionary *genders;

    if (genders == nil) {
        NSString *plPath = [[NSBundle mainBundle] pathForResource:@"gender.plist" ofType:@""];
        NSAssert(plPath, @"gender.plist not found");
        genders = [[NSDictionary alloc] initWithContentsOfFile:plPath];
        NSAssert(genders, @"gender.plist incorrect format: %@", genders);
    }

    return (gender ? [genders objectForKey:@"male"] : [genders objectForKey:@"female"]);
}

- (NSString *)gender
{
    return [Cat genderByBool:self.male];
}

#pragma Lifetime


- (id)initWithDict:(NSDictionary *)dict andContext:(NSManagedObjectContext *)ctx
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

    if ((self = [self initWithEntity:[Cat entityFromContext:ctx] insertIntoManagedObjectContext:ctx])) {
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
