#import <Foundation/Foundation.h>

@interface Cat : NSObject

+ (NSArray*) cats;
+ (NSInteger) count;

+ (NSArray*) catsOnSale;

+ (Cat*) catWithId:(NSInteger)CatId;

#pragma mark - Property

@property (strong) NSString *imagePath;
@property (readonly) UIImage *image;

@property (strong) NSString *name;

@property BOOL male;
@property (readonly) NSString* gender;

@property (strong) NSString *breed;
@property NSInteger price;
@property (strong) NSDate *birth;

#pragma mark - Genealogy

@property NSInteger myId;
@property NSInteger fatherId;
@property NSInteger motherId;

@end
