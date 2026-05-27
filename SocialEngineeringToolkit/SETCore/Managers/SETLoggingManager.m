//
//  SETLoggingManager.m
//  Social Engineering Toolkit
//

#import "SETLoggingManager.h"

@implementation SETLoggingManager

+ (instancetype)sharedLogger {
    static SETLoggingManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentLogLevel = SETLogLevelInfo;
        
        // Create log directory
        NSString *logPath = [self getLogFilePath];
        NSString *logDir = [logPath stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:logDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return self;
}

- (void)logMessage:(NSString *)message withLevel:(SETLogLevel)level {
    if (level < self.currentLogLevel) return;
    
    NSString *levelStr;
    switch (level) {
        case SETLogLevelDebug: levelStr = @"DEBUG"; break;
        case SETLogLevelInfo: levelStr = @"INFO"; break;
        case SETLogLevelWarning: levelStr = @"WARNING"; break;
        case SETLogLevelError: levelStr = @"ERROR"; break;
    }
    
    NSString *timestamp = [[NSDate date] description];
    NSString *logEntry = [NSString stringWithFormat:@"[%@] [%@] %@\n", timestamp, levelStr, message];
    
    // Log to console
    printf("%s", [logEntry UTF8String]);
    
    // Write to file
    NSString *logPath = [self getLogFilePath];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    if (!fileHandle) {
        [logEntry writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[logEntry dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

- (void)logCredential:(NSString *)username password:(NSString *)password fromSource:(NSString *)source {
    NSString *credLog = [NSString stringWithFormat:@"CAPTURED: [Source:%@] Username:%@ Password:%@",
                        source, username, password];
    [self logMessage:credLog withLevel:SETLogLevelWarning];
}

- (NSString *)getLogFilePath {
    NSString *logPath = [NSString stringWithFormat:@"~/Library/Logs/SEToolkit/setoolkit_%@.log",
                        [[NSDate date] description]];
    return [logPath stringByExpandingTildeInPath];
}

@end
