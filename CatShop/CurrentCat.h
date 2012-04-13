#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CurrentCat : NSObject

@property (strong) NSManagedObjectID *currentCatId;

- (id)initWithContext:(NSManagedObjectContext *)context;

@end
