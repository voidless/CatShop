#import "CurrentCat.h"
#import "DBModel.h"

@interface CurrentCat ()

#define CURRENT_CAT_OBJECT_KEY @"currentCatObjectKey"

@end


@implementation CurrentCat {
    NSManagedObjectID * _currentCatId;
}

- (NSManagedObjectID *)currentCatId
{
    if (_currentCatId == nil)
    {
        NSPersistentStoreCoordinator *store = [[DBModel dbModel] persistentStoreCoordinator];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSURL *url = [ud URLForKey:CURRENT_CAT_OBJECT_KEY];
        _currentCatId = [store managedObjectIDForURIRepresentation:url];
    }
    return _currentCatId;
}

- (void)setCurrentCatId:(NSManagedObjectID *)currentCatId
{
    _currentCatId = currentCatId;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setURL:[currentCatId URIRepresentation] forKey:CURRENT_CAT_OBJECT_KEY];
    [ud synchronize];
}

+ (CurrentCat *)currentCat
{
    static CurrentCat *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

@end
