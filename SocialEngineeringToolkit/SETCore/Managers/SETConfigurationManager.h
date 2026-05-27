//
//  SETConfigurationManager.h
//  Social Engineering Toolkit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SETConfigurationManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary *currentConfig;
@property (nonatomic, assign) NSInteger serverPort;
@property (nonatomic, copy) NSString *serverIP;
@property (nonatomic, assign) BOOL enableLogging;

+ (instancetype)sharedManager;
- (BOOL)loadConfigurationFromFile:(NSString *)filePath;
- (BOOL)saveConfiguration;
- (id)valueForConfigKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
