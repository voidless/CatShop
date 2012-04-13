#import "CurrentCat.h"

@interface CurrentCat ()

#define CURRENT_CAT_OBJECT_KEY @"currentCatObjectKey"

@property (strong) NSManagedObjectContext *context;

@end


@implementation CurrentCat

@synthesize currentCatId;
@synthesize context;

- (id)initWithContext:(NSManagedObjectContext *)ctx
{
    if ((self = [self init])) {
        context = ctx;
    }
    return self;
}

- (NSManagedObjectID *)currentCatId
{
    if (currentCatId == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSURL *url = [ud URLForKey:CURRENT_CAT_OBJECT_KEY];
        currentCatId = [[context persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
    }
    return currentCatId;
}

- (void)setCurrentCatId:(NSManagedObjectID *)catId
{
    NSAssert(currentCatId.isTemporaryID == NO, @"setCurrentCatId received temporary id: %@", currentCatId);

    currentCatId = catId;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setURL:[currentCatId URIRepresentation] forKey:CURRENT_CAT_OBJECT_KEY];

    [ud synchronize];
}

@end
