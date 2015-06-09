//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "DurationFormatter.h"

@interface DurationFormatter ()
@end

@implementation DurationFormatter
- (NSString *)formattedValue:(id)value
{
    NSInteger seconds = [value integerValue];
    NSInteger minutes = (NSInteger)floorf(seconds / 60.0f);
    NSInteger hours = (NSInteger)floorf(minutes / 60.0f);

    NSString *formattedValue = nil;

    if (hours > 0) {
        formattedValue = hours == 1 ? [NSString stringWithFormat:NSLocalizedString(@"format_hour", nil), hours] : [NSString stringWithFormat:NSLocalizedString(@"format_hours", nil), hours];
    } else if (minutes > 0) {
        formattedValue = minutes == 1 ? [NSString stringWithFormat:NSLocalizedString(@"format_minute", nil), minutes] : [NSString stringWithFormat:NSLocalizedString(@"format_minutes", nil), minutes];
    } else {
        formattedValue = [NSString stringWithFormat:NSLocalizedString(@"format_seconds", nil), seconds];
    }

    return formattedValue;
}
@end