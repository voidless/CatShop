#import <Foundation/Foundation.h>

@protocol DatePickerDelegate <NSObject>

- (void)datePicked:(NSDate *)date withDateString:(NSString *)dateString;

@end
