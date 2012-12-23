//
//  Utility.m
//  liveDeal
//
//  Created by claudio barbera on 16/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+(NSString *)getValiditaWithDataInizio:(NSString *)dataInizio andDataScadenza:(NSString *)dataScadenza
{
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *to = [dateformatter dateFromString:dataInizio];
    NSDate *from = [dateformatter dateFromString:dataScadenza];
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *componentsDiff = [gregorian components:unitFlags fromDate:today toDate:from options:0];
    NSDateComponents *componentsTo = [gregorian components:unitFlags fromDate:to];
    NSDateComponents *componentsFrom = [gregorian components:unitFlags fromDate:from];
    
    NSString *res = [NSString stringWithFormat:@"Utilizzabile %@ dalle %d:%d alle %d:%d",
                        componentsDiff.day == 1 ? @"domani" : @"oggi",
                        componentsTo.hour,
                        componentsTo.minute ,
                        componentsFrom.hour,
                        componentsFrom.minute];
    
    return res;
}
@end