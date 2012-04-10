#import <CoreData/CoreData.h>

@interface Cat : NSManagedObject

+ (NSArray*) cats;
+ (NSInteger) count;

+ (NSArray*) catsOnSale;

+ (Cat*) catWithId:(NSInteger)CatId;

+ (NSEntityDescription *)entityFromContext:(NSManagedObjectContext *)ctx;


- (id)init;
- (void)save;
- (void)delete;

#pragma mark - Property

@property (copy) NSString *imagePath;
@property (copy) NSString *name;
@property (copy) NSString *breed;
@property (copy) NSDate *birth;
@property (assign) BOOL male;
@property (assign) NSInteger price;
@property (assign) NSInteger rating;

@property (readonly) NSString *gender;
@property (readonly) UIImage *image;

#pragma mark - Genealogy

@property (assign) NSInteger myId;
@property (assign) NSInteger fatherId;
@property (assign) NSInteger motherId;

@end
