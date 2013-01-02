
#import <Foundation/Foundation.h>



@interface Utility : NSObject {
	

}


+(NSString *)getValiditaWithDataInizio:(NSString *)dataInizio andDataScadenza:(NSString *)dataScadenza;
+(BOOL) isTokenValidWithToken:(NSString *)token;

@end
