#import <CoreData/CoreData.h>

@interface Cat : NSManagedObject

+ (NSArray *)catsWithContext:(NSManagedObjectContext *)context;

+ (NSInteger)countWithContext:(NSManagedObjectContext *)context;

+ (NSArray *)catsOnSaleFromContext:(NSManagedObjectContext *)context;

+ (Cat *)catWithId:(NSManagedObjectID *)CatId andContext:(NSManagedObjectContext *)context;


+ (NSEntityDescription *)entityFromContext:(NSManagedObjectContext *)ctx;

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
@property (strong) UIImage *image;

#pragma mark - Genealogy

@property (assign) NSInteger myId;
@property (assign) NSInteger fatherId;
@property (assign) NSInteger motherId;

@end
