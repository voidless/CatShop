#import "NSDateFormatter+CatDateFormatter.h"

@implementation NSDateFormatter (CatDateFormatter)

+ (NSDateFormatter *)catDateFormatter
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    
    return dateFormatter;
}

@end
