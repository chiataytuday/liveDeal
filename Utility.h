
#import <Foundation/Foundation.h>
#import "User.h"

@interface Utility : NSObject {
	

}


+(NSString *)getValiditaWithDataInizio:(NSString *)dataInizio andDataScadenza:(NSString *)dataScadenza;
+ (User *) UserFromToken:(NSString *)tokenAccess;
+(NSString *)getStringFromHours:(NSDate *)d;
+ (void) hideGradientBackground:(UIView*)theView;

@end
