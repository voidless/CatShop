#import <Foundation/Foundation.h>

@protocol DatePickerControllerDelegate <NSObject>

- (void)datePicked:(NSDate *)date withDateString:(NSString *)dateString;

@end
