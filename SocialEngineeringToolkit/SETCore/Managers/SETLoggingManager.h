//
//  SETLoggingManager.h
//  Social Engineering Toolkit
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SETLogLevel) {
    SETLogLevelDebug,
    SETLogLevelInfo,
    SETLogLevelWarning,
    SETLogLevelError
};

NS_ASSUME_NONNULL_BEGIN

@interface SETLoggingManager : NSObject

@property (nonatomic, assign) SETLogLevel currentLogLevel;

+ (instancetype)sharedLogger;
- (void)logMessage:(NSString *)message withLevel:(SETLogLevel)level;
- (void)logCredential:(NSString *)username password:(NSString *)password fromSource:(NSString *)source;
- (NSString *)getLogFilePath;

@end

NS_ASSUME_NONNULL_END
