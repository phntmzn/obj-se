//
//  CredentialHarvester.h
//  Social Engineering Toolkit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CredentialHarvester : NSObject

- (void)startHarvestingWithURL:(NSString *)urlToClone onPort:(NSInteger)port;
- (void)stopHarvesting;
- (BOOL)cloneLoginPage:(NSString *)sourceURL toLocalPath:(NSString *)localPath;

@end

NS_ASSUME_NONNULL_END
