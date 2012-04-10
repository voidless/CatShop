#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CurrentCat : NSObject

+ (CurrentCat *)currentCat;

@property (strong) NSManagedObjectID *currentCatId;

@end
