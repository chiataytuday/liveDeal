//
//  NSString+UrlEncode.m
//  liveDeal
//
//  Created by claudio barbera on 31/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)

-(NSString*) urlEncode
{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    return encodedString;
}
@end
