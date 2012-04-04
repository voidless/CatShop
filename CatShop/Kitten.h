#import <Foundation/Foundation.h>

@interface Kitten : NSObject

+ (NSArray*) kittens;

+ (NSArray*) kittensOnSale;

+ (Kitten*) kittenWithKittenId:(NSInteger)kittenId;

+ (NSInteger) kittensCount;

#pragma mark Sorting

+ (Kitten*) kittenSortedAtIndex:(NSInteger)index;

+ (void) moveKittenSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx;

#pragma mark - Property

@property (strong) NSString *imagePath;
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
